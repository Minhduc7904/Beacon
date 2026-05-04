import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/api_endpoints.dart';
import '../../providers/providers.dart';

enum DevApiHttpMethod { get, post, put, patch, delete }

class DevApiItem {
  const DevApiItem({
    required this.title,
    required this.path,
    required this.method,
    this.sampleInput = '{}',
  });

  final String title;
  final String path;
  final DevApiHttpMethod method;
  final String sampleInput;

  String get methodLabel => method.name.toUpperCase();
}

class DevApiMenuSheet extends ConsumerStatefulWidget {
  const DevApiMenuSheet({super.key});

  @override
  ConsumerState<DevApiMenuSheet> createState() => _DevApiMenuSheetState();
}

class _DevApiMenuSheetState extends ConsumerState<DevApiMenuSheet> {
  static const List<DevApiItem> _apiItems = [
    DevApiItem(
      title: 'Health',
      path: ApiEndpoints.health,
      method: DevApiHttpMethod.get,
    ),
    DevApiItem(
      title: 'Health Live',
      path: ApiEndpoints.healthLive,
      method: DevApiHttpMethod.get,
    ),
    DevApiItem(
      title: 'Health Ready',
      path: ApiEndpoints.healthReady,
      method: DevApiHttpMethod.get,
    ),
    DevApiItem(
      title: 'Health DB',
      path: ApiEndpoints.healthDb,
      method: DevApiHttpMethod.get,
    ),
    DevApiItem(
      title: 'Health MinIO',
      path: ApiEndpoints.healthMinio,
      method: DevApiHttpMethod.get,
    ),
    DevApiItem(
      title: 'Login',
      path: ApiEndpoints.login,
      method: DevApiHttpMethod.post,
      sampleInput: '{"username":"","password":""}',
    ),
    DevApiItem(
      title: 'Check Email',
      path: ApiEndpoints.checkEmail,
      method: DevApiHttpMethod.get,
      sampleInput: '{"email":""}',
    ),
    DevApiItem(
      title: 'Check Phone',
      path: ApiEndpoints.checkPhone,
      method: DevApiHttpMethod.get,
      sampleInput: '{"phoneNumber":""}',
    ),
    DevApiItem(
      title: 'Register',
      path: ApiEndpoints.register,
      method: DevApiHttpMethod.post,
      sampleInput:
          '{"email":"","password":"","confirmPassword":"","familyName":"","givenName":"","username":"","phoneNumber":""}',
    ),
    DevApiItem(
      title: 'Logout',
      path: ApiEndpoints.logout,
      method: DevApiHttpMethod.post,
      sampleInput: '{"refreshToken":""}',
    ),
    DevApiItem(
      title: 'Refresh Token',
      path: ApiEndpoints.refreshToken,
      method: DevApiHttpMethod.post,
      sampleInput: '{"refreshToken":""}',
    ),
    DevApiItem(
      title: 'Upload Post Media',
      path: ApiEndpoints.postMediaUpload,
      method: DevApiHttpMethod.post,
      sampleInput: '{"filePath":""}',
    ),
    DevApiItem(
      title: 'Get Media By Id',
      path: ApiEndpoints.mediaByIdTemplate,
      method: DevApiHttpMethod.get,
      sampleInput: '{"id":""}',
    ),
    DevApiItem(
      title: 'Soft Delete Media',
      path: ApiEndpoints.mediaSoftDeleteTemplate,
      method: DevApiHttpMethod.delete,
      sampleInput: '{"id":""}',
    ),
    DevApiItem(
      title: 'Create Friend Request',
      path: ApiEndpoints.friendRequests,
      method: DevApiHttpMethod.post,
      sampleInput: '{"receiverId":""}',
    ),
    DevApiItem(
      title: 'Accept Friend Request',
      path: ApiEndpoints.friendRequestAcceptTemplate,
      method: DevApiHttpMethod.post,
      sampleInput: '{"id":""}',
    ),
    DevApiItem(
      title: 'Decline Friend Request',
      path: ApiEndpoints.friendRequestDeclineTemplate,
      method: DevApiHttpMethod.post,
      sampleInput: '{"id":""}',
    ),
    DevApiItem(
      title: 'Received Friend Requests',
      path: ApiEndpoints.friendRequestsReceived,
      method: DevApiHttpMethod.get,
      sampleInput: '{"cursor":"","limit":20}',
    ),
    DevApiItem(
      title: 'Sent Friend Requests',
      path: ApiEndpoints.friendRequestsSent,
      method: DevApiHttpMethod.get,
      sampleInput: '{"cursor":"","limit":20}',
    ),
    DevApiItem(
      title: 'Friends',
      path: ApiEndpoints.friends,
      method: DevApiHttpMethod.get,
      sampleInput: '{"cursor":"","limit":20}',
    ),
    DevApiItem(
      title: 'Friend Detail',
      path: ApiEndpoints.friendByUserIdTemplate,
      method: DevApiHttpMethod.get,
      sampleInput: '{"userId":""}',
    ),
    DevApiItem(
      title: 'Update Friend Type',
      path: ApiEndpoints.friendTypeByUserIdTemplate,
      method: DevApiHttpMethod.patch,
      sampleInput: '{"userId":"","type":2}',
    ),
    DevApiItem(
      title: 'Delete Friend',
      path: ApiEndpoints.friendDeleteByUserIdTemplate,
      method: DevApiHttpMethod.delete,
      sampleInput: '{"userId":""}',
    ),
    DevApiItem(
      title: 'Message Groups',
      path: ApiEndpoints.messageGroups,
      method: DevApiHttpMethod.get,
      sampleInput: '{"cursor":"","limit":20}',
    ),
    DevApiItem(
      title: 'Send Group Message',
      path: ApiEndpoints.messageGroupMessageTemplate,
      method: DevApiHttpMethod.post,
      sampleInput: '{"groupId":"","content":""}',
    ),
    DevApiItem(
      title: 'Group Messages',
      path: ApiEndpoints.messageGroupMessageTemplate,
      method: DevApiHttpMethod.get,
      sampleInput: '{"groupId":"","cursor":"","limit":20}',
    ),
  ];

