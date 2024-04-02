import 'dart:io';

import 'package:base_starter/src/common/services/file/src/file_service.dart';
import 'package:base_starter/src/common/ui/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

part 'view/view.dart';
part 'controller/controller.dart';

class AppDataPage extends StatefulWidget {
  const AppDataPage({super.key});

  @override
  State<AppDataPage> createState() => _AppDataPageState();
}

class _AppDataPageState extends State<AppDataPage> {
  final _controller = AppDataController();

  @override
  void initState() {
    _controller.loadFilesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _AppDataView(
        controller: _controller,
        deleteFile: (value) {
          _controller.deleteFile(value);
        },
        deleteFiles: () {
          _controller.deleteFiles();
        },
      );
}
