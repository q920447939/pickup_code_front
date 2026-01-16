enum AppMode { offline, ai }

extension AppModeLabel on AppMode {
  String get label {
    switch (this) {
      case AppMode.offline:
        return '离线模式';
      case AppMode.ai:
        return 'AI 模式';
    }
  }
}
