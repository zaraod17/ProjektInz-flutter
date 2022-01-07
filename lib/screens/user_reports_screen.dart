import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reports.dart';
import '../widgets/report_item.dart';

class UserReportsScreen extends StatelessWidget {
  static const routeName = '/user-reports-screen';

  Future<void> refreshReports(BuildContext context) async {
    await Provider.of<Reports>(context, listen: false)
        .fetchAndSetAllReports(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.purple[600],
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(15)),
        child: Text(
          'Zgłoszenia użytkownika',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      Expanded(
        child: FutureBuilder(
          future: refreshReports(context),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  child: Consumer<Reports>(
                    builder: (context, reportsData, child) => ListView.builder(
                      itemBuilder: (ctx, i) => Column(children: [
                        ChangeNotifierProvider.value(
                            value: reportsData.items[i], child: ReportItem()),
                        Divider()
                      ]),
                      itemCount: reportsData.items.length,
                    ),
                  ),
                  onRefresh: () => refreshReports(context)),
        ),
      )
    ]);
  }
}
