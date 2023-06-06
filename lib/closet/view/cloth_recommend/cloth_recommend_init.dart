import 'package:crush_client/closet/widget/custom_dropdown.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class ClothRecommendInit extends StatefulWidget {
  const ClothRecommendInit({Key? key}) : super(key: key);

  @override
  State<ClothRecommendInit> createState() => _ClothRecommendInitState();
}

class _ClothRecommendInitState extends State<ClothRecommendInit> {
  String form1Value = '맑음';
  String form2Value = '캐주얼';
  String form3Value = '활기찬';

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
                  value: form1Value,
                  items: const ['흐림', '맑음', '비', '눈', '눈보라', '소나기'],
                  onChanged: (String? newValue) {
                    setState(() {
                      form1Value = newValue!;
                    });
                  },
                ),
                CustomDropdown(
                  value: form2Value,
                  items: const [
                    '캐주얼',
                    '비즈니스 캐주얼',
                    '비즈니스 포멀(수트)',
                    'semi-포멀',
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      form2Value = newValue!;
                    });
                  },
                ),
                CustomDropdown(
                  value: form3Value,
                  items: const ['활기찬', '생동감', '어두운', '명랑한', '우아한', '세련된', '편안한'],
                  onChanged: (String? newValue) {
                    setState(() {
                      form3Value = newValue!;
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
                Text(form1Value),
                Text(form2Value),
                Text(form3Value),
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
