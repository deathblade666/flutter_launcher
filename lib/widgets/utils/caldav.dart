
import 'dart:convert';
import 'dart:io';

//import 'package:caldav_client/caldav_client.dart';
import 'package:flutter_launcher/widgets/tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;

class Caldav{
  String? server = "";
  String? username ="";
  String? password = "";
  var calendars = <String>[];
  SharedPreferences prefs;
  

  Caldav(this.server,this.username,this.password, this.prefs);

  Future<void> initializeClient (String server, String username, String password) async {
    calendars.clear(); }
    /*var client = CalDavClient(
      baseUrl: server,
      headers: Authorization(username, password).basic(),
    );
    var initialSyncResult = await client.initialSync("remote.php/dav/calendars/$username/");
    for (var result in initialSyncResult.multistatus!.response) {
      if (result.propstat.status == 200) {
        var displayname = result.propstat.prop['displayname'];
        var ctag = result.propstat.prop['getctag'];
        if (displayname == "Calendar" && ctag != null) {
          print('CALENDAR: $displayname');
          print('CTAG: $ctag');
          print("Result.href: ${result.href}");
          calendars.add(result.href);
        }
      }
    }
  if (calendars.isNotEmpty){
    print("Calendar: ${calendars.first}");
    var responseObjects = await client.getObjects(calendars.first);
    print("Objects: $responseObjects");
  }
  }
    Uri url = Uri.parse(server);
    final response = await http.get(url, headers: {
      'Authorization': getBasicAuthHeader(username, password),
      'Content-Type': 'application/xml',
    });

    if (response.statusCode == 200) {
      // Successfully received data
      print('Response data: ${response.body}');
    } else {
      // Handle error
      print('Request failed with status: ${response.statusCode}');
    }
  }

String getBasicAuthHeader(String username, String password) {
  String credentials = '$username:$password';
  String encodedCredentials = base64Encode(utf8.encode(credentials));
  return 'Basic $encodedCredentials';
}

  Future<List<Task>> fetchTasks() async {
  final tasks = await client.getTasks();
  return tasks;
}


Future<void> updateTask(Task task) async {
  await client.updateTask(task.id, task);
}


Future<void> sync() async {
  await client.sync();
}

*/
}