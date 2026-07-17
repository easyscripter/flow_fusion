import 'dart:convert';

import 'package:froom/froom.dart';
import 'package:flow_fusion/model/entity/blocked_app.dart';

class BlockedAppListConverter extends TypeConverter<List<BlockedApp>, String> {
  @override
  List<BlockedApp> decode(String databaseValue) {
    if (databaseValue.isEmpty) return const <BlockedApp>[];
    final List<dynamic> raw = jsonDecode(databaseValue) as List<dynamic>;
    return raw
        .map((dynamic e) => BlockedApp.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  String encode(List<BlockedApp> value) {
    return jsonEncode(
      value.map((BlockedApp app) => app.toJson()).toList(),
    );
  }
}
