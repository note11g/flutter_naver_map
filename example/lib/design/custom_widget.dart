import 'package:flutter/material.dart';
import 'package:flutter_naver_map_example/design/theme.dart';

mixin EasySelectorWidget on Widget {
  bool get expand => true;
}

class EasyDropdown<T extends Enum> extends StatefulWidget
    with EasySelectorWidget {
  final List<T> items;
  final T value;
  final void Function(T newValue) onChanged;

  const EasyDropdown({
    Key? key,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<EasyDropdown<T>> createState() => _EasyDropdownState<T>();
}

class _EasyDropdownState<T extends Enum> extends State<EasyDropdown<T>> {
  final linker = LayerLink();
  OverlayEntry? nowOverlay;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: linker,
      child: Material(
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).colorScheme.outline,
          child: InkWell(
              onTap: openDropdown,
              child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                  child: Row(children: [
                    Expanded(
                      child: Text(widget.value.name,
                          style: getTextTheme(context).bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 24),
                  ])))),
    );
  }

  void openDropdown() {
    nowOverlay = dropdownOverlay();
    Overlay.of(context).insert(nowOverlay!);
  }

  void closeDropdown() {
    nowOverlay?.remove();
    nowOverlay = null;
  }

  OverlayEntry dropdownOverlay() => OverlayEntry(builder: (context) {
        return Positioned(
            width: linker.leaderSize?.width,
            child: CompositedTransformFollower(
                link: linker,
                child: Material(
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.antiAlias,
                    color: Theme.of(context).colorScheme.outline,
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: widget.items
                            .map((e) => InkWell(
                                onTap: () => selectItem(e),
                                child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    child: Text('$e',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1))))
                            .toList()))));
      });

  void selectItem(T value) {
    changeValue(value);
    closeDropdown();
  }

  void changeValue(T value) {
    widget.onChanged(value);
    setState(() {});
  }

  @override
  void dispose() {
    closeDropdown();
    super.dispose();
  }
}

class EasySlider extends StatelessWidget with EasySelectorWidget {
  final double min;
  final double max;
  final double value;
  final double? defaultValue;
  final int? divisions;
  final int floatingPoint;

  final double width;
  final void Function(double newValue) onChanged;

  bool get showAsInt => floatingPoint == 0;

  const EasySlider({
    Key? key,
    this.min = 0,
    this.max = 80,
    this.divisions = 10,
    required this.value,
    this.defaultValue,
    this.floatingPoint = 0,
    this.width = 160,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTapDown:
              defaultValue != null ? (_) => onChanged(defaultValue!) : null,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 8,
                    thumbColor: Theme.of(context).colorScheme.primary,
                    activeTrackColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    inactiveTrackColor: Theme.of(context).colorScheme.outline,
                    activeTickMarkColor: Colors.white,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 10),
                    overlayShape: SliderComponentShape.noThumb,
                    showValueIndicator: ShowValueIndicator.always),
                  child: Slider(
                      min: min,
                      max: max,
                      value: value,
                      divisions: divisions,
                      // 8배수 단위로 맞추고 싶음.
                      label:
                          "${showAsInt ? value.round() : value.toStringAsFixed(floatingPoint)}",
                      onChanged: onChanged)),
            ),
            Stack(
              children: [
                Center(
                  child: Text(
                      showAsInt
                          ? "${value.toInt()}"
                          : value.toStringAsFixed(floatingPoint),
                      style: getTextTheme(context).bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: getColorTheme(context).primary)),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                          showAsInt ? "${min.toInt()}" : min.toStringAsFixed(1),
                          style: getTextTheme(context).bodySmall),
                      Text(
                          showAsInt ? "${max.toInt()}" : max.toStringAsFixed(1),
                          style: getTextTheme(context).bodySmall),
                    ]),
              ],
            ),
          ]),
        ));
  }

  @override
  bool get expand => false;
}

class TextSwitcher extends StatelessWidget {
  final String title;
  final String methodName;
  final bool value;
  final Function(bool newValue) onChanged;
  final bool enable;

  const TextSwitcher({
    Key? key,
    required this.title,
    required this.methodName,
    required this.value,
    required this.onChanged,
    this.enable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: value
            ? getColorTheme(context).primaryContainer
            : getColorTheme(context).outline,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: enable ? () => onChanged(!value) : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,
                    style: enable
                        ? getTextTheme(context).titleMedium
                        : getTextTheme(context)
                            .titleMedium
                            ?.copyWith(color: getColorTheme(context).secondary),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1),
                const SizedBox(height: 2),
                Text(".$methodName",
                    style: getTextTheme(context).bodySmall,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1),
              ],
            )));
  }
}
