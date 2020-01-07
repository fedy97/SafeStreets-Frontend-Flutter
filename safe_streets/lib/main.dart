import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/services/access_manager.dart';
import 'package:safe_streets/services/firebase_storage_service.dart';

import 'auth_manager.dart';

void main() => runApp(SafeStreets());

class SafeStreets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AccessManager>(
          create: (_) => AccessManager(),
        ),
        Provider<FirebaseStorageService>(
          create: (_) => FirebaseStorageService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthManager(),
      ),
    );
  }
}
