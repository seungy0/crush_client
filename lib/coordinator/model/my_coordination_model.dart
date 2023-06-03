class MyOutfit {
  String coordiId;
  final String title;
  final String ownerId;
  final String photoUrl;
  final String description;
  final List<Rating> ratings;

  MyOutfit({
    required this.coordiId,
    required this.title,
    required this.ownerId,
    required this.photoUrl,
    required this.description,
    required this.ratings,
  });

  factory MyOutfit.fromJson(Map<String, dynamic> json) {
    return MyOutfit(
        coordiId: json['coordiId'] ?? 'none',
        title: json['title'] ?? 'none',
        ownerId: json['ownerId'] ?? 'none',
        photoUrl: json['photoUrl'] ?? 'none',
        description: json['description'] ?? 'none',
        ratings: (json['ratings'] as List<dynamic>?)
                ?.map((e) => Rating.fromJson(e))
                .toList() ??
            []);
  }

  Map<String, dynamic> toJson() => {
        'coordiId': coordiId,
        'title': title,
        'photoUrl': photoUrl,
        'description': description,
        'ratings': ratings.map((rating) => rating.toJson()).toList(),
      };
}

class Rating {
  final String raterUserId;
  final double stars;

  Rating({
    required this.raterUserId,
    required this.stars,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      raterUserId: json['raterUserId'] ?? 'none',
      stars: json['stars'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'raterUserId': raterUserId,
        'stars': stars,
      };
}
