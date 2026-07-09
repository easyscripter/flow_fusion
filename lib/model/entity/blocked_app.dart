class BlockedApp {
  const BlockedApp({
    required this.name,
    this.bundleId,
    this.executable,
  });

  final String name;

  final String? bundleId;

  final String? executable;

  factory BlockedApp.fromJson(Map<String, dynamic> json) {
    return BlockedApp(
      name: json['name'] as String,
      bundleId: json['bundleId'] as String?,
      executable: json['executable'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'bundleId': bundleId,
      'executable': executable,
    };
  }

  @override
  bool operator ==(Object other) =>
      other is BlockedApp &&
      other.name == name &&
      other.bundleId == bundleId &&
      other.executable == executable;

  @override
  int get hashCode => Object.hash(name, bundleId, executable);
}
