import 'package:flutter/cupertino.dart';

///* `WrapBuilder` - This widget is designed to build a wrap layout
///with a specified number of child widgets,
///which are generated dynamically based on an IndexedWidgetBuilder function.
class WrapBuilder extends StatelessWidget {
  const WrapBuilder({
    required this.itemBuilder,
    required this.itemCount,
    super.key,
    this.direction,
    this.alignment,
    this.spacing,
    this.runSpacing,
    this.runAlignment,
    this.crossAxisAlignment,
    this.textDirection,
    this.verticalDirection,
    this.clipBehavior,
  });
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final Axis? direction;
  final WrapAlignment? alignment;
  final double? spacing;
  final double? runSpacing;
  final WrapAlignment? runAlignment;
  final WrapCrossAlignment? crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection? verticalDirection;
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) => Wrap(
        direction: direction ?? Axis.horizontal,
        alignment: alignment ?? WrapAlignment.start,
        spacing: spacing ?? 10,
        runSpacing: runSpacing ?? 10,
        runAlignment: runAlignment ?? WrapAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? WrapCrossAlignment.start,
        textDirection: textDirection ?? TextDirection.ltr,
        verticalDirection: verticalDirection ?? VerticalDirection.down,
        clipBehavior: clipBehavior ?? Clip.none,
        children:
            List.generate(itemCount, (index) => itemBuilder(context, index)),
      );
}
