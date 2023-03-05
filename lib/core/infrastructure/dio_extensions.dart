
import 'dart:io';

import 'package:dio/dio.dart';

extension DioErrorX on DioError {
  bool get isNoConncectionError {
    // Where 'this' refers to the DioError, since we don't have access to 'e'
    // in e.type == DioErrorType.other && e.error is SocketException
    // return this.type == DioErrorType.other && this.error is SocketException;

    // But we could just call it type and error, as we are in the DioError already
    return type == DioErrorType.other && error is SocketException;
  }
}