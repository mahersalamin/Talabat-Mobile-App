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
    http.Response response = await http.get('http://appback.ppu.edu/restaurants');
    List<Restaurant> _restaurants = [];

    if (response.statusCode == 200) {
      var jsonArray = jsonDecode(response.body) as List;
      _restaurants = jsonArray.map((x)=> Restaurant.fromJson(x)).toList();
      return _restaurants;
    }
    else{
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
      appBar: AppBar( title:Text('ResturantPage')),
      body: Column(
        children: [
          FutureBuilder(
          future: _restaurants,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      child: Row(
                        children: [
                          Card(
                            child: Column(
                              children: [
                                Image.network('http://appback.ppu.edu/static/${snapshot.data[index].restImage}'),
                                Text(snapshot.data[index].restName),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.blueGrey,
                                      size: 20.0,
                                    ),
                                    Text(snapshot.data[index].restCity),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            else if (snapshot.hasError) {
              return Text("error ${snapshot.error}");
            }
            return Center(
                child:CircularProgressIndicator()
            );
          }
      )
        ],
      ),
    );
  }
}