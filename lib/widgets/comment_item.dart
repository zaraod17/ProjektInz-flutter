import 'package:flutter/material.dart';
import 'package:projekt/providers/reports.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatelessWidget {
  // const CommentItem({ Key? key }) : super(key: key);
  final String content;
  final String userId;

  CommentItem(this.content, this.userId);

  @override
  Widget build(BuildContext context) {
    final loggedUserId = Provider.of<Reports>(context, listen: false).userId;
    return Container(
      width: double.infinity,
      height: 40,
      child: Row(
        mainAxisAlignment: userId == loggedUserId
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: loggedUserId == userId ? Colors.lightBlue : Colors.grey),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(content)),
          )
        ],
      ),
    );
  }
}
