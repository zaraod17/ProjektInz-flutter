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

  Future<void> _getMoreData() async {
    await Provider.of<Reports>(context, listen: false).fetchMoreReports();
  }

  Future<void> _refreshReports(context) async {
    await Provider.of<Reports>(context, listen: false).fetchAndSetAllReports();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _refreshReports(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                child: Consumer<Reports>(
                  builder: (context, reportsData, child) => Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemExtent: 80,
                      itemBuilder: (ctx, i) => reportsData.items.length == i
                          ? FutureBuilder(
                              future: _getMoreData(),
                              builder: (ctx, snapshot) => snapshot
                                          .connectionState ==
                                      ConnectionState.waiting
                                  ? Center(child: CircularProgressIndicator())
                                  : Center(
                                      child: Text('Koniec listy'),
                                    ))
                          : Column(children: [
                              ChangeNotifierProvider.value(
                                  value: reportsData.items[i],
                                  child: ReportItem()),
                              Divider()
                            ]),
                      itemCount: reportsData.items.reversed.length + 1,
                    ),
                  ),
                ),
                onRefresh: () => _refreshReports(context)));
  }
}
