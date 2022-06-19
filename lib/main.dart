import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/services/notification_services.dart';

import 'db/db_helper.dart';
import 'services/theme_services.dart';
import 'ui/pages/home_page.dart';
import 'ui/theme.dart';

void main() async {
  /// ensure initializing flutter widget binding and get storage for theme service purpose
  await GetStorage.init();

  /// ensure initialize database service for saving, updating and deleting tasks through local database
  await DBHelper.initDB();

  /// add google font license to avoid app crash and to use Lato font
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  /// initializing notification object to get clicked ont payload if exists
  /// and pass if to open specific screen when app is closed
  var notifyHelper = NotifyHelper();
  await notifyHelper.initializeNotification();
  var det = await notifyHelper.flutterLocalNotificationsPlugin
      .getNotificationAppLaunchDetails();
  var p = det!.payload;

  /// main function running the application (The head of the app)
  runApp(MyApp(payload: p));
}

/// App root widget that hold material app widget and the start of the application
class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.payload}) : super(key: key);

  final String? payload;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      home: HomePage(payload: payload),
    );
  }
}