  final _bearerController = TextEditingController();
  final _inputController = TextEditingController(text: _apiItems.first.sampleInput);
  late DevApiItem _selectedApi;
  String? _selectedMediaFilePath;
  bool _isCalling = false;
  String _output = '';

  @override
  void initState() {
    super.initState();
    _selectedApi = _apiItems.first;
    _prefillBearerFromPreferences();
  }

  @override
  void dispose() {
    _bearerController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _prefillBearerFromPreferences() async {
    final token = await ref.read(authLocalDatasourceProvider).getAccessToken();
    if (!mounted || token == null || token.trim().isEmpty) {
      return;
    }

    _bearerController.text = token.trim();
  }

  Future<void> _callApi() async {
    if (_isCalling) {
      return;
    }
    Map<String, dynamic> payload = <String, dynamic>{};

    if (_isMediaUploadEndpoint) {
      final filePath = _selectedMediaFilePath?.trim() ?? '';
      if (filePath.isEmpty) {
        setState(() {
          _output = 'Vui lòng chọn ảnh trước khi upload.';
        });
        return;
      }

      payload = {'filePath': filePath};
    } else {
      final input = _inputController.text.trim();

      if (input.isNotEmpty) {
        try {
          final decoded = jsonDecode(input);
          if (decoded is! Map<String, dynamic>) {
            setState(() {
              _output = 'Input phải là JSON object hợp lệ.';
            });
            return;
          }
          payload = decoded;
        } catch (_) {
          setState(() {
            _output = 'Input JSON không hợp lệ.';
          });
          return;
        }
      }
    }

    if (_requiresIdPathParam &&
        (payload['id']?.toString().trim().isEmpty ?? true)) {
      setState(() {
        _output = 'Input cần có trường "id" cho endpoint này.';
      });
      return;
    }

    if (_requiresUserIdPathParam &&
        (payload['userId']?.toString().trim().isEmpty ?? true)) {
      setState(() {
        _output = 'Input can co truong "userId" cho endpoint nay.';
      });
      return;
    }

    if (_requiresGroupIdPathParam &&
        (payload['groupId']?.toString().trim().isEmpty ?? true)) {
      setState(() {
        _output = 'Input can co truong "groupId" cho endpoint nay.';
      });
      return;
    }

    if (_isMediaUploadEndpoint &&
        (payload['filePath']?.toString().trim().isEmpty ?? true)) {
      setState(() {
        _output = 'Input cần có trường "filePath" cho endpoint upload ảnh.';
      });
      return;
    }

    final bearer = _bearerController.text.trim();
    final options = Options(
      headers: {
        if (bearer.isNotEmpty) 'Authorization': 'Bearer $bearer',
      },
    );

    setState(() {
      _isCalling = true;
      _output = '';
    });

    final dio = ref.read(dioClientProvider).dio;

    try {
      final response = await _sendRequest(
        dio: dio,
        options: options,
        payload: payload,
      );

      setState(() {
        _output = _buildSuccessOutput(response);
      });
    } on DioException catch (e) {
      setState(() {
        _output = _buildErrorOutput(e);
      });
    } catch (e) {
      setState(() {
        _output = 'Unexpected error: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isCalling = false;
        });
      }
    }
  }

