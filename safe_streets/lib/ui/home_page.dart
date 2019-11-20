import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/enum/level.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/firebase_auth_service.dart';
import 'package:safe_streets/ui/create_report_page.dart';
import 'package:safe_streets/ui/sign_in_page.dart';

import 'my_reports_page.dart';

class HomePage extends StatelessWidget {
  static GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    User u = Provider.of<User>(context, listen: true);
    Set<Marker> markers = Set<Marker>.of(u.toMarker(context).values);
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Text(u.email),
                accountName:
                    Text(u.level == Level.standard ? "Citizen" : "Authority"),
              ),
              ListTile(
                title: Text("Logout"),
                onTap: () async {
                  Navigator.pop(context);
                  final auth =
                      Provider.of<FirebaseAuthService>(context, listen: false);
                  await auth.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                leading: Icon(Icons.exit_to_app),
              ),
              ListTile(
                title: Text("Add Report"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<User>.value(
                                value: u,
                                child: CreateReportPage(),
                              )));
                },
                leading: Icon(Icons.add_circle),
              ),
              ListTile(
                title: Text("My Reports"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyReportsPage()));
                },
                leading: Icon(Icons.assistant_photo),
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("SafeStreet"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text("Reports downloaded: " + markers.length.toString()),
              Expanded(
                child: u.location == null ? Container() : GoogleMap(
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(u.location.lat, u.location.long),
                      zoom: 15.0),
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  markers: markers,
                ),
              ),
            ],
          ),
        ));
  }
}
