import 'package:mytalabat_app/RestaurantMenu.dart';
import 'RatingStars.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Restaurant.dart';
import 'dart:convert';

import 'orderList.dart';

class AllResturant extends StatefulWidget {
  @override
  _AllResturantState createState() => _AllResturantState();
}

class _AllResturantState extends State<AllResturant> {

  bool isCityChanged = true;
  Future<List<Restaurant>> _restaurants;
  List<String> cities;
  List<int> rates=[1,2,3,4,5];

  Future<List<Restaurant>> fetchRest(String query,int withCondition) async {

    http.Response response =
    await http.get('http://appback.ppu.edu/restaurants');
    List<Restaurant> _restaurant = [];

    if (response.statusCode == 200) {

      var jsonArray = jsonDecode(response.body) as List;
     switch(withCondition){

       //all restaurant
       case 1:  _restaurant = jsonArray.map((x) => Restaurant.fromJson(x)).toList();
       break;

       //list by city name
       case 2:  _restaurant = jsonArray.map((x) => Restaurant.fromJson(x)).where((element) => element.restCity==query).toList();
       break;

       //list by rate
       case 3:  _restaurant = jsonArray.map((x) => Restaurant.fromJson(x)).where((element) => (element.restRate~/2)==int.parse(query) ).toList();
       break;
     }
      return _restaurant;
    } else {
      throw Exception("Failed to load data ");
    }
  }

  @override
  void initState() {
    super.initState();
    _restaurants = fetchRest("",1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants Page'),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.filter),
              onPressed: (){
                openFilterDialog();
              }
          )
        ],
      ),

      body: Column(
        children: [
          FutureBuilder <List<Restaurant>>(
              future: _restaurants,
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  if(isCityChanged ){
                    cities=snapshot.data.map((e) => e.restCity).toSet().toList();
                  }
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
                                            child:Text(snapshot.data[index].restName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 21.0),
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
                                            child: Icon(Icons.menu),
                                            onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantMenu(snapshot.data[index])));
                                            },
                                          ),
                                          MaterialButton(
                                            color: Colors.redAccent,
                                            padding: EdgeInsets.all(16),
                                            shape: CircleBorder(),
                                            textColor: Colors.white,
                                            child: Icon(Icons.rate_review),
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
              }),

        ],
      ),
      floatingActionButton:  FloatingActionButton(
        child: Icon(Icons.add_shopping_cart),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => orderingPage()));
        },
      ),
    );

  }

  void openFilterDialog(){
    showDialog(

      context: context,
      child: AlertDialog(
      title: Text('Filter dialog'),
      content: Container(
        height: 200,
        child: Column(
          children: [
            RaisedButton(
              child: Text('all restaurants'),
                onPressed: (){
                isCityChanged=true;
                  Navigator.of(context, rootNavigator: true).pop();
              setState((){
                this._restaurants=fetchRest("", 1);
              });

            }),
           buildListOfCities(),
           buildListOfStars(),

          ],
        ),
      ),
      actions: [
        IconButton(icon: Icon(Icons.cancel), onPressed: (){
          Navigator.of(context, rootNavigator: true).pop();
        })
      ],
    ),);

  }
  Widget buildListOfStars(){
    return Container(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(rates.length,
                  (index) => GestureDetector(
                      child: Text('${rates[index]}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                      onTap:(){
                        setState(() {
                          _restaurants=fetchRest(index.toString(), 3);
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                      } ,),
                  //     Row(
                  //   children: List.generate(rates[index], (index) => ),
                  // )
          ),
        ),
      ),
    );
  }
  Widget buildListOfCities(){
    isCityChanged=false;
    return Container(
      height: 50,
      child: SingleChildScrollView(
        child: Column(
          children : List.generate(cities.length,
                  (index) => ListTile(
                    title: Text('${cities[index]}'),
                    onTap: (){
                      setState(() {
                        this._restaurants=fetchRest(cities[index], 2);
                      });
                      Navigator.of(context, rootNavigator: true).pop();
                    },

          ))
        ),
      ),
    );
  }
}