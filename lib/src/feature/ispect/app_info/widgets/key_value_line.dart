import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class KeyValueLine extends StatelessWidget {
  const KeyValueLine({
    required this.k,
    required this.v,
    super.key,
  });

  final String k;
  final String v;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    k,
                    style: context.theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Divider(
                color: context.colors.border,
              ),
            ),
            Flexible(
              flex: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    v,
                    textAlign: TextAlign.end,
                    style: context.theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
