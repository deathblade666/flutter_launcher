import 'package:flutter/material.dart';
import 'package:flutter_launcher/widgets/utils/widget_utils.dart';
import 'package:flutter_launcher/widgets/utils/widgetchangenotifier.dart';
import 'package:flutter_launcher/widgets/widget_options.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class pages extends StatefulWidget {
  pages(this.prefs,{super.key});
  SharedPreferences prefs;

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
        lastPage = restoreLastPage!;
        _pageController.jumpToPage(lastPage);
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
            Widgetoptions(widget.prefs),
            ...getVisibleWidgets(),
          ],
        ),
      ),
    );
  }
}