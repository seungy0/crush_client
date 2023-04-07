import 'dart:convert';

import 'package:crush_client/models/coordination_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = "http://xxxx.xxx";
  static const String today = "";

  static Future<List<CoordinationModel>> getAiCoordination() async {
    List<CoordinationModel> coordinationInstances = [];
    final dio = Dio();
    final response = await dio.get(baseUrl);
    if (response.statusCode == 200) {
      final List<dynamic> aiCoordis = jsonDecode(response.data);
      for(var aiCoordi in aiCoordis) {
        coordinationInstances.add(CoordinationModel.fromJson(aiCoordi));
      }
      return coordinationInstances;
    }
    throw Error();
  }
}