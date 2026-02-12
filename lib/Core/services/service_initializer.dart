import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flx_market/firebase_options.dart';

class ServiceInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
