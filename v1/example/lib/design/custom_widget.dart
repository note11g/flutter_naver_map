import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'theme.dart';

class InnerSimpleTitle extends StatelessWidget {
  final Axis direction;
  final String title;
  final String? description;

  const InnerSimpleTitle({
    super.key,
    required this.title,
    this.description,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.vertical) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: getTextTheme(context).titleMedium,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade),
        if (description != null)
          Padding(
              padding: const EdgeInsets.only(top: 2),
              child:
                  Text(description!, style: getTextTheme(context).bodySmall)),
      ]);
    } else {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          // textBaseline: TextBaseline.alphabetic,
          children: [
            Text(title, style: getTextTheme(context).titleMedium),
            if (description != null)
              Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 2),
                  child: Text(description!,
                      style: getTextTheme(context).bodySmall)),
          ]);
    }
  }
}

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
              child: InnerSimpleTitle(
                  title: title,
                  description: description,
                  direction: Axis.vertical)),
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
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom));
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

class HalfActionButton extends StatelessWidget {
  final Function()? action;
  final IconData icon;
  final Color? color;
  final String title;
  final String description;

  const HalfActionButton({
    super.key,
    required this.action,
    required this.icon,
    this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
        color: color ?? getColorTheme(context).outline,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: action,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Row(children: [
                  Icon(icon, color: getColorTheme(context).primary, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(title,
                            style: getTextTheme(context).labelMedium,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            maxLines: 1),
                        const SizedBox(height: 2),
                        Text(description,
                            style: getTextTheme(context).bodySmall,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            maxLines: 1),
                      ])),
                ]))));
  }
}

class HalfActionButtonGrid extends StatelessWidget {
  final List<Widget> buttons;
  final double gap;

  const HalfActionButtonGrid({
    super.key,
    required this.buttons,
    this.gap = 8,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowCellAndGapWidgets = [];

    for (int i = 0; i < buttons.length; i += 2) {
      final b1 = buttons[i];
      final b2 = i + 1 < buttons.length ? buttons[i + 1] : null;

      rowCellAndGapWidgets.add(Row(children: [
        Expanded(child: b1),
        SizedBox(width: gap),
        Expanded(child: b2 ?? const SizedBox()),
      ]));

      if (i + 2 < buttons.length) {
        rowCellAndGapWidgets.add(SizedBox(height: gap));
      }
    }

    return Column(children: rowCellAndGapWidgets);
  }
}

class SmallButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final double radius;

  const SmallButton(
    this.text, {
    super.key,
    required this.onTap,
    this.color,
    this.textColor,
    this.icon,
    this.radius = 6,
  });

  BorderRadius get borderRadius => BorderRadius.circular(radius);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: color ?? getColorTheme(context).secondary,
        borderRadius: borderRadius,
        child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (icon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(icon,
                              color: textColor ?? Colors.white, size: 16),
                        ),
                      Text(text,
                          style: getTextTheme(context)
                              .labelSmall
                              ?.copyWith(color: textColor)),
                    ]))));
  }
}

class BaseDrawerHeader extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const BaseDrawerHeader({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color:
                        getColorTheme(context).onBackground.withOpacity(0.28),
                    width: 0.2))),
        padding: padding,
        child: child);
  }
}

class VersionInfoWidget extends StatelessWidget {
  const VersionInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
            color: Platform.isAndroid ? Colors.green : Colors.black,
            borderRadius: BorderRadius.circular(4)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Platform.isAndroid ? Icons.android : Icons.apple,
              color: Colors.white, size: 14),
          const SizedBox(width: 2),
          Flexible(
              child: Text(Platform.operatingSystemVersion,
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getTextTheme(context).labelSmall)),
        ]));
  }
}
