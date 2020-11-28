import 'package:flutter/material.dart';
import 'package:mytalabat_app/Menu.dart';

class FavPage extends StatefulWidget {
  final List<Menu> favMenu;

  FavPage(this.favMenu);

  @override
  _FavPageState createState() => _FavPageState(favMenu);
}

class _FavPageState extends State<FavPage> {
  List<Menu> _favMenu;

  _FavPageState(this._favMenu);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite List"),
      ),
      body: ListView.builder(
        itemCount: _favMenu.length,
        itemBuilder: (context , index){
          return ListTile(
            leading: Image.network(
                'http://appback.ppu.edu/static/${_favMenu[index].menuImage}',
                width: MediaQuery.of(context).size.width/3, fit:BoxFit.cover),
            title: Text(_favMenu[index].menuName),
            subtitle: Text(_favMenu[index].menuPrice.toString()),
            trailing: IconButton(
              icon:Icon(Icons.delete_forever),
              color: Colors.red,
              onPressed: (){
                _favMenu.removeAt(index);
                setState(() {

                });
              },
            ),
          );
        },
      ),
    );
  }
}
