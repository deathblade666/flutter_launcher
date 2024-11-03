import 'package:flutter/material.dart';
import 'package:flutter_launcher/modals/widgets/settings.dart';
import 'package:flutter_launcher/utils/ui_toggles.dart';
import 'package:flutter_launcher/modals/widgets/utils/widget_utils.dart';
import 'package:flutter_launcher/modals/widgets/utils/widgetchangenotifier.dart';
import 'package:installed_apps/app_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class pages extends StatefulWidget {
  pages(this.prefs,{
    required this.Toggles,
    required this.apps,
    super.key
    }
  );
  SharedPreferences prefs;
  final HomeToggles Toggles;
  List<AppInfo> apps = [];

  @override
  State<pages> createState() => _pagesState();
}

class _pagesState extends State<pages> {
  List<Widget> initialItems = [];
  late WidgetList widgets = WidgetList(widgets: initialItems, prefs: widget.prefs);
  int lastPage = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    initialItems = widgets.getWidgets();
    loadPrefs();
    super.initState();
  }

  void loadPrefs()async{
    int? restoreLastPage = widget.prefs.getInt("Page");
    if (restoreLastPage != 0){
      await Future.delayed(const Duration(milliseconds: 1));
      setState(()  {
        if (restoreLastPage != null){
          lastPage = restoreLastPage;
        }
        _pageController.jumpToPage(1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    getVisibleWidgets() {
      final visibilityState = Provider.of<WidgetVisibilityState>(context);
      return visibilityState.order
        .where((index) => visibilityState.visibility[index])
        .map((index) => initialItems[index])
        .toList();
    }
    _pageController = PageController(initialPage: lastPage);
  
    
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: 500,
        child: PageView(
          controller: _pageController,
          onPageChanged: (int page){
            lastPage = page;
            widget.prefs.setInt("Page", page);
          },
          children: [
            settingeMenu(widget.prefs, widget.apps, Toggles: widget.Toggles),
            ...getVisibleWidgets(),
          ],
        ),
      ),
    );
  }
}