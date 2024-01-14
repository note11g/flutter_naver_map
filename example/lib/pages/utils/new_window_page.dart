import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/main.dart';

class DoubleMapTestPage extends StatefulWidget {
  const DoubleMapTestPage({Key? key}) : super(key: key);

  @override
  State<DoubleMapTestPage> createState() => _DoubleMapTestPageState();
}

class _DoubleMapTestPageState extends State<DoubleMapTestPage> {
  bool map2Enabled = false;
  int count = 0;
  Timer? timer;
  final maxCount = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: NaverMap(
              onMapReady: (controller) {
                nDebugPrint("onMapReady", icon: "++", pageId: 2);
              },
              onMapLoaded: () {
                nDebugPrint("onMapLoaded", icon: "🔥", pageId: 2);
              },
            )),
            Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                    onPressed: () {
                      if (count == 0) {
                        timer = Timer.periodic(
                            const Duration(milliseconds: 1200), (timer) {
                          count++;
                          WidgetsBinding.instance.addPostFrameCallback(
                              (_) => setState(() => map2Enabled = true));
                          setState(() => map2Enabled = false);
                          if (count == maxCount) {
                            timer.cancel();
                            count = 0;
                          }
                        });
                      } else {
                        timer?.cancel();
                        count = 0;
                        map2Enabled = false;
                        setState(() {});
                      }
                    },
                    child: Text(count == 0
                        ? "start run"
                        : "stop (running, ${Duration(milliseconds: (maxCount - count) * 1200)} left)"))),
            Expanded(
              child: !map2Enabled
                  ? NaverMap(
                onMapReady: (controller) {
                  nDebugPrint("onMapReady", icon: "++", pageId: 3);
                },
                onMapLoaded: () {
                  nDebugPrint("onMapLoaded", icon: "🔥", pageId: 3);
                },
              )
                  : Container(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

class NewWindowTestPage extends StatelessWidget {
  const NewWindowTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DoubleMapTestPage()));
              },
              child: const Text('openMap'))),
    );
  }
}
