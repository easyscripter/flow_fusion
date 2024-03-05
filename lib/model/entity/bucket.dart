import 'package:freezed_annotation/freezed_annotation.dart';

part 'bucket.freezed.dart';
part 'bucket.g.dart';

@freezed
class Bucket with _$Bucket {
  factory Bucket({
    required String name,
    required int volume,
  }) = _Bucket;

  factory Bucket.fromJson(Map<String, dynamic> json) => _$BucketFromJson(json);
}
