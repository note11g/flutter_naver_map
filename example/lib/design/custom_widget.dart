import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'theme.dart';

class SelectorWithTitle extends StatelessWidget {
  final String title;
  final String description;
  final EasySelectorWidget Function(BuildContext context) selector;

  const SelectorWithTitle(this.title,
      {Key? key, required this.description, required this.selector})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selector = this.selector(context);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title, style: getTextTheme(context).titleMedium),
                const SizedBox(height: 2),
                Text(description, style: getTextTheme(context).bodySmall),
              ])),
          Expanded(flex: selector.expand ? 2 : 0, child: selector),
        ]));
  }
}

mixin EasySelectorWidget on Widget {
  bool get expand => true;
}

class EasyDropdown<T extends Enum> extends StatelessWidget
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: getColorTheme(context).outline,
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(right: 8),
      child: DropdownButton(
          dropdownColor: getColorTheme(context).background,
          underline: Container(),
          isExpanded: true,
          borderRadius: BorderRadius.circular(8),
          elevation: 4,
          selectedItemBuilder: (context) => items
              .map((e) => Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(e.name,
                      style: getTextTheme(context).bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)))
              .toList(),
          items: items
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name,
                      style: getTextTheme(context).bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)))
              .toList(),
          value: value,
          onChanged: (v) => onChanged(v as T)),
    );
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
  final String description;
  final bool value;
  final Function(bool newValue) onChanged;
  final bool enable;

  const TextSwitcher({
    Key? key,
    required this.title,
    required this.description,
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
                Text(description,
                    style: getTextTheme(context).bodySmall,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1),
              ],
            )));
  }
}

class SimpleButton extends StatelessWidget {
  final String text;
  final Color? color;
  final EdgeInsets margin;
  final void Function() action;

  const SimpleButton(
      {Key? key,
      required this.text,
      this.margin = const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      this.color,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Material(
          color: color ?? getColorTheme(context).primary,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
              onTap: action,
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Text(text,
                      style: getTextTheme(context).labelLarge,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      maxLines: 1)))),
    );
  }
}

class SimpleTitle extends StatelessWidget {
  final String title;
  final String? description;
  final EdgeInsets padding;
  final Axis direction;

  const SimpleTitle(
    this.title, {
    Key? key,
    this.description,
    this.padding = const EdgeInsets.only(left: 24, top: 12),
    this.direction = Axis.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: padding,
        child: direction == Axis.horizontal
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                    Text(title, style: getTextTheme(context).titleMedium),
                    if (description != null)
                      Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(description!,
                              style: getTextTheme(context).bodySmall)),
                  ])
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: getTextTheme(context).titleMedium),
                if (description != null)
                  Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(description!,
                          style: getTextTheme(context).bodySmall)),
              ]));
  }
}

class SliverTitle extends StatelessWidget {
  final String title;
  final String? description;
  final EdgeInsets padding;
  final Axis direction;

  const SliverTitle(
    this.title, {
    Key? key,
    this.description,
    this.padding = const EdgeInsets.only(left: 24, top: 12),
    this.direction = Axis.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
        padding: padding,
        sliver: direction == Axis.horizontal
            ? SliverRow([
                Text(title, style: getTextTheme(context).titleMedium),
                if (description != null)
                  Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(description!,
                          style: getTextTheme(context).bodySmall)),
              ],
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic)
            : SliverColumn([
                Text(title, style: getTextTheme(context).titleMedium),
                if (description != null)
                  Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(description!,
                          style: getTextTheme(context).bodySmall)),
              ], crossAxisAlignment: CrossAxisAlignment.start));
  }
}

