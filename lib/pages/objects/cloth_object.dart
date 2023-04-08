class Cloth {
  final String name;
  final String color;
  final String type;
  final String thickness;

  Cloth({
    required this.name,
    required this.color,
    required this.type,
    required this.thickness,
  });

  factory Cloth.fromJson(Map<String, dynamic> json) {
    return Cloth(
      name: json['name']??'No Name',
      color: json['color'],
      type: json['type'],
      thickness: json['thickness'],
    );
  }
  Map<String, dynamic> toJson() => {
    'name': name,
    'color': color,
    'type': type,
    'thickness': thickness,
  };
}