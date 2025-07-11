
import 'package:dartz/dartz.dart';
import 'package:event_manager_app/data/models/signup_req.dart';
import 'package:event_manager_app/data/models/login_req.dart';
import 'package:event_manager_app/data/source/auth_api_service.dart';
import 'package:event_manager_app/domain/repository/auth.dart';
import 'package:event_manager_app/server_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signup(SignupReqParams signupReq) {
    return sl<AuthApiService>().signup(signupReq);
  }
  
  @override
  Future<Either> login(LoginReqParams loginReq) {
    return sl<AuthApiService>().login(loginReq);
  }
}