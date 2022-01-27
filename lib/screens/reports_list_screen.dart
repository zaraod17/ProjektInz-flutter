import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reports.dart';
import '../widgets/report_item.dart';

class ReportsOverviewScreen extends StatelessWidget {
  static const routeName = '/reports-overview';

  Future<void> _refreshReports(context) async {
    await Provider.of<Reports>(context, listen: false).fetchAndSetAllReports();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _refreshReports(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    child: Consumer<Reports>(
                      builder: (context, reportsData, child) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (ctx, i) => Column(children: [
                            ChangeNotifierProvider.value(
                                value: reportsData.items[i],
                                child: ReportItem()),
                            Divider()
                          ]),
                          itemCount: reportsData.items.length,
                        ),
                      ),
                    ),
                    onRefresh: () => _refreshReports(context)));
  }
}
