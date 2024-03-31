import 'package:flutter/material.dart';

///* `ColumnBuilder` - This widget is designed to build a column layout with a specified number of child widgets,
/// which are generated dynamically based on an IndexedWidgetBuilder function.

class ColumnBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final VerticalDirection verticalDirection;
  final int itemCount;

  const ColumnBuilder({
    required this.itemBuilder,
    required this.itemCount,
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        verticalDirection: verticalDirection,
        children:
            List.generate(itemCount, (index) => itemBuilder(context, index)),
      );
}
