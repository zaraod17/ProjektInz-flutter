import 'package:flutter/material.dart';
import 'package:projekt/providers/auth.dart';
import 'package:projekt/providers/reports.dart';
import 'package:projekt/screens/add_report_screen.dart';
import 'package:projekt/screens/auth_screen.dart';

import 'package:projekt/screens/reports_list_screen.dart';
import 'package:projekt/screens/user_reports_screen.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  List<Map<String, Object>> _pages;

  @override
  void initState() {
    _pages = [
      {'page': ReportsOverviewScreen(), 'title': Text('Wszystkie zgłoszenia')},
      {'page': UserReportsScreen(), 'title': Text('Moje zgłoszenia')}
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Reports>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            //  Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
        title: _pages[_selectedIndex]['title'],
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddReportScreen.routeName);
              },
              icon: Icon(Icons.add)),
          PopupMenuButton(onSelected: (value) {
            setState(() {
              return report.filterReports(value);
            });
          }, itemBuilder: (ctx) {
            return [
              PopupMenuItem(
                child: Text('Wszystkie'),
                value: 'all',
              ),
              PopupMenuItem(
                child: Text('Otwarte'),
                value: 'open',
              ),
              PopupMenuItem(
                child: Text('Zamknięte'),
                value: 'closed',
              ),
              PopupMenuItem(
                child: Text('W trakcie'),
                value: 'inProgress',
              )
            ];
          }),
        ],
      ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Wszystkie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'Moje',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
    );
  }
}
