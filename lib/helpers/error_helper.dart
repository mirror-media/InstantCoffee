import 'dart:io';

import 'package:readr_app/helpers/app_exception.dart';
import 'package:readr_app/helpers/exceptions.dart';

Object determineException(dynamic error) {
  if (error is SocketException) {
    return NoInternetException('No Internet');
  } else if (error is HttpException) {
    return NoServiceFoundException('No Service Found');
  } else if (error is FormatException) {
    return InvalidFormatException('Invalid Response format');
  } else if (error is FetchDataException) {
    return NoInternetException('Error During Communication');
  } else if (error is BadRequestException ||
      error is UnauthorisedException ||
      error is InvalidInputException) {
    return Error400Exception('Unauthorised');
  } else if (error is InternalServerErrorException) {
    return Error500Exception('Internal Server Error');
  } else {
    return UnknownException(error.toString());
  }
}
