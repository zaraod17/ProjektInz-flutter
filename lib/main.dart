import 'package:flutter/material.dart';
import 'package:projekt/screens/add_report_screen.dart';
import 'package:provider/provider.dart';

import './screens/report_detail_screen.dart';
import './providers/reports.dart';
import './screens/tabs_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => Reports())],
      child: MaterialApp(
          title: 'Report problem',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          initialRoute: '/',
          routes: {
            TabsScreen.routeName: (ctx) => TabsScreen(),
            ReportDetailScreen.routeName: (ctx) => ReportDetailScreen(),
            AddReportScreen.routeName: (ctx) => AddReportScreen(),
          }),
    );
  }
}
