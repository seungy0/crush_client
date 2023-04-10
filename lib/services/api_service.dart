import 'dart:convert';

import 'package:crush_client/models/coordination_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080";
  static const String recommend = "recommend";
  static const data = {
    "role" :"user",
    "content":"{\"cloths\": [{\"name\": \"옷1\", \"color\": \"빨강\", \"type\": \"티셔츠\", \"thickness\": \"두꺼움\"},{\"name\": \"자라에서 산거\", \"color\": \"파랑\", \"type\": \"바지\", \"thickness\": \"얇음\"}],\"options\": {\"weather\": \"sunny\",\"occasion\": \"casual\",\"season\": \"spring\",\"style\": \"sporty\"}}"
  };

  static Future<List<CoordinationModel>> getAiCoordination() async {
    print(data);
    List<CoordinationModel> coordinationInstances = [];
    final dio = Dio();
    final response = await dio.post(
      '$baseUrl/$recommend',
      data: data,
      options: Options(
        contentType: 'application/json',
      ),
      );
    print(response.data.toString());
    if (response.statusCode == 200) {
      final List<dynamic> aiCoordis = jsonDecode(response.data);
      for (var aiCoordi in aiCoordis) {
        coordinationInstances.add(CoordinationModel.fromJson(aiCoordi));
      }
      return coordinationInstances;
    }
    throw Error();
  }
}
