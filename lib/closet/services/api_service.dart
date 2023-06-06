import 'dart:convert';
import 'dart:io';

import 'package:crush_client/closet/model/recommend_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  // check the platform and choose the localhost ip
  static const androidIp = '10.0.2.2';
  static const iosIp = '127.0.0.1';
  static final ip = Platform.isAndroid ? androidIp : iosIp;
  
  static const String recommend = "recommend";
  static const clothRecRequest = {
    "cloths": [
      {"name": "옷1", "color": "빨강", "type": "티셔츠", "thickness": "두꺼움"},
      {"name": "자라", "color": "파랑", "type": "바지", "thickness": "얇음"},
      {"name": "옷2", "color": "검정", "type": "재킷", "thickness": "보통"},
      {"name": "옷3", "color": "노랑", "type": "원피스", "thickness": "얇음"}
    ],
    "options": {
      "weather": "sunny",
      "occasion": "casual",
      "season": "spring",
      "style": "sporty"
    },
  };

  static Future<List<RecommendModel>> getAiCoordination() async {
    print(clothRecRequest);
    List<RecommendModel> coordinationInstances = [];
    final dio = Dio();
    final response = await dio.post(
      //'$baseUrl/$recommend',
      'http://$ip:8080/$recommend',
      data: clothRecRequest,
      options: Options(
        contentType: 'application/json',
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> aiCoordis = jsonDecode(response.data);
      for (var aiCoordi in aiCoordis) {
        List<String> aiCoordi_string = [for (var e in aiCoordi) e.toString()];
        coordinationInstances.add(RecommendModel.fromList(aiCoordi_string));
      }
      return coordinationInstances;
    }
    throw Error();
  }
}
