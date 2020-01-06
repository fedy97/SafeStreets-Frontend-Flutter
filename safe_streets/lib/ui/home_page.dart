import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/enum/level.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/access_manager.dart';
import 'package:safe_streets/services/report_map_manager.dart';
import 'package:safe_streets/services/utilities.dart';
import 'package:safe_streets/ui/create_report_page.dart';
import 'package:safe_streets/ui/sign_in_page.dart';
import 'package:safe_streets/ui/statistics_page.dart';
import 'package:safe_streets/ui/violation_query_page.dart';

import 'my_reports_page.dart';

class HomePage extends StatelessWidget {
  static GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    User u = Provider.of<User>(context, listen: true);
    Set<Marker> markers =
        Set<Marker>.of(ReportMapManager.toMarker(u, context).values);
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_a_photo),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider<User>.value(
                          value: u,
                          child: CreateReportPage(),
                        )));
          },
        ),
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
                title: Text("My Reports"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<User>.value(
                                value: u,
                                child: MyReportsPage(),
                              )));
                },
                leading: Icon(Icons.assistant_photo),
              ),
              ListTile(
                title: Text("Statistics"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<User>.value(
                                value: u,
                                child: Statistics(),
                              )));
                },
                leading: Icon(Icons.view_list),
              ),
              ListTile(
                title: Text("Query Report"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<User>.value(
                                value: u,
                                child: ViolationQuery(),
                              )));
                },
                leading: Icon(Icons.search),
              ),
              ListTile(
                title: Text("Logout"),
                onTap: () async {
                  Navigator.pop(context);
                  final auth =
                      Provider.of<AccessManager>(context, listen: false);
                  await auth.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                leading: Icon(Icons.exit_to_app),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                Utilities.showProgress(context);
                await u.getAllReports();
                Navigator.pop(context);
              },
            )
          ],
          title: Text("SafeStreets"),
        ),
        body: u.location == null
            ? Container()
            : Stack(
                children: <Widget>[
                  GoogleMap(
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(u.location.lat, u.location.long),
                        zoom: 15.0),
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    markers: markers,
                  ),
                ],
              ));
  }
}
