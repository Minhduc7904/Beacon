import 'dart:math' as math;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/group_message.dart';
import '../repositories/message_groups_repository.dart';

class SendGroupMessageUseCase {
  final MessageGroupsRepository _repository;

  SendGroupMessageUseCase(this._repository);

  Future<Either<Failure, GroupMessage>> call({
    required String groupId,
    required String content,
  }) {
    return _repository.sendMessage(
      groupId: groupId.trim(),
      content: content.trim(),
    );
  }
}

class SendPostMessageUseCase {
  final MessageGroupsRepository _repository;
  final math.Random _random;

  SendPostMessageUseCase(this._repository) : _random = math.Random.secure();

  String createClientMessageId() => _newClientMessageId();

  Future<Either<Failure, GroupMessage>> call({
    required String postId,
    required String content,
    String? clientMessageId,
  }) {
    final trimmedPostId = postId.trim();
    final trimmedContent = content.trim();
    if (trimmedPostId.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: 'Bai dang khong hop le')),
      );
    }
    if (trimmedContent.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: 'Vui long nhap tin nhan')),
      );
    }

    return _repository.sendPostMessage(
      postId: trimmedPostId,
      content: trimmedContent,
      clientMessageId: clientMessageId?.trim().isNotEmpty == true
          ? clientMessageId!.trim()
          : _newClientMessageId(),
    );
  }

  String _newClientMessageId() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0'));
    final value = hex.join();
    return [
      value.substring(0, 8),
      value.substring(8, 12),
      value.substring(12, 16),
      value.substring(16, 20),
      value.substring(20),
    ].join('-');
  }
}
