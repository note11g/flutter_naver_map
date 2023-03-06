import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NaverMapSdk.instance.initialize(
      clientId: 'client id를 여기에 입력해주세요.',
      onAuthFailed: (ex) {
        log("Client ID를 세팅해주세요.", name: "NaverMap", error: ex);
      });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: FNMapPage());
  }
}

class FNMapPage extends StatefulWidget {
  const FNMapPage({Key? key}) : super(key: key);

  @override
  State<FNMapPage> createState() => _FNMapPageState();
}

class _FNMapPageState extends State<FNMapPage> {
  @override
  Widget build(BuildContext context) {
    return NaverMap(

    );
  }
}
