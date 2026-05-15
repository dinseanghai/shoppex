import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:shoppex/core/config/app_config.dart';
import 'package:shoppex/core/network/api_endpoints.dart';
import 'package:shoppex/data/models/login_model.dart';
import '../../flavors.dart';

class ApiClient extends GetxService {
  late Dio _dio;

  @override
  void onInit() {
    debugPrint('📡 Initializing ApiClient with: ${AppConfig.baseUrl}');
    // TODO: implement onInit
    _initializeDio();
    super.onInit();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        headers: {
          'Content-Type': "application/json",
          'Accept': "application/json",
        },
      ),
    );
  }

  Future<Response<dynamic>> register(LoginReq req) async {
    return await _dio.post(ApiEndpoints.register, data: req.toJson());
  }

  Future<Response<dynamic>> login(LoginReq req) async {
    return await _dio.post(ApiEndpoints.login, data: req.toJson());
  }
}
