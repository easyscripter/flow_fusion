abstract class SystemProxyConfigurator {
  Future<bool> enable(int port);

  Future<void> disable();

  Future<void> selfHeal();
}
