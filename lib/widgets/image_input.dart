import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  // final Function onSelectImage;

  // ImageInput(this.onSelectImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: Text(
            'No image taken',
            textAlign: TextAlign.center,
          ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: ElevatedButton.icon(
          icon: Icon(Icons.camera),
          label: Text('Take Picture'),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo)),
          onPressed: () {},
        ))
      ],
    );
  }
}
