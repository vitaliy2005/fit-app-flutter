import 'package:contacts_app/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:contacts_app/app/contacts_app.dart';


Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const ContactApp());
}
