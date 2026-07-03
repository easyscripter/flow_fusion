enum Routes {
  home('/'),
  sessions('/sessions'),
  sessionNew('/sessions/new'),
  sessionEdit('/sessions/edit/:id'),
  timer('/timer'),
  settings('/settings');

  const Routes(this.path);
  final String path;

  static String sessionEditPathFor(int id) => '/sessions/edit/$id';
}
