import 'dart:async';
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:ispect/ispect.dart';

QueryExecutor createExecutor() => DatabaseConnection.delayed(
      Future(() async {
        final result = await WasmDatabase.open(
          databaseName: 'db.sqlite',
          sqlite3Uri: Uri.parse('/sqlite3.wasm'),
          driftWorkerUri: Uri.parse('/drift_worker.dart.js'),
        );

        if (result.missingFeatures.isNotEmpty) {
          ISpect.logger.warning(
            'Using ${result.chosenImplementation} due to missing browser '
            'features: ${result.missingFeatures}',
          );
        }

        return result.resolvedExecutor;
      }),
    );
