import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/model/poetries.dart';
import 'package:min_poetry_flutter/pages/login_page.dart';
import 'package:min_poetry_flutter/pages/main_page.dart';
import 'package:min_poetry_flutter/pages/register_page.dart';
import 'package:min_poetry_flutter/pages/retrieve_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Poetries(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.red,
          primaryColor: Colors.black,
        ),
        // home: MainPage(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        navigatorKey: navigatorKey,
        routes: {
          '/': (BuildContext context) => MainPage(),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/retrieve': (BuildContext context) => RetrievePage()
        },
      ),
    );
  }
}
