import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reports.dart';
import '../widgets/report_item.dart';

class ReportsOverviewScreen extends StatefulWidget {
  static const routeName = '/reports-overview';

  @override
  State<ReportsOverviewScreen> createState() => _ReportsOverviewScreenState();
}

class _ReportsOverviewScreenState extends State<ReportsOverviewScreen> {
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  // Future<void> _getMoreData() async {
  //   await Provider.of<Reports>(context, listen: false).fetchMoreReports();
  // }

  Future<void> _refreshReports(context) async {
    await Provider.of<Reports>(context, listen: false).fetchAndSetAllReports();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
          'Najnowsze zgłoszenia',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      FutureBuilder(
          future: _refreshReports(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                          child: Consumer<Reports>(
                            builder: (context, reportsData, child) => Padding(
                              padding: EdgeInsets.all(8),
                              child: ListView.builder(
                                controller: _scrollController,
                                itemExtent: 80,
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
                          onRefresh: () => _refreshReports(context)),
                    )),
    ]);
  }
}
