import 'dart:convert';
import 'dart:io';

import 'package:crush_client/closet/model/recommend_model.dart';
import 'package:dio/dio.dart';

import '../model/cloth_model.dart';

class ApiService {
  // check the platform and choose the localhost ip
  static const androidIp = '10.0.2.2';
  static const iosIp = '127.0.0.1';
  static final ip = Platform.isAndroid ? androidIp : iosIp;
  static const String endpoint = "recommend";

  static Future<List<RecommendModel>> getAiCoordination({
    required List<Cloth> cloths,
    required String weather,
    required String occasion,
    required String season,
    required String style,
  }) async {
    final clothRecRequest = {
      "cloths": cloths.map((cloth) =>{
        "name": cloth.name,
        "color": cloth.color,
        "type": cloth.type,
        "thickness": cloth.thickness,
      }).toList(),
      "options": {
        "weather": weather,
        "occasion": occasion,
        "season": season,
        "style": style
      },
    };

    print(clothRecRequest); // for debugging
    List<RecommendModel> coordinationInstances = [];
    final dio = Dio();
    final response = await dio.post(
      //'$baseUrl/$endpoint',
      'http://$ip:8080/$endpoint',
      data: clothRecRequest,
      options: Options(
        contentType: 'application/json',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> aiCoordis = jsonDecode(response.data);
      for (var aiCoordi in aiCoordis) {
        List<String> aicoordiString = [for (var e in aiCoordi) e.toString()];
        coordinationInstances.add(RecommendModel.fromList(aicoordiString));
      }
      return coordinationInstances;
    }
    throw Error();
  }
}
