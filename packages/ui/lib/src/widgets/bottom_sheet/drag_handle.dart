import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// `DragHandle` - This widget is used to
/// display the header of the bottom sheet.

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: 32,
    height: 4,
    decoration: BoxDecoration(
      color: Theme.of(context).extension<IColors>()!.divider,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
  );
}
