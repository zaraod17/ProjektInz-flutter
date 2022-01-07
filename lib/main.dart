import 'package:flutter/material.dart';
import 'package:projekt/screens/auth_screen.dart';
import 'package:provider/provider.dart';

import './screens/add_report_screen.dart';
import './providers/auth.dart';
import './screens/report_detail_screen.dart';
import './providers/reports.dart';
import './screens/tabs_screen.dart';
import './screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Reports>(
          update: (context, auth, previousReports) => Reports(
              auth.token,
              auth.userId,
              previousReports == null ? [] : previousReports.items),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
            title: 'Report problem',
            theme: ThemeData(
              primarySwatch: Colors.purple,
            ),
            home: auth.isAuth
                ? TabsScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              AuthScreen.routeName: (ctx) => AuthScreen(),
              TabsScreen.routeName: (ctx) => TabsScreen(),
              ReportDetailScreen.routeName: (ctx) => ReportDetailScreen(),
              AddReportScreen.routeName: (ctx) => AddReportScreen(),
            }),
      ),
    );
  }
}
