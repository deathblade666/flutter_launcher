import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Webview extends StatefulWidget {
  Webview(this.prefs, {Key? key}) : super(key: key);
  SharedPreferences prefs;

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  String provider = "";
  TextEditingController _webController = TextEditingController();
  InAppWebViewController? webViewController;

  @override
  void initState() {
    loadPrefs();
    super.initState();
  }

  void loadPrefs(){
    String? customProvider = widget.prefs.getString('provider');
    if (customProvider != null){
      setState(() {
        String newprovider = customProvider.split('/')[0];
        provider = "$newprovider";
      });}
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 440,
            child: InAppWebView(
              onWebViewCreated: (controller) {
                  webViewController = controller;
              },
              initialUrlRequest: URLRequest(url: WebUri('https://$provider')),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: TextField(
              controller: _webController,
              decoration: const InputDecoration(labelText: "Address"),
              onSubmitted: (value){
                var webURL = WebUri("https://$value");
                if (webURL.hasEmptyPath) {
                  
                  webURL = WebUri("https://$provider$value");
                }
                  webViewController?.loadUrl(urlRequest: URLRequest(url: webURL));
              
                
              },
            )  
          ) 
        ],
      )
    );
  }
}