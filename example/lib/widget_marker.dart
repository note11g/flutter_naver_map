import 'package:flutter/material.dart';

class WidgetMarker extends StatefulWidget {
  const WidgetMarker({Key? key}) : super(key: key);

  @override
  State<WidgetMarker> createState() => _WidgetMarkerState();
}

class _WidgetMarkerState extends State<WidgetMarker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('테스트'),
    );
  }
}
