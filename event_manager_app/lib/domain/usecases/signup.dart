import 'package:dartz/dartz.dart';
import 'package:event_manager_app/core/usecase/usecase.dart';
import 'package:event_manager_app/data/models/signup_req.dart';
import 'package:event_manager_app/domain/repository/auth.dart';
import 'package:event_manager_app/server_locator.dart';

class SingupUsecase implements Usecase<Either, SignupReqParams> {
  @override
  Future<Either> call(SignupReqParams ? param) async{
    return sl<AuthRepository>().signup(param!);
  }
}
