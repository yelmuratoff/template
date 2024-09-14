import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';

import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    required this.body,
    this.title = '',
    super.key,
    this.bottom,
    this.height,
    this.isWithoutTitle = false,
    this.backgroundColor = Colors.transparent,
  });
  final Widget body;
  final Widget? bottom;
  final String title;
  final double? height;
  final bool isWithoutTitle;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return RepaintBoundary(
      child: Material(
        color: context.theme.scaffoldBackgroundColor,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Container(
          width: double.infinity,
          height: height ?? screenSize.height * 0.55,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 16,
                  top: 18,
                  end: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Visibility(
                        replacement: body,
                        visible: !isWithoutTitle,
                        child: AutoSizeText(
                          title,
                          maxLines: 2,
                          minFontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          style: context.textStyles.s18w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: IconButton(
                        iconSize: 20,
                        icon: const Icon(
                          IconsaxPlusLinear.close_circle,
                          size: 32,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: !isWithoutTitle,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 16,
                      top: 16,
                      end: 16,
                    ),
                    child: Column(
                      children: [
                        body,
                        bottom ?? const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
