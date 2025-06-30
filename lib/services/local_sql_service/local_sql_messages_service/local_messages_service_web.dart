import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

LazyDatabase openMessagesDbConnection() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'messages',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}