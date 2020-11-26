import 'package:mytalabat_app/Restaurant.dart';

import 'Menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class RestaurantMenu extends StatefulWidget {
  final Restaurant restaurant;
  RestaurantMenu(this.restaurant);
  @override
  _RestaurantMenuState createState() => _RestaurantMenuState(restaurant);



}

class _RestaurantMenuState extends State<RestaurantMenu> {
  Restaurant restaurantMenu;
  _RestaurantMenuState(this.restaurantMenu);

  @override
  Widget build(BuildContext context) {

    Future <List<Menu>> _menuList;

    Future<List<Menu>> fetchMenu() async {
      Future<List<Menu>> _menu;

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

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantMenu.restName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: _menuList,
              builder: (context,snapshot){

                if(snapshot.hasData){

                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context,int index){
                      return Expanded(
                          child: Container(
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
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.green[600],
                                        size: 20.0,
                                      ),
                                      Text(restaurantMenu.restCity),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ));
                      },
                  );
                }
                else
                  {
                    return Text("error ${snapshot.error}");
                  }
              })
        ],
      ),
    );
  }
}
