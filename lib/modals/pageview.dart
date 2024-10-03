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
  List<bool> visibilityStates = [true, true, true, true];
  int lastPage = 0;
  @override
  void initState() {
    initialItems = widgets.getWidgets();
    loadPrefs();
    super.initState();
  }

  void loadPrefs(){
    int? restoreLastPage = widget.prefs.getInt("Page");
    if (restoreLastPage != null){
      setState(() {
        lastPage = restoreLastPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
     final visibilityState = Provider.of<WidgetVisibilityState>(context);

    Future<List<Widget>> getVisibleWidgets() async {
      return visibilityState.order
        .where((index) => visibilityState.visibility[index])
        .map((index) => initialItems[index])
        .toList();
    }

    return FutureBuilder<List<Widget>>(
      future: getVisibleWidgets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Widgetoptions(widget.prefs);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Widget> visibleWidgets = snapshot.data ?? [];
          PageController _pageController = PageController(initialPage: lastPage);
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
                  ...visibleWidgets,
                ],
              ),
            ),
          );
        }
      }
    );
  }
}