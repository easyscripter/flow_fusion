enum Routes {
  home('/'),
  sessions('/sessions'),
  settings('/settings');

  const Routes(this.path);
  final String path;
}