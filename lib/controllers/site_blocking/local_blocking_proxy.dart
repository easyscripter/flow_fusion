import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flow_fusion/utils/app_logger.dart';

class LocalBlockingProxy {
  static const int _maxHeaderBytes = 16 * 1024;

  ServerSocket? _server;
  final Set<String> _blockedDomains = <String>{};
  final Set<_ActiveRelay> _activeRelays = <_ActiveRelay>{};

  int? get port => _server?.port;
  bool get isRunning => _server != null;

  Future<int> start() async {
    final ServerSocket? existing = _server;
    if (existing != null) return existing.port;

    final ServerSocket server = await ServerSocket.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    _server = server;
    server.listen(
      (Socket client) {
        unawaited(
          _handleClient(client).catchError((Object e, StackTrace s) {
            AppLogger.error('LocalBlockingProxy._handleClient', e, s);
            client.destroy();
          }),
        );
      },
      onError: (Object e, StackTrace s) =>
          AppLogger.error('LocalBlockingProxy.server', e, s),
    );
    return server.port;
  }

  Future<void> stop() async {
    final ServerSocket? server = _server;
    _server = null;
    await server?.close();
  }

  void updateBlockedDomains(Iterable<String> domains) {
    _blockedDomains
      ..clear()
      ..addAll(domains);

    for (final _ActiveRelay relay in _activeRelays.toList()) {
      if (_isBlocked(relay.host)) {
        relay.client.destroy();
        relay.upstream.destroy();
      }
    }
  }

  bool _isBlocked(String host) {
    final String needle = host.toLowerCase();
    for (final String domain in _blockedDomains) {
      if (needle == domain || needle.endsWith('.$domain')) return true;
    }
    return false;
  }

  Future<void> _handleClient(Socket client) async {
    client.setOption(SocketOption.tcpNoDelay, true);
    // A failed write can surface asynchronously, after the data was already
    // queued — Dart reports that through the sink's `done` future, not
    // through the `add()` call itself. Left unhandled, it becomes an
    // uncaught exception in the ambient zone (e.g. when the peer resets the
    // connection mid-relay).
    unawaited(client.done.catchError((Object _) {}));
    late StreamSubscription<Uint8List> sub;
    final List<int> buffer = <int>[];
    final Completer<_ParsedRequest?> headersCompleter =
        Completer<_ParsedRequest?>();

    sub = client.listen(
      (Uint8List data) {
        buffer.addAll(data);
        final int idx = _indexOfHeaderEnd(buffer);
        if (idx != -1) {
          sub.pause();
          final List<int> headerBytes = buffer.sublist(0, idx + 4);
          final List<int> remainder = buffer.sublist(idx + 4);
          if (!headersCompleter.isCompleted) {
            headersCompleter.complete(_parseRequest(headerBytes, remainder));
          }
        } else if (buffer.length > _maxHeaderBytes) {
          sub.cancel();
          if (!headersCompleter.isCompleted) headersCompleter.complete(null);
        }
      },
      onDone: () {
        if (!headersCompleter.isCompleted) headersCompleter.complete(null);
      },
      onError: (Object _) {
        if (!headersCompleter.isCompleted) headersCompleter.complete(null);
      },
      cancelOnError: true,
    );

    final _ParsedRequest? request = await headersCompleter.future;
    if (request == null) {
      await sub.cancel();
      client.destroy();
      return;
    }

    if (_isBlocked(request.host)) {
      final String status = request.isConnect
          ? 'HTTP/1.1 502 Blocked by Flow Fusion'
          : 'HTTP/1.1 403 Forbidden';
      try {
        client.add(utf8.encode('$status\r\n\r\n'));
        await client.flush();
      } catch (_) {
        // Client already gone — nothing to notify.
      }
      await sub.cancel();
      client.destroy();
      return;
    }

    Socket upstream;
    try {
      upstream = await Socket.connect(
        request.host,
        request.port,
        timeout: const Duration(seconds: 10),
      );
    } catch (_) {
      await sub.cancel();
      client.destroy();
      return;
    }
    upstream.setOption(SocketOption.tcpNoDelay, true);
    unawaited(upstream.done.catchError((Object _) {}));

    try {
      if (request.isConnect) {
        client.add(utf8.encode('HTTP/1.1 200 Connection Established\r\n\r\n'));
        if (request.remainderBytes.isNotEmpty) {
          upstream.add(request.remainderBytes);
        }
      } else {
        upstream.add(request.headerBytes);
        upstream.add(request.remainderBytes);
      }
    } catch (_) {
      await sub.cancel();
      client.destroy();
      upstream.destroy();
      return;
    }

    _relay(sub, client, upstream, request.host);
  }

