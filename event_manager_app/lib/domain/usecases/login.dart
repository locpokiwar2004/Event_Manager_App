import 'package:dartz/dartz.dart';
import 'package:event_manager_app/core/usecase/usecase.dart';
import 'package:event_manager_app/data/models/login_req.dart';
import 'package:event_manager_app/domain/repository/auth.dart';
import 'package:event_manager_app/server_locator.dart';

class LoginUsecase implements Usecase<Either, LoginReqParams> {
  @override
  Future<Either> call(LoginReqParams? param) async {
    return sl<AuthRepository>().login(param!);
  }
}
