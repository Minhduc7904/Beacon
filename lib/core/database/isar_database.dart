import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'app_database.dart';
import 'database_exception.dart';
import 'isar_collections.dart';

class IsarDatabase implements AppDatabase {
  static const String databaseName = 'beacon';

  final Isar _isar;

  const IsarDatabase._(this._isar);

  static Future<IsarDatabase> open() async {
    try {
      final existing = Isar.getInstance(databaseName);
      if (existing != null) {
        return IsarDatabase._(existing);
      }

      if (isarCollections.isEmpty) {
        throw const DatabaseException(  
          'Isar requires at least one real collection schema.',
        );
      }

      final directory = await getApplicationSupportDirectory();
      final isar = await Isar.open(
        isarCollections,
        directory: directory.path,
        name: databaseName,
      );

      return IsarDatabase._(isar);
    } catch (error, stackTrace) {
      if (error is DatabaseException) {
        Error.throwWithStackTrace(error, stackTrace);
      }

      Error.throwWithStackTrace(
        DatabaseException('Could not open local database.', cause: error),
        stackTrace,
      );
    }
  }

  @override
  Future<T> read<T>(Future<T> Function(Isar isar) action) {
    return _isar.txn(() => action(_isar));
  }

  @override
  Future<T> write<T>(Future<T> Function(Isar isar) action) {
    return _isar.writeTxn(() => action(_isar));
  }

  @override
  Stream<T> watch<T>(Stream<T> Function(Isar isar) action) {
    return action(_isar);
  }

  @override
  Future<void> clearAll() async {
    try {
      await _isar.writeTxn(() => _isar.clear());
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        DatabaseException('Could not clear local database.', cause: error),
        stackTrace,
      );
    }
  }

  @override
  Future<void> close() async {
    if (_isar.isOpen) {
      await _isar.close();
    }
  }
}
