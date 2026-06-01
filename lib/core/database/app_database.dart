import 'package:isar/isar.dart';

abstract class AppDatabase {
  Future<T> read<T>(Future<T> Function(Isar isar) action);

  Future<T> write<T>(Future<T> Function(Isar isar) action);

  Stream<T> watch<T>(Stream<T> Function(Isar isar) action);

  Future<void> clearAll();

  Future<void> close();
}
