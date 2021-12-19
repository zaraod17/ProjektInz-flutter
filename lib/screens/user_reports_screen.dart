import 'package:flutter/material.dart';
import 'package:projekt/screens/add_report_screen.dart';

class UserReportsScreen extends StatelessWidget {
  static const routeName = '/user-reports-screen';
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(
        child: Column(
          children: [
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
          ],
        ),
      ),
      // ElevatedButton(
      //   onPressed: () {
      //     Navigator.of(context).pushNamed(AddReportScreen.routeName);
      //   },
      //   child: Text('Dodaj zgłoszenie'),
      //   style: ButtonStyle(
      //       backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
      //       tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      // )
    ]);
  }
}