  Future<void> _pickMediaFile() async {
    if (_isCalling) {
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (!mounted || result == null || result.files.isEmpty) {
      return;
    }

    final filePath = result.files.single.path?.trim() ?? '';
    if (filePath.isEmpty) {
      setState(() {
        _output = 'Không đọc được đường dẫn ảnh đã chọn.';
      });
      return;
    }

    setState(() {
      _selectedMediaFilePath = filePath;
      _output = '';
    });
  }

  Future<void> _pickAndUploadMedia() async {
    await _pickMediaFile();
    final filePath = _selectedMediaFilePath?.trim() ?? '';
    if (filePath.isEmpty) {
      return;
    }

    await _callApi();
  }

  Future<Response<dynamic>> _sendRequest({
    required Dio dio,
    required Options options,
    required Map<String, dynamic> payload,
  }) async {
    final path = _resolvePath(payload);
    final requestPayload = _stripPathParams(payload);
    final requestData = await _buildRequestData(requestPayload);
    final requestOptions = _resolveRequestOptions(options);

    switch (_selectedApi.method) {
      case DevApiHttpMethod.get:
        return dio.get(
          path,
          queryParameters: requestPayload.isEmpty ? null : requestPayload,
          options: requestOptions,
        );
      case DevApiHttpMethod.post:
        return dio.post(
          path,
          data: requestData,
          options: requestOptions,
        );
      case DevApiHttpMethod.put:
        return dio.put(
          path,
          data: requestData,
          options: requestOptions,
        );
      case DevApiHttpMethod.patch:
        return dio.patch(
          path,
          data: requestData,
          options: requestOptions,
        );
      case DevApiHttpMethod.delete:
        return dio.delete(
          path,
          data: requestData,
          options: requestOptions,
        );
    }
  }

  bool get _isMediaUploadEndpoint =>
      _selectedApi.path == ApiEndpoints.postMediaUpload;

  bool get _requiresIdPathParam =>
      _selectedApi.path == ApiEndpoints.mediaByIdTemplate ||
      _selectedApi.path == ApiEndpoints.mediaSoftDeleteTemplate ||
      _selectedApi.path == ApiEndpoints.friendRequestAcceptTemplate ||
      _selectedApi.path == ApiEndpoints.friendRequestDeclineTemplate;

  bool get _requiresUserIdPathParam =>
      _selectedApi.path == ApiEndpoints.friendByUserIdTemplate ||
      _selectedApi.path == ApiEndpoints.friendTypeByUserIdTemplate ||
      _selectedApi.path == ApiEndpoints.friendDeleteByUserIdTemplate;

  bool get _requiresGroupIdPathParam =>
      _selectedApi.path == ApiEndpoints.messageGroupMessageTemplate;

  String _resolvePath(Map<String, dynamic> payload) {
    if (_selectedApi.path == ApiEndpoints.mediaByIdTemplate) {
      return ApiEndpoints.mediaById(payload['id'].toString().trim());
    }

    if (_selectedApi.path == ApiEndpoints.mediaSoftDeleteTemplate) {
      return ApiEndpoints.mediaSoftDelete(payload['id'].toString().trim());
    }

    if (_selectedApi.path == ApiEndpoints.friendRequestAcceptTemplate) {
      return ApiEndpoints.friendRequestAccept(payload['id'].toString().trim());
    }

    if (_selectedApi.path == ApiEndpoints.friendRequestDeclineTemplate) {
      return ApiEndpoints.friendRequestDecline(payload['id'].toString().trim());
    }

    if (_selectedApi.path == ApiEndpoints.friendByUserIdTemplate) {
      return ApiEndpoints.friendByUserId(payload['userId'].toString().trim());
    }

    if (_selectedApi.path == ApiEndpoints.friendTypeByUserIdTemplate) {
      return ApiEndpoints.friendTypeByUserId(
        payload['userId'].toString().trim(),
      );
    }

    if (_selectedApi.path == ApiEndpoints.friendDeleteByUserIdTemplate) {
      return ApiEndpoints.friendDeleteByUserId(
        payload['userId'].toString().trim(),
      );
    }

    if (_selectedApi.path == ApiEndpoints.messageGroupMessageTemplate) {
      return ApiEndpoints.messageGroupMessage(
        payload['groupId'].toString().trim(),
      );
    }

    return _selectedApi.path;
  }

  Map<String, dynamic> _stripPathParams(Map<String, dynamic> payload) {
    if (!_requiresIdPathParam &&
        !_requiresUserIdPathParam &&
        !_requiresGroupIdPathParam &&
        !_isMediaUploadEndpoint) {
      return payload;
    }

    final sanitized = Map<String, dynamic>.from(payload);
    if (_requiresIdPathParam) {
      sanitized.remove('id');
    }
    if (_requiresUserIdPathParam) {
      sanitized.remove('userId');
    }
    if (_requiresGroupIdPathParam) {
      sanitized.remove('groupId');
    }
    return sanitized;
  }

  Future<dynamic> _buildRequestData(Map<String, dynamic> payload) async {
    if (_selectedApi.method == DevApiHttpMethod.get) {
      return null;
    }

    if (_isMediaUploadEndpoint) {
      final filePath = payload['filePath']?.toString().trim() ?? '';
      final fileName = filePath.split(RegExp(r'[\\/]')).last;
      final multipartFile = await MultipartFile.fromFile(
        filePath,
        filename: fileName.isEmpty ? 'upload.jpg' : fileName,
      );

      return FormData.fromMap({'file': multipartFile});
    }

    return payload.isEmpty ? null : payload;
  }

  Options _resolveRequestOptions(Options options) {
    if (_isMediaUploadEndpoint) {
      return options.copyWith(contentType: 'multipart/form-data');
    }

    return options;
  }

  String _buildSuccessOutput(Response<dynamic> response) {
    final prettyData = _prettyJson(response.data);
    return 'Status: ${response.statusCode}\n\n$prettyData';
  }

  String _buildErrorOutput(DioException error) {
    final status = error.response?.statusCode;
    final responseData = error.response?.data;
    final body = responseData != null ? _prettyJson(responseData) : '';
    final message = error.message?.trim();

    final buffer = StringBuffer();
    buffer.writeln('Status: ${status ?? 'N/A'}');
    if (message != null && message.isNotEmpty) {
      buffer.writeln('Message: $message');
    }
    if (body.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(body);
    }

    return buffer.toString().trim();
  }

  String _prettyJson(dynamic data) {
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: mediaQuery.viewInsets.bottom + 16,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.85),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'API Dev Tool',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<DevApiItem>(
                initialValue: _selectedApi,
                decoration: const InputDecoration(
                  labelText: 'API',
                  border: OutlineInputBorder(),
                ),
                items: _apiItems
                    .map(
                      (api) => DropdownMenuItem<DevApiItem>(
                        value: api,
                        child: Text('${api.methodLabel} ${api.path}'),
                      ),
                    )
                    .toList(),
                onChanged: (next) {
                  if (next == null) {
                    return;
                  }
                  setState(() {
                    _selectedApi = next;
                    _inputController.text = next.sampleInput;
                    if (_selectedApi.path != ApiEndpoints.postMediaUpload) {
                      _selectedMediaFilePath = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _bearerController,
                decoration: const InputDecoration(
                  labelText: 'Bearer token',
                  hintText: 'Nhập token hoặc để trống',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              if (_isMediaUploadEndpoint)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _selectedMediaFilePath == null
                            ? 'Chưa chọn ảnh'
                            : 'Ảnh đã chọn:\n$_selectedMediaFilePath',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isCalling ? null : _pickMediaFile,
                              icon: const Icon(Icons.photo_library_outlined),
                              label: const Text('Chọn ảnh'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _isCalling ? null : _pickAndUploadMedia,
                              icon: const Icon(Icons.cloud_upload_outlined),
                              label: const Text('Chọn & Upload'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                TextField(
                  controller: _inputController,
                  minLines: 4,
                  maxLines: 8,
                  decoration: InputDecoration(
                    labelText: _selectedApi.method == DevApiHttpMethod.get
                        ? 'Query input (JSON object)'
                        : 'Body input (JSON object)',
                    border: const OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _isCalling ? null : _callApi,
                      icon: _isCalling
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              _isMediaUploadEndpoint
                                  ? Icons.cloud_upload_outlined
                                  : Icons.play_arrow_rounded,
                            ),
                      label: Text(
                        _isCalling
                            ? 'Đang gọi...'
                            : _isMediaUploadEndpoint
                            ? 'Upload ảnh đã chọn'
                            : 'Gọi API',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _isCalling
                        ? null
                        : () {
                            setState(() {
                              _output = '';
                            });
                          },
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Output',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      _output.isEmpty ? 'Chưa có kết quả' : _output,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
