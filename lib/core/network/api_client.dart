import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:shoppex/core/config/app_config.dart';
import 'package:shoppex/core/network/api_endpoints.dart';
import 'package:shoppex/data/models/request/login_model.dart';
import 'package:shoppex/data/models/request/reset_password.dart';
import 'package:shoppex/data/models/response/list_category.dart';
import 'package:shoppex/data/models/response/list_store.dart';
import '../../data/models/request/forget_password.dart';
import '../../data/models/request/otp_model.dart';
import '../../data/models/request/register_model.dart';
import '../../data/models/request/resent_otp_model.dart';
import '../../data/models/response/list_slide.dart';


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

  Future<Response<dynamic>> login(LoginReq req) async {
    return await _dio.post(ApiEndpoints.login, data: req.toJson());
  }

  Future<Response<dynamic>> logout(String token) async {
    return await _dio.post(
      ApiEndpoints.logout,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  Future<Response<dynamic>> register(RegisterReq req) async {
    return await _dio.post(ApiEndpoints.register, data: req.toJson());
  }

  Future<Response<dynamic>> verifyOtp(OtpReg req) async {
    return await _dio.post(ApiEndpoints.otp, data: req.toJson());
  }

  Future<Response<dynamic>> resendOtp(ResendOtpReg req) async {
    return await _dio.post(ApiEndpoints.resendotp, data: req.toJson());
  }

  Future<Response<dynamic>> forgetpassword(ForgetPasswordReg reg) async{
    return await _dio.post(ApiEndpoints.forgetpassword, data: reg.toJson());
  }

  Future<Response<dynamic>> resetpassword(ResetPasswordReg req) async {
    return await _dio.post(ApiEndpoints.resetpassword, data: req.toJson());
  }

  Future<Response<dynamic>> listslideshow(SlideShow res) async {
    return await _dio.get(ApiEndpoints.listslideshow, data:  res.toJson());
  }

  Future<Response<dynamic>> listcategory(ListCategory res) async {
    return await _dio.get(ApiEndpoints.listcategory, data: res.toJson());
  }

  Future<Response<dynamic>> liststore(ListStore res) async {
    return await _dio.get(ApiEndpoints.liststore, data: res.toJson());
  }

  Future<Response<dynamic>> favonstore(int storeId) async {
    return await _dio.post('${ApiEndpoints.favonstore}/$storeId/favorite');
  }
}