  void _relay(
    StreamSubscription<Uint8List> clientSub,
    Socket client,
    Socket upstream,
    String host,
  ) {
    final _ActiveRelay relay = _ActiveRelay(host, client, upstream);
    _activeRelays.add(relay);

    bool closed = false;
    void closeBoth() {
      if (closed) return;
      closed = true;
      _activeRelays.remove(relay);
      unawaited(clientSub.cancel());
      client.destroy();
      upstream.destroy();
    }

    void safeAdd(Socket target, Uint8List data) {
      try {
        target.add(data);
      } catch (_) {
        closeBoth();
      }
    }

    clientSub
      ..onData((Uint8List data) => safeAdd(upstream, data))
      ..onDone(closeBoth)
      ..onError((Object _) => closeBoth())
      ..resume();

    upstream.listen(
      (Uint8List data) => safeAdd(client, data),
      onDone: closeBoth,
      onError: (Object _) => closeBoth(),
      cancelOnError: true,
    );
  }

  int _indexOfHeaderEnd(List<int> bytes) {
    for (int i = 0; i + 3 < bytes.length; i++) {
      if (bytes[i] == 13 &&
          bytes[i + 1] == 10 &&
          bytes[i + 2] == 13 &&
          bytes[i + 3] == 10) {
        return i;
      }
    }
    return -1;
  }

  _ParsedRequest? _parseRequest(
    List<int> headerBytes,
    List<int> remainderBytes,
  ) {
    final String headerText = utf8.decode(headerBytes, allowMalformed: true);
    final List<String> lines = headerText.split('\r\n');
    if (lines.isEmpty) return null;

    final List<String> requestLine = lines.first.split(' ');
    if (requestLine.length < 2) return null;

    final String method = requestLine[0].toUpperCase();
    final String target = requestLine[1];

    if (method == 'CONNECT') {
      final int colon = target.lastIndexOf(':');
      if (colon == -1) return null;
      final String host = target.substring(0, colon);
      final int port = int.tryParse(target.substring(colon + 1)) ?? 443;
      if (host.isEmpty) return null;
      return _ParsedRequest(
        isConnect: true,
        host: host,
        port: port,
        headerBytes: headerBytes,
        remainderBytes: remainderBytes,
      );
    }

    String? host;
    int port = 80;
    for (final String line in lines.skip(1)) {
      if (line.toLowerCase().startsWith('host:')) {
        final String value = line.substring(5).trim();
        final int colon = value.lastIndexOf(':');
        if (colon != -1 && !value.contains(']')) {
          host = value.substring(0, colon);
          port = int.tryParse(value.substring(colon + 1)) ?? 80;
        } else {
          host = value;
        }
        break;
      }
    }
    host ??= _hostFromAbsoluteUri(target);
    if (host == null || host.isEmpty) return null;

    return _ParsedRequest(
      isConnect: false,
      host: host,
      port: port,
      headerBytes: headerBytes,
      remainderBytes: remainderBytes,
    );
  }

  String? _hostFromAbsoluteUri(String target) {
    final Uri? uri = Uri.tryParse(target);
    if (uri == null || uri.host.isEmpty) return null;
    return uri.host;
  }
}

class _ActiveRelay {
  _ActiveRelay(this.host, this.client, this.upstream);

  final String host;
  final Socket client;
  final Socket upstream;
}

class _ParsedRequest {
  _ParsedRequest({
    required this.isConnect,
    required this.host,
    required this.port,
    required this.headerBytes,
    required this.remainderBytes,
  });

  final bool isConnect;
  final String host;
  final int port;
  final List<int> headerBytes;
  final List<int> remainderBytes;
}
