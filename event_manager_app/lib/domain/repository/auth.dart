import 'package:dartz/dartz.dart';
import 'package:event_manager_app/data/models/signup_req.dart';
import 'package:event_manager_app/data/models/login_req.dart';

abstract class AuthRepository {
  Future<Either> signup(SignupReqParams signupReq);
  Future<Either> login(LoginReqParams loginReq);
}

