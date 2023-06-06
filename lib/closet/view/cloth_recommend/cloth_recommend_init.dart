import 'package:crush_client/closet/widget/custom_dropdown.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class ClothRecommendInit extends StatefulWidget {
  const ClothRecommendInit({Key? key}) : super(key: key);

  @override
  State<ClothRecommendInit> createState() => _ClothRecommendInitState();
}

class _ClothRecommendInitState extends State<ClothRecommendInit> {
  String weatherValue = '맑음';
  String occasionValue = '캐주얼';
  String styleValue = '활기찬';
  String seasonValue = '봄';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "AI 옷 추천",
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomDropdown(
                  value: weatherValue,
                  items: const ['흐림', '맑음', '비', '눈', '눈보라', '소나기'],
                  onChanged: (String? newValue) {
                    setState(() {
                      weatherValue = newValue!;
                    });
                  },
                ),
                CustomDropdown(
                  value: occasionValue,
                  items: const [
                    '캐주얼',
                    '비즈니스 캐주얼',
                    '비즈니스 포멀(수트)',
                    'semi-포멀',
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      occasionValue = newValue!;
                    });
                  },
                ),
                CustomDropdown(
                  value: styleValue,
                  items: const ['활기찬', '생동감', '어두운', '명랑한', '우아한', '세련된', '편안한'],
                  onChanged: (String? newValue) {
                    setState(() {
                      styleValue = newValue!;
                    });
                  },
                ),
                CustomDropdown(
                  value: seasonValue,
                  items: const ['봄', '여름', '가을', '겨울'],
                  onChanged: (String? newValue) {
                    setState(() {
                      seasonValue = newValue!;
                    });
                  },
                ),
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[300],
            ),
            Text("옷 추천해드릴게요\n"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //print form1Value
                Text(weatherValue),
                Text(occasionValue),
                Text(styleValue),
                Text(seasonValue),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                //?
              },
              child: Text("옷 추천 받기"),
            ),
          ],
        ),
      ),
    );
  }
}
