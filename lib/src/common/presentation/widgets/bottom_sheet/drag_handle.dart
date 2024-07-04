import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// `DragHandleComponent` - This widget is used to
/// display the header of the bottom sheet.

class DragHandleComponent extends StatelessWidget {
  const DragHandleComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: 32,
        height: 4,
        decoration: BoxDecoration(
          color: context.colors.divider,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
      );
}
