import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'RestaurantMenu.dart';

class testwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Favorite List"),
      ),
      body: Column(
        children: [
          Consumer<xxx>(
              builder: (context, todo  , child){
                return ListView.builder(
                  itemCount: todo.favorit.length,
                  itemBuilder: (context , index){
                    return ListTile(
                      leading: Image.network(
                          'http://appback.ppu.edu/static/${todo.favorit[index].menuImage}',
                          width: MediaQuery.of(context).size.width/3, fit:BoxFit.cover),
                      title: Text(todo.favorit[index].menuName),
                      subtitle: Text(todo.favorit[index].menuPrice.toString()),
                      trailing: IconButton(
                        icon:Icon(Icons.delete_forever),
                        color: Colors.red,
                        onPressed: (){
                          Provider.of<xxx>(context).removeFromFavList(index);
                          }
                          ),
                        );
                  },
                );
              }
          )
        ],
      )
    );
  }
}
