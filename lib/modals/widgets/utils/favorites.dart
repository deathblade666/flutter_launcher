import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteApps extends StatefulWidget {
  FavoriteApps(
    this.prefs, 
    {
      required this.favoritApps,
      super.key
    }
  );
  List<String> favorites = [];
  List<AppInfo> favoritApps = [];
  SharedPreferences prefs;

  @override
  State<FavoriteApps> createState() => _FavoriteAppsState();
}

class _FavoriteAppsState extends State<FavoriteApps> {
  var _tapPosition;

  @override
  void initState() {
    loadPrefs();
    _tapPosition = const Offset(0.0, 0.0);
    super.initState();
  }
  
  void loadPrefs(){
    List<String>? items = widget.prefs.getStringList("FavoritesAppsList");
    if (items != null){
      setState(() {
        widget.favorites = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const int maxItems = 8;
    
    return ListView.builder(
      itemCount: (widget.favorites.length > maxItems) ? maxItems : widget.favorites.length,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final application= widget.favoritApps[index];
        return GestureDetector(
          child: IconButton(
            icon:  application.icon != null
              ? Image.memory(application.icon!, height: 30)
              : const Icon(Icons.add),
            onPressed: () {
              InstalledApps.startApp(application.packageName);
            },
          ),
          onLongPress: () {
            List<String> favorites = widget.prefs.getStringList("FavoritesAppsList") ?? [];
            setState(() {
              favorites.remove(widget.favorites[index]);
              widget.favorites.removeAt(index);
              print('$index');
              widget.prefs.setStringList("FavoritesAppsList", favorites);
            });
          },
        );
      },
    );
  }
}