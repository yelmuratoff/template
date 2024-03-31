import 'package:base_starter/src/core/resource/data/database/database.dart';
import 'package:base_starter/src/core/resource/data/database/src/tables/todos_table.dart';
import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// The drift-managed database configuration
@DriftDatabase(tables: [TodosTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? createExecutor());

  @override
  int get schemaVersion => 1;
}
