import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:event_manager_app/core/constants/api_url.dart';
import 'package:event_manager_app/core/network/dio_client.dart';
import 'package:event_manager_app/data/models/signup_req.dart';
import 'package:event_manager_app/data/models/login_req.dart';
import 'package:event_manager_app/data/models/auth_response.dart';
import 'package:event_manager_app/server_locator.dart';

abstract class AuthApiService {
  Future<Either> signup(SignupReqParams signupReq);
  Future<Either> login(LoginReqParams loginReq);
}

class AuthApiServiceImpl extends AuthApiService {
  @override
  Future<Either> signup(SignupReqParams signupReq) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrl.register,
        data: signupReq.toMap(),
      );
      return Right(AuthResponse.fromMap(response.data));
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Registration failed');
    }
  }

  @override
  Future<Either> login(LoginReqParams loginReq) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrl.login,
        data: loginReq.toMap(),
      );
      return Right(AuthResponse.fromMap(response.data));
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Login failed');
    }
  }
}