import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

abstract class ExampleBasePage extends StatefulWidget {
  final NaverMapController mapController;
  final bool canScroll;

  const ExampleBasePage({
    super.key,
    required this.mapController,
    required this.canScroll,
  });
}

