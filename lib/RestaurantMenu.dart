import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mytalabat_app/FavouriteModel.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
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

  List<Marker> allMarkers=[];
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
    allMarkers.add(Marker(markerId: MarkerId('myMarker'),draggable:false,
        onTap:(){
          print('Marker is tapped');
        },
        position:LatLng( double.parse('${restaurantMenu.restLat}'), double.parse('${restaurantMenu.restLng}'))
    ));
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
            child: Container(
              height:240,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[200],
              child:GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng( double.parse('${restaurantMenu.restLat}'), double.parse('${restaurantMenu.restLng}')),
                    zoom: 14.0
                ),
                markers: Set.from(allMarkers),
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
                        bool isSaved= false;
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
                                  Text('\nDescription '+snapshot.data[index].menuDesc.toString()),
                                  Text('\nPrice '+ snapshot.data[index].menuPrice.toString()),
                                  StarDisplay(value: snapshot.data[index].menuRating),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        MaterialButton(
                                          color: Colors.red,
                                          child: Icon(isSaved?Icons.favorite: Icons.favorite_border,
                                            color:Colors.white),
                                          textColor: Colors.white,
                                          shape: CircleBorder(),
                                          padding: EdgeInsets.all(16),
                                          onPressed: () {
                                            if(isSaved==false){
                                              Provider.of<FavModel>(context, listen: false).add(snapshot.data[index]);
                                              isSaved=!isSaved;
                                            }
                                            else if(isSaved==true){
                                            Provider.of<FavModel>(context, listen: false).remove(snapshot.data[index]);
                                            isSaved=!isSaved;
                                            }

                                          }
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