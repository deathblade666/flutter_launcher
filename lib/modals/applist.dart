import 'package:flutter/material.dart';
import 'package:flutter_launcher/modals/widgets/utils/favorites.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Applist extends StatefulWidget {
  Applist(
    this._searchController, 
    this.focusOnSearch, 
    this._filteredItems,
    this.prefs,
    {required this.onTap,
    super.key
    }
  );

  TextEditingController _searchController;
  SharedPreferences prefs;
  FocusNode focusOnSearch;
  List<AppInfo> _filteredItems = [];
  final Function(bool? showAppList,bool? hideDate, bool? hideMainGesture) onTap;

  
  @override
  State<Applist> createState() => _ApplistState();
}

class _ApplistState extends State<Applist> {
  var _tapPosition;
  List<String> installedApps = [];
  bool? hideDate1; 
  bool? hideMainGesture1; 
  bool? showAppList1;

  @override
  void initState(){
    _tapPosition = const Offset(0.0, 0.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder( reverse: true, shrinkWrap: true, itemCount: widget._filteredItems.length, itemBuilder: (context, index){
      AppInfo app = widget._filteredItems[index];
      return SizedBox(
        height: 50,
        child: GestureDetector(
          onTapDown: (details){
            setState(() {
              _tapPosition = details.globalPosition;
            });
          },
          child: ListTile(
            onLongPress: () async {
              double left = _tapPosition.dx -110;
              double top = _tapPosition.dy;
              double right = _tapPosition.dx ;
              await showMenu(
                context: context,
                position: RelativeRect.fromLTRB(left, top, right, 0),
                items: [
                  PopupMenuItem(
                    child: const Text("App Settings"),
                    onTap: () {
                      InstalledApps.openSettings(app.packageName);
                      setState(() {
                          showAppList1 = false;
                          hideDate1 = true;
                          hideMainGesture1 = true;
                        });
                        widget.onTap(showAppList1, hideDate1, hideMainGesture1);
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("Add to Favorites"),
                    onTap: () {
                      List<String> favoriteApps = widget.prefs.getStringList("FavoritesAppsList") ?? [];
                      setState(() {
                        favoriteApps.add(app.packageName);
                        widget.prefs.setStringList("FavoritesAppsList", favoriteApps);
                      });
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("Uninstall"),
                    onTap: () async {
                      bool? uninstall = await InstalledApps.uninstallApp(app.packageName);
                      if (uninstall == true){
                        setState(() {
                          showAppList1 = false;
                          hideDate1 = true;
                          hideMainGesture1 = true;
                        });
                        widget.onTap(showAppList1, hideDate1, hideMainGesture1);
                      }
                    }, 
                  )
                ]
              );
            },
            onTap: () {
              widget.focusOnSearch.unfocus();
              widget._searchController.clear();
              InstalledApps.startApp(app.packageName);
              setState(() {
                showAppList1 = false;
                hideDate1 = true;
                hideMainGesture1 = true;
              });
              widget.onTap(showAppList1, hideDate1, hideMainGesture1);
            },
            leading: app.icon != null
              ? Image.memory(app.icon!, height: 30,)
              : const Icon(Icons.android),
            title: Text(app.name),
          )
        )
      );
    });
  }
}