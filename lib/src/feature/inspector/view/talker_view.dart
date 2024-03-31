// ignore_for_file: implementation_imports

import 'package:base_starter/src/common/ui/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/feature/inspector/actions/actions_bottom_sheet.dart';
import 'package:base_starter/src/feature/inspector/monitor/talker_monitor_page.dart';
import 'package:base_starter/src/feature/inspector/utils/get_data_color.dart';
import 'package:base_starter/src/feature/inspector/widget/data_card.dart';
import 'package:base_starter/src/feature/inspector/widget/settings_bottom_sheet.dart';
import 'package:base_starter/src/feature/inspector/widget/view_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_button/group_button.dart';
import 'package:talker_flutter/src/controller/controller.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TalkerView extends StatefulWidget {
  const TalkerView({
    required this.talker,
    super.key,
    this.controller,
    this.scrollController,
    this.theme = const TalkerScreenTheme(),
    this.appBarTitle,
    this.itemsBuilder,
    this.appBarLeading,
  });

  /// Talker implementation
  final Talker talker;

  /// Theme for customize [TalkerScreen]
  final TalkerScreenTheme theme;

  /// Screen [AppBar] title
  final String? appBarTitle;

  /// Screen [AppBar] leading
  final Widget? appBarLeading;

  /// Optional Builder to customize
  /// log items cards in list
  final TalkerDataBuilder? itemsBuilder;

  final TalkerViewController? controller;

  final ScrollController? scrollController;

  @override
  State<TalkerView> createState() => _TalkerViewState();
}

class _TalkerViewState extends State<TalkerView> {
  final _titlesController = GroupButtonController();
  final _focusNode = FocusNode();
  late final _controller = widget.controller ?? TalkerViewController();

  @override
  Widget build(BuildContext context) {
    final talkerTheme = widget.theme;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => TalkerBuilder(
          talker: widget.talker,
          builder: (context, data) {
            final filtredElements =
                data.where((e) => _controller.filter.filter(e)).toList();
            final titles = data.map((e) => e.title).toList();
            final uniqTitles = titles.toSet().toList();

            return CustomScrollView(
              controller: widget.scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                TalkerAppBar(
                  focusNode: _focusNode,
                  title: widget.appBarTitle,
                  leading: widget.appBarLeading,
                  talker: widget.talker,
                  talkerTheme: talkerTheme,
                  titlesController: _titlesController,
                  titles: titles,
                  uniqTitles: uniqTitles,
                  controller: _controller,
                  onMonitorTap: () => _openTalkerMonitor(context),
                  onActionsTap: () => _showActionsBottomSheet(context),
                  onSettingsTap: () =>
                      _openTalkerSettings(context, talkerTheme),
                  onToggleTitle: _onToggleTitle,
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final data = _getListItem(filtredElements, i);
                      if (widget.itemsBuilder != null) {
                        return widget.itemsBuilder!.call(context, data);
                      }
                      return TalkerDataCards(
                        data: data,
                        backgroundColor: widget.theme.cardColor,
                        onCopyTap: () => _copyTalkerDataItemText(data),
                        expanded: _controller.expandedLogs,
                        color: getTypeColor(context: context, key: data.title),
                      );
                    },
                    childCount: filtredElements.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onToggleTitle(String title, bool selected) {
    if (selected) {
      _controller.addFilterTitle(title);
    } else {
      _controller.removeFilterTitle(title);
    }
  }

  TalkerData _getListItem(
    List<TalkerData> filtredElements,
    int i,
  ) {
    final data = filtredElements[
        _controller.isLogOrderReversed ? filtredElements.length - 1 - i : i];
    return data;
  }

  void _openTalkerSettings(BuildContext context, TalkerScreenTheme theme) {
    final talker = ValueNotifier(widget.talker);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => TalkerSettingsBottomSheets(
        talkerScreenTheme: theme,
        talker: talker,
      ),
    );
  }

  void _openTalkerMonitor(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<Widget>(
        builder: (context) => TalkerMonitorPage(
          theme: widget.theme,
          talker: widget.talker,
        ),
      ),
    );
  }

  void _copyTalkerDataItemText(TalkerData data) {
    final text = data.generateTextMessage();
    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar(context, context.l10n.log_item_copied);
  }

  void _showSnackBar(BuildContext context, String text) {
    Toaster.showToast(context, title: text);
  }

  Future<void> _showActionsBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TalkerActionsBottomSheet(
        actions: [
          TalkerActionItem(
            onTap: _controller.toggleLogOrder,
            title: context.l10n.reverse_logs,
            icon: Icons.swap_vert,
          ),
          TalkerActionItem(
            onTap: () => _copyAllLogs(context),
            title: context.l10n.copy_all_logs,
            icon: Icons.copy,
          ),
          TalkerActionItem(
            onTap: _toggleLogsExpanded,
            title: _controller.expandedLogs
                ? context.l10n.collapse_logs
                : context.l10n.expand_logs,
            icon: _controller.expandedLogs
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          TalkerActionItem(
            onTap: _cleanHistory,
            title: context.l10n.clean_history,
            icon: Icons.delete_outline,
          ),
          TalkerActionItem(
            onTap: _shareLogsInFile,
            title: context.l10n.share_logs_file,
            icon: Icons.ios_share_outlined,
          ),
        ],
        talkerScreenTheme: widget.theme,
      ),
    );
  }

  Future<void> _shareLogsInFile() async {
    await _controller.downloadLogsFile(
      widget.talker.history.text,
    );
  }

  void _cleanHistory() {
    widget.talker.cleanHistory();
    _controller.update();
  }

  void _toggleLogsExpanded() {
    _controller.toggleExpandedLogs();
  }

  void _copyAllLogs(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.talker.history.text));
    _showSnackBar(context, context.l10n.all_logs_copied);
  }
}
