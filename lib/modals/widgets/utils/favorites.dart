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
  List favorites = [];
  List favoritApps = [];
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
    List? items = widget.prefs.getStringList("FavoritesAppsList");
    if (items != null){
      setState(() {
        widget.favorites = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const int maxItems = 8;
    final int itemCount = (widget.favorites.length > maxItems) ? maxItems : widget.favorites.length;
    
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(itemCount, (index) {
              final application = widget.favoritApps[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  child: IconButton(
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    padding: EdgeInsets.zero,
                    icon: application.icon != null
                      ? Image.memory(
                          application.icon!,
                          height: 30,
                          width: 30,
                          fit: BoxFit.contain,
                        )
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
                      widget.favoritApps.remove(index);
                      widget.prefs.setStringList("FavoritesAppsList", favorites);
                    });
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}