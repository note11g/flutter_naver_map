import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class TextFieldPage extends StatefulWidget {
  @override
  _TextFieldPageState createState() => _TextFieldPageState();
}

class _TextFieldPageState extends State<TextFieldPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          _mapView(),
          _textFieldView(),
        ],
      ),
    );
  }

  _mapView() => NaverMap(
        useSurface: kReleaseMode,
        initLocationTrackingMode: LocationTrackingMode.Follow,
      );

  _textFieldView() => Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          bottom: false,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            margin: EdgeInsets.all(24),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              decoration: InputDecoration.collapsed(hintText: ''),
              maxLines: 1,
            ),
          ),
        ),
      );
}
