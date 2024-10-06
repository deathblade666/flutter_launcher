class HomeToggles{
  final void Function(String provider) searchProvider;
  final void Function(bool toggleStats) toggleStatusBar;
  final void Function(bool widgetsEnabled) widgetToggle;
  final void Function(String appName, int appNumber) pinnedApp;
  final void Function(bool togglePinApp) pinAppToggle;
  //final void Function(String appName, int appNumber)? onClear;

  HomeToggles({
    required this.pinAppToggle,
    required this.pinnedApp,
    required this.searchProvider,
    required this.toggleStatusBar,
    required this.widgetToggle,
  });
}