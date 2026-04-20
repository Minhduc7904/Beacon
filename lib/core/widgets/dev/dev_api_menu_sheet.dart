import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/api_endpoints.dart';
import '../../providers/providers.dart';

enum DevApiHttpMethod { get, post, put, delete }

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
  ];

  final _bearerController = TextEditingController();
  final _inputController = TextEditingController(text: _apiItems.first.sampleInput);
  late DevApiItem _selectedApi;
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

    final input = _inputController.text.trim();
    Map<String, dynamic> payload = <String, dynamic>{};

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

  Future<Response<dynamic>> _sendRequest({
    required Dio dio,
    required Options options,
    required Map<String, dynamic> payload,
  }) {
    switch (_selectedApi.method) {
      case DevApiHttpMethod.get:
        return dio.get(
          _selectedApi.path,
          queryParameters: payload.isEmpty ? null : payload,
          options: options,
        );
      case DevApiHttpMethod.post:
        return dio.post(
          _selectedApi.path,
          data: payload.isEmpty ? null : payload,
          options: options,
        );
      case DevApiHttpMethod.put:
        return dio.put(
          _selectedApi.path,
          data: payload.isEmpty ? null : payload,
          options: options,
        );
      case DevApiHttpMethod.delete:
        return dio.delete(
          _selectedApi.path,
          data: payload.isEmpty ? null : payload,
          options: options,
        );
    }
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
                          : const Icon(Icons.play_arrow_rounded),
                      label: Text(_isCalling ? 'Đang gọi...' : 'Gọi API'),
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
