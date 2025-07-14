import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:event_manager_app/core/constants/api_url.dart';
import 'package:event_manager_app/core/network/dio_client.dart';
import 'package:event_manager_app/server_locator.dart';

abstract class EventService {
  Future<Either> getHotEvents();
}
class EventAPIServiceImpl extends EventService {
  @override
  Future<Either> getHotEvents() async{
   try {
      var response = await sl<DioClient>().post(
        ApiUrl.hotEvents,

      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] );
    }
  }
  
}