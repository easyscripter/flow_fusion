import 'package:flutter/material.dart';

class SessionIcons {
  const SessionIcons._();

  static const String fallback = 'layers';

  static const Map<String, IconData> _byName = {
    'layers': Icons.layers_rounded,
    'bolt': Icons.bolt_rounded,
    'book': Icons.menu_book_rounded,
    'code': Icons.code_rounded,
    'brush': Icons.brush_rounded,
    'fitness': Icons.fitness_center_rounded,
    'target': Icons.track_changes_rounded,
    'coffee': Icons.coffee_rounded,
    'music': Icons.music_note_rounded,
    'leaf': Icons.eco_rounded,
  };

  static List<String> get names => _byName.keys.toList(growable: false);

  static IconData resolve(String? name) => _byName[name] ?? _byName[fallback]!;
}
