import 'package:login/src/utils/status_code.dart';

class AppResponse {
  final int status;
  final String message;
  final dynamic data;

  AppResponse({
    required this.status,
    required this.message,
    required this.data,
  });
  
  factory AppResponse.ok(Map<String, String> map, {String message = '', dynamic data}) {
    return AppResponse(status: StatusCode.ok, message: message, data: data);
  }

  factory AppResponse.unauthorized({String message = '', dynamic data}) {
    return AppResponse(
      status: StatusCode.unauthorized,
      message: message,
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}
