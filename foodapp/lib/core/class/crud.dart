import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:foodapp/core/functions/checkinternet.dart';
import 'package:http/http.dart' as http;
import 'statusrequest.dart'; // Import the dartz library for Either type

class Crud {
  Future<Either<StatusRequest, Map>> postData(String linkurl, Map data) async {
    try {
      if (await checkInternet()) {
        var response = await http.post(Uri.parse(linkurl), body: data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map responsebody = jsonDecode(response.body);
          return Right(responsebody);
        } else {
          return Left(StatusRequest.serverfailure);
        }
      } else {
        return Left(StatusRequest.offlinefailure);
      }
    } catch (_) {
      return Left(StatusRequest.serverException);
    }
  }
}
