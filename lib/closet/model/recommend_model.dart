class RecommendModel {
  final List<String> clothes;
  final String explanation;

  RecommendModel.fromJson(Map<String, dynamic> json)
      : clothes = json['clothes'],
        explanation = json['explanation'];

  RecommendModel.fromList(List<String> list)
      : clothes = list.sublist(0, list.length - 1),
        explanation = list.last;
}
