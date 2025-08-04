import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class OverlayAnimationTestPage extends StatefulWidget {
  const OverlayAnimationTestPage({super.key});

  @override
  State<OverlayAnimationTestPage> createState() => _OverlayAnimationTestPageState();
}

class _OverlayAnimationTestPageState extends State<OverlayAnimationTestPage> {
  // Constants
  static const NLatLng _centerPosition = NLatLng(37.5666, 126.9784);
  static const double _animationRadius = 0.001;
  static const double _jankThresholdMultiplier = 1.5;
  static const int _timestampLength = 19;
  static const double _defaultZoom = 16;
  static const double _markerAnimationRadiusMultiplier = 0.5;
  static const int _millisPerSecond = 1000;
  
  // Test configuration options
  static const List<int> _availableTestDurations = [150, 300, 500, 800, 1000, 1500, 2000];
  static const List<int> _availableMarkerCounts = [1, 5, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000];
  static const List<int> _availableFpsList = [24, 30, 60, 120];
  
  // Default values
  static const int _defaultDuration = 1000;
  static const int _defaultMarkerCount = 1;
  static const int _defaultFps = 60;
  
  // State variables
  NaverMapController? _controller;
  final List<NMarker> _animatedMarkers = [];
  Timer? _animationTimer;
  
  int _selectedDuration = _defaultDuration;
  int _selectedMarkerCount = _defaultMarkerCount;
  int _selectedFps = _defaultFps;
  bool _isAnimating = false;
  bool _useRenderQueue = false;
  
  final List<double> _frameTimings = [];
  final List<TestResult> _testResults = [];

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  // Business Logic Methods
  bool _canStartAnimation() {
    return _controller != null && _animatedMarkers.isNotEmpty && !_isAnimating;
  }

  void _prepareForAnimation() {
    setState(() {
      _isAnimating = true;
      _frameTimings.clear();
    });
  }

