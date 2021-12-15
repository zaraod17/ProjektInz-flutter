import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:projekt/providers/reports.dart';
import 'package:projekt/widgets/report_item.dart';

class ReportsOverviewScreen extends StatelessWidget {
  static const routeName = '/reports-overview';

  @override
  Widget build(BuildContext context) {
    final reportsData = Provider.of<Reports>(context);
    final reports = reportsData.items;
    return Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: reports[i], child: ReportItem()),
          itemCount: reports.length,
        ));
  }
}
