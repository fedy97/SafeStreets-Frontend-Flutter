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
import 'package:safe_streets/ui/violation_query_page.dart';
import 'my_reports_page.dart';

/// this is the home page of the application, from here
/// we can navigate to the other sections of the app, like
/// statistics, query page, my reports and logout.
class HomePage extends StatelessWidget {
  static GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    User u = Provider.of<User>(context, listen: true);

    ///create all the markers to display on the map
    Set<Marker> markers =
        Set<Marker>.of(ReportMapManager.toMarker(u, context).values);
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        //this is the button that opens create_report_page
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_a_photo),
          key: Key("newReport"),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        /// here is the menu to navigate to other sections
        drawer: Drawer(
          key: Key("menuButton"),
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
                key: Key("myReports"),
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
                key: Key("stats"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<User>.value(
                                value: u,
                                child: u.viewStatisticsPage(),
                              )));
                },
                leading: Icon(Icons.view_list),
              ),
              ListTile(
                title: Text("Query Report"),
                key: Key("queryPageButton"),
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
                key: Key("logout"),
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