  AnimationConfig _createAnimationConfig() {
    return AnimationConfig(
      fps: _selectedFps,
      duration: _selectedDuration,
      startTime: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> _setupMarkers() async {
    if (_controller == null) return;
    
    await _controller!.clearOverlays();
    _animatedMarkers.clear();
    
    final markers = _createMarkersInGrid();
    for (final marker in markers) {
      _animatedMarkers.add(marker);
      await _controller!.addOverlay(marker);
    }
  }

  List<NMarker> _createMarkersInGrid() {
    final gridSize = sqrt(_selectedMarkerCount).ceil();
    final spacing = _animationRadius * 2 / gridSize;
    final markers = <NMarker>[];
    
    for (int i = 0; i < _selectedMarkerCount; i++) {
      final marker = _createMarkerAtGridPosition(i, gridSize, spacing);
      markers.add(marker);
    }
    
    return markers;
  }

  NMarker _createMarkerAtGridPosition(int index, int gridSize, double spacing) {
    final row = index ~/ gridSize;
    final col = index % gridSize;
    
    final offsetLat = (row - gridSize / 2) * spacing;
    final offsetLng = (col - gridSize / 2) * spacing;
    
    return NMarker(
      id: "animated_marker_$index",
      position: NLatLng(
        _centerPosition.latitude + offsetLat,
        _centerPosition.longitude + offsetLng,
      ),
      caption: _selectedMarkerCount == 1 
          ? const NOverlayCaption(text: "Animation Test")
          : null,
    );
  }

  void _startAnimation() async {
    if (!_canStartAnimation()) return;
    
    _prepareForAnimation();
    final config = _createAnimationConfig();
    final initialPositions = _getInitialMarkerPositions();
    
    _runAnimationLoop(config, initialPositions);
  }

  List<NLatLng> _getInitialMarkerPositions() {
    return _animatedMarkers.map((marker) => marker.position).toList();
  }

  void _runAnimationLoop(AnimationConfig config, List<NLatLng> initialPositions) {
    var lastFrameTime = config.startTime;
    final frameDuration = Duration(milliseconds: _millisPerSecond ~/ config.fps);
    
    _animationTimer = Timer.periodic(frameDuration, (timer) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final elapsed = currentTime - config.startTime;
      
      if (_shouldStopAnimation(elapsed, config.duration)) {
        timer.cancel();
        _stopAnimation();
        return;
      }

      _recordFrameTiming(currentTime, lastFrameTime);
      _updateAllMarkers(elapsed, config.duration, initialPositions);
      
      lastFrameTime = currentTime;
    });
  }

  bool _shouldStopAnimation(int elapsed, int duration) {
    return elapsed >= duration;
  }

  void _recordFrameTiming(int currentTime, int lastFrameTime) {
    final frameTime = (currentTime - lastFrameTime).toDouble();
    _frameTimings.add(frameTime);
  }

  void _updateAllMarkers(int elapsed, int duration, List<NLatLng> initialPositions) {
    final progress = elapsed / duration;
    
    if (_useRenderQueue) {
      _updateMarkersWithRenderQueue(progress, initialPositions);
    } else {
      _updateMarkersDirect(progress, initialPositions);
    }
  }

  void _updateMarkersWithRenderQueue(double progress, List<NLatLng> initialPositions) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _performMarkerUpdates(progress, initialPositions);
    });
  }

  void _updateMarkersDirect(double progress, List<NLatLng> initialPositions) {
    _performMarkerUpdates(progress, initialPositions);
  }

  void _performMarkerUpdates(double progress, List<NLatLng> initialPositions) {
    for (int i = 0; i < _animatedMarkers.length; i++) {
      final newPosition = _calculateNewMarkerPosition(i, progress, initialPositions[i]);
      _animatedMarkers[i].setPosition(newPosition);
    }
  }

  NLatLng _calculateNewMarkerPosition(int markerIndex, double progress, NLatLng initialPosition) {
    final phase = (markerIndex * 2 * pi) / _animatedMarkers.length;
    final angle = progress * 2 * pi + phase;
    const radius = _animationRadius * _markerAnimationRadiusMultiplier;
    
    return NLatLng(
      initialPosition.latitude + cos(angle) * radius,
      initialPosition.longitude + sin(angle) * radius,
    );
  }

  void _stopAnimation() {
    _animationTimer?.cancel();
    
    if (_frameTimings.isNotEmpty) {
      final result = _createTestResult();
      _addTestResult(result);
    } else {
      _setAnimationStopped();
    }
  }

  TestResult _createTestResult() {
    final stats = _calculateFrameStatistics();
    
    return TestResult(
      duration: _selectedDuration,
      markerCount: _selectedMarkerCount,
      targetFps: _selectedFps,
      avgFrameTime: stats.average,
      medianFrameTime: stats.median,
      maxFrameTime: stats.maximum,
      jankPercentage: stats.jankPercentage,
      totalFrames: _frameTimings.length,
      timestamp: _getCurrentTimestamp(),
      useRenderQueue: _useRenderQueue,
    );
  }

  FrameStatistics _calculateFrameStatistics() {
    final sortedTimings = List<double>.from(_frameTimings)..sort();
    final average = _frameTimings.reduce((a, b) => a + b) / _frameTimings.length;
    final median = sortedTimings[sortedTimings.length ~/ 2];
    final maximum = sortedTimings.last;
    
    final jankThreshold = _millisPerSecond / _selectedFps * _jankThresholdMultiplier;
    final jankFrames = _frameTimings.where((time) => time > jankThreshold).length;
    final jankPercentage = (jankFrames / _frameTimings.length) * 100;
    
    return FrameStatistics(
      average: average,
      median: median,
      maximum: maximum,
      jankPercentage: jankPercentage,
    );
  }

  String _getCurrentTimestamp() {
    return DateTime.now().toString().substring(0, _timestampLength);
  }

  void _addTestResult(TestResult result) {
    setState(() {
      _testResults.add(result);
      _isAnimating = false;
    });
  }

  void _setAnimationStopped() {
    setState(() {
      _isAnimating = false;
    });
  }

  void _clearResults() {
    setState(() {
      _testResults.clear();
    });
  }

  // UI Event Handlers
  void _onMarkerCountChanged(int? value) async {
    if (value != null && !_isAnimating) {
      setState(() {
        _selectedMarkerCount = value;
      });
      await _setupMarkers();
    }
  }

  void _onFpsChanged(int? value) {
    if (value != null && !_isAnimating) {
      setState(() {
        _selectedFps = value;
      });
    }
  }

  void _onDurationChanged(int? value) {
    if (value != null && !_isAnimating) {
      setState(() {
        _selectedDuration = value;
      });
    }
  }

  void _onRenderQueueChanged(bool? value) {
    if (!_isAnimating) {
      setState(() {
        _useRenderQueue = value ?? false;
      });
    }
  }

  void _onMapReady(NaverMapController controller) async {
    _controller = controller;
    await _setupMarkers();
  }

  // UI Build Methods
  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);
    
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(safePadding),
          _buildControlPanel(safePadding),
          if (_testResults.isNotEmpty) _buildResultsPanel(safePadding),
        ],
      ),
    );
  }

  Widget _buildMap(EdgeInsets safePadding) {
    return NaverMap(
      options: NaverMapViewOptions(
        contentPadding: safePadding,
        initialCameraPosition: const NCameraPosition(
          target: _centerPosition,
          zoom: _defaultZoom,
        ),
      ),
      onMapReady: _onMapReady,
    );
  }

  Widget _buildControlPanel(EdgeInsets safePadding) {
    return Positioned(
      top: safePadding.top + 10,
      left: 10,
      right: 10,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              const SizedBox(height: 8),
              _buildMarkerAndFpsControls(),
              const SizedBox(height: 8),
              _buildDurationControl(),
              const SizedBox(height: 8),
              _buildRenderQueueOption(),
              const SizedBox(height: 8),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Overlay Animation Performance Test",
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildMarkerAndFpsControls() {
    return Row(
      children: [
        const Text("Markers: "),
        Expanded(
          child: _buildMarkerCountDropdown(),
        ),
        const SizedBox(width: 8),
        const Text("FPS: "),
        Expanded(
          child: _buildFpsDropdown(),
        ),
      ],
    );
  }

  Widget _buildMarkerCountDropdown() {
    return DropdownButton<int>(
      value: _selectedMarkerCount,
      items: _availableMarkerCounts.map((count) {
        return DropdownMenuItem(
          value: count,
          child: Text("$count"),
        );
      }).toList(),
      onChanged: _isAnimating ? null : _onMarkerCountChanged,
    );
  }

  Widget _buildFpsDropdown() {
    return DropdownButton<int>(
      value: _selectedFps,
      items: _availableFpsList.map((fps) {
        return DropdownMenuItem(
          value: fps,
          child: Text("$fps"),
        );
      }).toList(),
      onChanged: _isAnimating ? null : _onFpsChanged,
    );
  }

  Widget _buildDurationControl() {
    return Row(
      children: [
        const Text("Duration: "),
        Expanded(
          child: _buildDurationDropdown(),
        ),
      ],
    );
  }

  Widget _buildDurationDropdown() {
    return DropdownButton<int>(
      value: _selectedDuration,
      items: _availableTestDurations.map((duration) {
        return DropdownMenuItem(
          value: duration,
          child: Text("${duration}ms"),
        );
      }).toList(),
      onChanged: _isAnimating ? null : _onDurationChanged,
    );
  }

  Widget _buildRenderQueueOption() {
    return Row(
      children: [
        Checkbox(
          value: _useRenderQueue,
          onChanged: _isAnimating ? null : _onRenderQueueChanged,
        ),
        const Text("Use Render Queue"),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isAnimating ? null : _startAnimation,
            child: Text(_isAnimating ? "Running..." : "Start Test"),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _testResults.isEmpty ? null : _clearResults,
          child: const Text("Clear"),
        ),
      ],
    );
  }

  Widget _buildResultsPanel(EdgeInsets safePadding) {
    return Positioned(
      bottom: safePadding.bottom + 10,
      left: 10,
      right: 10,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildResultsTitle(),
              const SizedBox(height: 8),
              _buildResultsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsTitle() {
    return Text(
      "Test Results",
      style: Theme.of(context).textTheme.titleSmall,
    );
  }

  Widget _buildResultsList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: _testResults.length,
        itemBuilder: _buildResultItem,
      ),
    );
  }

  Widget _buildResultItem(BuildContext context, int index) {
    final result = _testResults[_testResults.length - index - 1];
    
    return ListTile(
      dense: true,
      key: ValueKey("${result.markerCount}_${result.targetFps}_${result.duration}"),
      title: Text(_formatResultTitle(result)),
      subtitle: Text(
        _formatResultSubtitle(result),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
    );
  }

  String _formatResultTitle(TestResult result) {
    final renderMethod = result.useRenderQueue ? '(RQ)' : '(Direct)';
    return "${result.markerCount} markers @ ${result.targetFps}fps × ${result.duration}ms $renderMethod";
  }

  String _formatResultSubtitle(TestResult result) {
    return "Avg: ${result.avgFrameTime.toStringAsFixed(1)}ms, "
        "Median: ${result.medianFrameTime.toStringAsFixed(1)}ms, "
        "Max: ${result.maxFrameTime.toStringAsFixed(1)}ms\n"
        "Jank: ${result.jankPercentage.toStringAsFixed(1)}%, "
        "Frames: ${result.totalFrames}\n"
        "Time: ${result.timestamp}";
  }
}

// Data Classes
class TestResult {
  final int duration;
  final int markerCount;
  final int targetFps;
  final double avgFrameTime;
  final double medianFrameTime;
  final double maxFrameTime;
  final double jankPercentage;
  final int totalFrames;
  final String timestamp;
  final bool useRenderQueue;

  TestResult({
    required this.duration,
    required this.markerCount,
    required this.targetFps,
    required this.avgFrameTime,
    required this.medianFrameTime,
    required this.maxFrameTime,
    required this.jankPercentage,
    required this.totalFrames,
    required this.timestamp,
    required this.useRenderQueue,
  });
}

class AnimationConfig {
  final int fps;
  final int duration;
  final int startTime;

  AnimationConfig({
    required this.fps,
    required this.duration,
    required this.startTime,
  });
}

class FrameStatistics {
  final double average;
  final double median;
  final double maximum;
  final double jankPercentage;

  FrameStatistics({
    required this.average,
    required this.median,
    required this.maximum,
    required this.jankPercentage,
  });
}