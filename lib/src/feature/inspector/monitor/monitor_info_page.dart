import 'package:base_starter/src/common/ui/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/feature/inspector/utils/get_data_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TalkerMonitorLogsScreen extends StatelessWidget {
  const TalkerMonitorLogsScreen({
    required this.exceptions,
    required this.theme,
    required this.typeName,
    super.key,
  });

  final String typeName;
  final TalkerScreenTheme theme;
  final List<TalkerData> exceptions;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            typeName,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final data = exceptions[index];
                  return TalkerDataCard(
                    data: data,
                    onCopyTap: () => _copyTalkerDataItemText(context, data),
                    color: getTypeColor(context: context, key: data.title),
                    backgroundColor: context.colors.card,
                  );
                },
                childCount: exceptions.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
          ],
        ),
      );

  void _copyTalkerDataItemText(BuildContext context, TalkerData data) {
    final text = data.generateTextMessage();
    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar(context, context.l10n.log_item_copied);
  }

  void _showSnackBar(BuildContext context, String text) {
    Toaster.showToast(context, title: text);
  }
}
