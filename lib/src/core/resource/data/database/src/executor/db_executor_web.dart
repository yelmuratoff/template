import 'dart:async';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

QueryExecutor createExecutor() => DatabaseConnection.delayed(
      Future(() async {
        final result = await WasmDatabase.open(
          databaseName: 'db.sqlite',
          sqlite3Uri: Uri.parse('/sqlite3.wasm'),
          driftWorkerUri: Uri.parse('/drift_worker.dart.js'),
        );

        if (result.missingFeatures.isNotEmpty) {
          talker.warning(
            'Using ${result.chosenImplementation} due to missing browser '
            'features: ${result.missingFeatures}',
          );
        }

        return result.resolvedExecutor;
      }),
    );
