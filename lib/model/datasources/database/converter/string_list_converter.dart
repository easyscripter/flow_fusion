import 'dart:convert';

import 'package:froom/froom.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    if (databaseValue.isEmpty) return const <String>[];
    final List<dynamic> raw = jsonDecode(databaseValue) as List<dynamic>;
    return raw.map((dynamic e) => e as String).toList();
  }

  @override
  String encode(List<String> value) {
    return jsonEncode(value);
  }
}
