class InstalledApp {
  const InstalledApp({
    required this.name,
    required this.bundleId,
    this.iconBase64,
  });

  final String name;
  final String bundleId;

  final String? iconBase64;
}