class SliverColumn extends SliverToBoxAdapter {
  SliverColumn(
    List<Widget> children, {
    super.key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(
            child: Column(
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: crossAxisAlignment,
                children: children));
}

class SliverRow extends SliverToBoxAdapter {
  SliverRow(
    List<Widget> children, {
    super.key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextBaseline? textBaseline,
  }) : super(
            child: Row(
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: crossAxisAlignment,
                textBaseline: textBaseline,
                children: children));
}

class ReLoader extends StatelessWidget {
  final void Function() reload;
  final Duration reloadTime;
  final String text;
  final String actionText;
  final Widget child;

  ReLoader({
    Key? key,
    required this.reload,
    required this.text,
    this.actionText = "초기화",
    this.reloadTime = const Duration(milliseconds: 500),
    required this.child,
  }) : super(key: key);

  final refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: refreshController,
        onRefresh: () {
          reload();
          refreshController.refreshCompleted();
        },
        header: ClassicHeader(
          completeDuration: reloadTime,
          completeText: "$actionText가 완료되었습니다",
          releaseText: "$text $actionText",
          idleText: "$text $actionText하려면 계속해서 당겨주세요",
        ),
        child: child);
  }
}

class BottomPadding extends StatelessWidget {
  const BottomPadding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom));
  }
}

class SliverBottomPadding extends StatelessWidget {
  const SliverBottomPadding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom));
  }
}

class Balloon extends StatelessWidget {
  final Size size;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Widget child;

  const Balloon({
    Key? key,
    required this.size,
    required this.padding,
    this.backgroundColor = Colors.grey,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: SizedBox.fromSize(
          size: size,
          child: CustomPaint(
              painter: _BalloonPainter(
                  backgroundColor: backgroundColor,
                  shadowColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white24
                      : Colors.black26),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(_BalloonPainter.radius),
                      child: Container(
                        height: size.height - _BalloonPainter.tailHeight,
                        padding: padding,
                        child: MediaQuery.removePadding(
                            removeTop: true,
                            removeBottom: true,
                            context: context,
                            child: child),
                      )))),
        ));
  }
}

class _BalloonPainter extends CustomPainter {
  _BalloonPainter({required this.backgroundColor, required this.shadowColor});

  final Color backgroundColor;
  final Color shadowColor;

  static const radius = 16.0;
  static const tailRadius = 4.0;
  static const tailHeight = 12.0;
  static const tailWidth = 12.0 + tailRadius;

  @override
  void paint(Canvas canvas, Size size) {
    const corner = Radius.circular(radius);
    const tailCorner = Radius.circular(tailRadius);
    const tailPosition = 28.0; // 현재는 가운데 (1/2)
    final targetWidth = size.width;
    final targetHeight = size.height;
    const startPoint = Offset(radius, tailHeight);
    const firstTailPoint = Offset(tailPosition - (tailWidth / 2), tailHeight);
    const secondTailPoint = Offset(tailPosition, 0);
    final thirdTailPoint = Offset(secondTailPoint.dx + 2, secondTailPoint.dy);
    const fourthTailPoint = Offset(tailPosition + (tailWidth / 2), tailHeight);
    final firstRoundEndPoint =
        Offset(size.width, radius + tailHeight); // 오른쪽 위 라운드 끝 지점.
    final secondRoundEndPoint = Offset(size.width - radius, targetHeight);
    final thirdRoundEndPoint = Offset(0, targetHeight - radius);

    final path = Path()
      ..moveTo(startPoint.dx, startPoint.dy) // 첫번째 포인트로 이동 (왼쪽 위, 라운드 직후)
      ..lineTo(firstTailPoint.dx, firstTailPoint.dy) // 첫번째 꼬리 시작점까지 그리기
      ..lineTo(secondTailPoint.dx, secondTailPoint.dy) // 꼬리 윗점까지 그리기
      ..arcToPoint(thirdTailPoint, radius: tailCorner) //꼬리를 둥글게
      ..lineTo(fourthTailPoint.dx, fourthTailPoint.dy) // 꼬리 끝점까지 그리기
      ..lineTo(targetWidth - radius, tailHeight) // 오른쪽 위 꼭지점까지 그리기 (라운드 직전)
      ..arcToPoint(firstRoundEndPoint, radius: corner)
      ..lineTo(size.width, targetHeight - radius)
      ..arcToPoint(secondRoundEndPoint, radius: corner)
      ..lineTo(radius, targetHeight)
      ..arcToPoint(thirdRoundEndPoint, radius: corner)
      ..lineTo(0, radius + tailHeight)
      ..arcToPoint(startPoint, radius: corner)
      ..close();

    canvas.drawShadow(path, shadowColor, 12, false);
    canvas.drawPath(
        path,
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
