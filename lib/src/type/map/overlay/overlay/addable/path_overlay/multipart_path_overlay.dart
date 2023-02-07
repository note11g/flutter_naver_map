part of flutter_naver_map;

class NMultiPartPathOverlay extends NAddableOverlay<NMultiPartPathOverlay> {
  List<NMultipartPath> get paths => _paths;
  List<NMultipartPath> _paths;

  double get width => _width;
  double _width;

  double get outlineWidth => _outlineWidth;
  double _outlineWidth;

  NOverlayImage? _patternImage;

  double get patternInterval => _patternInterval;
  double _patternInterval;

  double get progress => _progress;
  double _progress;

  bool get isHideCollidedCaptions => _isHideCollidedCaptions;
  bool _isHideCollidedCaptions;

  bool get isHideCollidedMarkers => _isHideCollidedMarkers;
  bool _isHideCollidedMarkers;

  bool get isHideCollidedSymbols => _isHideCollidedSymbols;
  bool _isHideCollidedSymbols;

  NMultiPartPathOverlay({
    required String id,
    required List<NMultipartPath> paths,
    double width = 4,
    double outlineWidth = 1,
    NOverlayImage? patternImage,
    double patternInterval = 20,
    double progress = 0, // -1 ~ 1
    bool isHideCollidedCaptions = false,
    bool isHideCollidedMarkers = false,
    bool isHideCollidedSymbols = false,
  })  : _paths = paths,
        _width = width,
        _outlineWidth = outlineWidth,
        _patternImage = patternImage,
        _patternInterval = patternInterval,
        _progress = progress,
        _isHideCollidedCaptions = isHideCollidedCaptions,
        _isHideCollidedMarkers = isHideCollidedMarkers,
        _isHideCollidedSymbols = isHideCollidedSymbols,
        super(id: id, type: NOverlayType.multipartPathOverlay);

  void setPaths(List<NMultipartPath> paths) {
    _paths = paths;
    _set(_pathsName, paths);
  }

  void setWidth(double width) {
    _width = width;
    _set(_widthName, width);
  }

  void setOutlineWidth(double outlineWidth) {
    _outlineWidth = outlineWidth;
    _set(_outlineWidthName, outlineWidth);
  }

  void setPatternImage(NOverlayImage? patternImage) {
    _patternImage = patternImage;
    _set(_patternImageName, patternImage);
  }

  void setPatternInterval(double patternInterval) {
    _patternInterval = patternInterval;
    _set(_patternIntervalName, patternInterval);
  }

  void setProgress(double progress) {
    _progress = progress;
    _set(_progressName, progress);
  }

  void setIsHideCollidedCaptions(bool isHideCollidedCaptions) {
    _isHideCollidedCaptions = isHideCollidedCaptions;
    _set(_isHideCollidedCaptionsName, isHideCollidedCaptions);
  }

  void setIsHideCollidedMarkers(bool isHideCollidedMarkers) {
    _isHideCollidedMarkers = isHideCollidedMarkers;
    _set(_isHideCollidedMarkersName, isHideCollidedMarkers);
  }

  void setIsHideCollidedSymbols(bool isHideCollidedSymbols) {
    _isHideCollidedSymbols = isHideCollidedSymbols;
    _set(_isHideCollidedSymbolsName, isHideCollidedSymbols);
  }

  Future<NLatLngBounds> getBounds() {
    return _getAsyncWithCast(_boundsName, NLatLngBounds._fromMessageable);
  }

  factory NMultiPartPathOverlay._fromMessageable(dynamic m) =>
      NMultiPartPathOverlay(
        id: NOverlayInfo._fromMessageable(m[_infoName]!).id,
        paths: NMultipartPath._fromMessageableList(m[_pathsName]!),
        width: m[_widthName]!,
        outlineWidth: m[_outlineWidthName]!,
        patternImage: m[_patternImageName] != null
            ? NOverlayImage._fromMessageable(m[_patternImageName])
            : null,
        patternInterval: m[_patternIntervalName]!,
        progress: m[_progressName]!,
        isHideCollidedCaptions: m[_isHideCollidedCaptionsName]!,
        isHideCollidedMarkers: m[_isHideCollidedMarkersName]!,
        isHideCollidedSymbols: m[_isHideCollidedSymbolsName]!,
      );

  @override
  NPayload toNPayload() => NPayload.make({
        _infoName: info,
        _pathsName: _paths,
        _widthName: _width,
        _outlineWidthName: _outlineWidth,
        _patternImageName: _patternImage,
        _patternIntervalName: _patternInterval,
        _progressName: _progress,
        _isHideCollidedCaptionsName: _isHideCollidedCaptions,
        _isHideCollidedMarkersName: _isHideCollidedMarkers,
        _isHideCollidedSymbolsName: _isHideCollidedSymbols,
      });

  /*
    --- Messaging Name Define ---
  */
  static const _infoName = "info";
  static const _pathsName = "paths";
  static const _widthName = "width";
  static const _outlineWidthName = "outlineWidth";
  static const _patternImageName = "patternImage";
  static const _patternIntervalName = "patternInterval";
  static const _progressName = "progress";
  static const _isHideCollidedCaptionsName = "isHideCollidedCaptions";
  static const _isHideCollidedMarkersName = "isHideCollidedMarkers";
  static const _isHideCollidedSymbolsName = "isHideCollidedSymbols";
  static const _boundsName = "bounds";
}
