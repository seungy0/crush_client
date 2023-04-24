class CoordinationModel {
  final List<String> clothes;
  final String explanation;

  CoordinationModel.fromJson(Map<String, dynamic> json)
      : clothes = json['clothes'],
        explanation = json['explanation'];

  CoordinationModel.fromList(List<String> list)
      : clothes = list.sublist(0, list.length-1),
        explanation = list.last;
}
