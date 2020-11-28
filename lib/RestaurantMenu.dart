import 'package:mytalabat_app/FavouriteModel.dart';
import 'package:provider/provider.dart';
import 'Menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'OrderModel.dart';
import 'RatingStars.dart';
import 'Restaurant.dart';
import 'favouritList.dart';
import 'orderList.dart';



class RestaurantMenu extends StatefulWidget {
  final Restaurant restaurant;
  RestaurantMenu(this.restaurant);
  @override
  _RestaurantMenuState createState() => _RestaurantMenuState(restaurant);
}

class _RestaurantMenuState extends State<RestaurantMenu> {
  Restaurant restaurantMenu;
  _RestaurantMenuState(this.restaurantMenu);

  Future <List<Menu>> _menuList;

  List<Menu> _favorit = [];
  Future<List<Menu>> fetchMenu() async {
    http.Response response = await http.get('http://appback.ppu.edu/menus/${restaurantMenu.restID}');
    List<Menu> _menus = [];

    if (response.statusCode == 200) {
      var jsonArray = jsonDecode(response.body) as List;
      _menus = jsonArray.map((x)=> Menu.fromJson(x)).toList();
      return _menus;
    }
    else{
      throw Exception("Failed to load menus of this restaurant ");
    }
  }

  @override
  void initState() {
    super.initState();
    _menuList = fetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantMenu.restName),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon:Icon(Icons.favorite),
            color: Colors.red,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavPage()));
            },
          ),

        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.grey[200],
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.network('http://appback.ppu.edu/static/${restaurantMenu.restImage}',
                      width: MediaQuery.of(context).size.width / 2.5,
                      fit: BoxFit.cover),
                  Column(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.green[600],
                        size: 20.0,
                      ),
                      Text(restaurantMenu.restCity),
                    ],
                  ),
                  Text('discription')
                ],
              ),
            ),
          ),
          FutureBuilder(
              future: _menuList,
              builder: (context,snapshot){
                if(snapshot.hasData){
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context,int index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.grey[300],
                            child: Card(
                              color: Colors.grey[300],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Image.network(
                                      'http://appback.ppu.edu/static/${snapshot.data[index].menuImage}',
                                      width: MediaQuery.of(context).size.width/1.1,
                                      fit:BoxFit.cover
                                  ),
                                  Text(snapshot.data[index].menuName.toString()),
                                  Text('Description '+snapshot.data[index].menuDesc.toString()),
                                  Text('Price '+ snapshot.data[index].menuPrice.toString()),
                                  StarDisplay(value: snapshot.data[index].menuRating),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        MaterialButton(
                                          color: Colors.red,
                                          child: Icon(Icons.favorite_border),
                                          textColor: Colors.white,
                                          shape: CircleBorder(),
                                          padding: EdgeInsets.all(16),

                                          onPressed: (){
                                            Provider.of<FavModel>(context, listen: false).add(snapshot.data[index]);
                                          },
                                        ),
                                        MaterialButton(
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          child: Icon(Icons.add_shopping_cart),
                                          shape: CircleBorder(),
                                          padding: EdgeInsets.all(16),
                                          onPressed: (){
                                            Provider.of<OrderModel>(context,listen: false).add(snapshot.data[index]);
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => orderingPage()));
                                          },
                                        )
                                      ],
                                    ),
                                  )

                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                else if (snapshot.hasError)
                {
                  return Text("error ${snapshot.error}");
                }
                return Center(
                    child:CircularProgressIndicator()
                );
              })
        ],
      ),
    );
  }
}