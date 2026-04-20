import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppProviderObserver extends ProviderObserver {
  const AppProviderObserver();

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (!kDebugMode) return;
    debugPrint(
      '[Riverpod] INIT  ${_name(provider)}\n'
      '          value: ${_format(value)}',
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (!kDebugMode) return;
    debugPrint(
      '[Riverpod] UPDATE ${_name(provider)}\n'
      '          prev : ${_format(previousValue)}\n'
      '          next : ${_format(newValue)}',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    if (!kDebugMode) return;
    debugPrint('[Riverpod] DISPOSE ${_name(provider)}');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    // Log cả trong release để dễ theo dõi lỗi
    debugPrint(
      '[Riverpod] ERROR  ${_name(provider)}\n'
      '          error: $error',
    );
  }

  String _name(ProviderBase<Object?> provider) =>
      provider.name ?? provider.runtimeType.toString();

  String _format(Object? value) {
    if (value == null) return 'null';
    final str = value.toString();
    // Cắt ngắn nếu quá dài
    return str.length > 200 ? '${str.substring(0, 200)}...' : str;
  }
}
