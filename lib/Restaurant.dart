class Restaurant {
  int restID;
  String restName;
  String restCity;
  String restImage;
  String restLat;
  String restLng;
  String restPhone;
  int restRate;

  Restaurant({this.restID, this.restName, this.restCity, this.restImage, this.restLat, this.restLng, this.restPhone, this.restRate});

  factory Restaurant.fromJson(dynamic json){
    return Restaurant(
      restID: json['id'] as int,
      restName: json['name'] as String,
      restCity: json['city'] as String,
      restImage: json['image'] as String,
      restPhone: json['phone'] as String,
      restRate: json['rating'] as int,
      restLat: json['lat'] as String,
      restLng: json['lng'] as String,
    );
  }
  @override
  String toString() {
    return 'Restaurant{restID: $restID, restName: $restName, restCity: $restCity, restImage: $restImage, restLat: $restLat, restLng: $restLng, restPhone: $restPhone, restRate: $restRate}';
  }
}