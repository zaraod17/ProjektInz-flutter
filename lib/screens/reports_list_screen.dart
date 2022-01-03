import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:projekt/providers/reports.dart';
import 'package:projekt/widgets/report_item.dart';

class ReportsOverviewScreen extends StatelessWidget {
  static const routeName = '/reports-overview';

  Future<void> _refreshReports(context) async {
    await Provider.of<Reports>(context, listen: false).fetchAndSetAllReports();
  }

  @override
  Widget build(BuildContext context) {
    //  final reportsData = Provider.of<Reports>(context);
    // final reports = reportsData.items;
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
                          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                              value: reportsData.items[i], child: ReportItem()),
                          itemCount: reportsData.items.length,
                        ),
                      ),
                    ),
                    onRefresh: () => _refreshReports(context)));
  }
}
