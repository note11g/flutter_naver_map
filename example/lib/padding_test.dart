import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class PaddingTest extends StatefulWidget {
  @override
  _PaddingTestState createState() => _PaddingTestState();
}

class _PaddingTestState extends State<PaddingTest> {
  Completer<NaverMapController> _controller = Completer();

  double _padding = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          NaverMap(
            onMapCreated: _onMapCreated,
            initLocationTrackingMode: LocationTrackingMode.Follow,
            locationButtonEnable: true,
            contentPadding: EdgeInsets.only(left: 150),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              padding: EdgeInsets.only(bottom: _padding),
              width: MediaQuery.of(context).size.width,
              duration: Duration(milliseconds: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // 위로 화살표
                  GestureDetector(
                    onTap: _onTapUp,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                                spreadRadius: 1,
                              )
                            ]),
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 16, right: 16),
                        child: Icon(
                          Icons.file_upload,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ),
                  ),

                  // 경계선
                  Container(
                    height: 2,
                    color: Colors.red.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  void _onTapUp() async {
    if (!_controller.isCompleted) return;

    if (_padding < 300) {
      _padding += 20;
      final cont = await _controller.future;
      cont.setContentPadding(bottom: _padding);

      setState(() {});
    }
  }
}
