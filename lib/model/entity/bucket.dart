import 'package:freezed_annotation/freezed_annotation.dart';

part 'bucket.freezed.dart';
part 'bucket.g.dart';

// As an example
@freezed
abstract class Bucket with _$Bucket {
  const factory Bucket({required String name, required int volume}) = _Bucket;

  factory Bucket.fromJson(Map<String, Object?> json) => _$BucketFromJson(json);
}
