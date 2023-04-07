class CoordinationModel {
  final List<String> clothes;
  final String explanation;

  CoordinationModel.fromJson(Map<String, dynamic> json)
      : clothes = json['clothes'],
        explanation = json['explanation'];
}
