class Menu{
  int menuId;
  int restId;
  String menuName;
  String menuDesc;
  int menuPrice;
  String menuImage;
  int menuRating;

  Menu({this.menuId,this.restId, this.menuName, this.menuDesc, this.menuPrice,
    this.menuImage, this.menuRating});
  factory Menu.fromJson(dynamic json){
    int rate = json['rating'];
    if(rate ==  null){
      rate = 0;
    }
    return Menu(
      menuId:json['id'] as int,
      restId:json['rest_id'] as int,
      menuName: json['name'] as String,
      menuDesc: json['descr'] as String,
      menuPrice: json['price'] as int,
      menuImage: json['image'] as String,
      menuRating: rate
    );
  }

  @override
  String toString() {
    return 'Menu{menuId: $menuId, restId: $restId, menuName: $menuName, menuDesc: $menuDesc, menuPrice: $menuPrice, menuImage: $menuImage, menuRating: $menuRating}';
  }
}