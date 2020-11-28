import 'package:mytalabat_app/RestaurantMenu.dart';
import 'RatingStars.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Restaurant.dart';
import 'dart:convert';

class AllResturant extends StatefulWidget {
  @override
  _AllResturantState createState() => _AllResturantState();
}

class _AllResturantState extends State<AllResturant> {
  Future<List<Restaurant>> _restaurants;

  Future<List<Restaurant>> fetchRest() async {
    http.Response response =
        await http.get('http://appback.ppu.edu/restaurants');
    List<Restaurant> _restaurant = [];

    if (response.statusCode == 200) {
      var jsonArray = jsonDecode(response.body) as List;
      _restaurant = jsonArray.map((x) => Restaurant.fromJson(x)).toList();
      return _restaurant;
    } else {
      throw Exception("Failed to load data ");
    }
  }

  @override
  void initState() {
    super.initState();
    _restaurants = fetchRest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants Page'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: _restaurants,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                child: Container(
                                  color: Colors.grey[200],
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            child: Image.network('http://appback.ppu.edu/static/${snapshot.data[index].restImage}',
                                              width: MediaQuery.of(context).size.width / 2.11,
                                              fit: BoxFit.cover,
                                              height: 90,
                                            ),
                                          ),
                                          Container(
                                            child:Text(snapshot.data[index].restName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.green[600],
                                                size: 20.0,
                                              ),
                                              Text(snapshot.data[index].restCity),
                                            ],
                                          ),
                                          StarDisplay(
                                              value:
                                              snapshot.data[index].restRate)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MaterialButton(
                                            color: Colors.amber,
                                            padding: EdgeInsets.all(16),
                                            shape: CircleBorder(),
                                            textColor: Colors.white,
                                            child: Icon(Icons.menu_book),
                                            onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantMenu(snapshot.data[index])));
                                            },
                                          ),
                                          MaterialButton(
                                            color: Colors.redAccent,
                                            padding: EdgeInsets.all(16),
                                            shape: CircleBorder(),
                                            textColor: Colors.white,
                                            child: Icon(Icons.rate_review_outlined),
                                            onPressed: (){
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("error ${snapshot.error}");
                }
                return Center(child: CircularProgressIndicator());
              })
        ],
      ),
    );
  }
}
