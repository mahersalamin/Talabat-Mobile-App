import 'Menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Rating.dart';
import 'Restaurant.dart';


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
      ),
      body: Column(
        children: [
          Card(
            child:Row(
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
                    Rate(restaurantMenu.restRate)
                  ],
                ),
                Column(
                  children: [

                  ],
                )
              ],
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
                        return Container(
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(
                                    'http://appback.ppu.edu/static/${snapshot.data[index].menuImage}',
                                    width: MediaQuery.of(context).size.width/1.1,
                                    fit:BoxFit.cover
                                ),
                                Text(snapshot.data[index].menuName.toString()),
                                Text('Description '+snapshot.data[index].menuDesc.toString()),
                                Text('Price '+ snapshot.data[index].menuPrice.toString()),
                              ],
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
