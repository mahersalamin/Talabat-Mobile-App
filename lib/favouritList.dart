import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FavouriteModel.dart';

class FavPage extends StatefulWidget {

  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Favorite List"),
        ),
        body: Consumer<FavModel>(
            builder: (context, todo  , child){
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: todo.list.length,
                itemBuilder: (context , index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.brown[400],
                      height: 80,
                      child: ListTile(
                        leading: Image.network(
                            'http://appback.ppu.edu/static/${todo.list[index].menuImage}',
                            width: MediaQuery.of(context).size.width/3, fit:BoxFit.cover),
                        title: Text(todo.list[index].menuName),
                        subtitle: Text(todo.list[index].menuPrice.toString()),
                        trailing: IconButton(
                            icon:Icon(Icons.delete_forever),
                            color: Colors.white,
                            onPressed: (){
                              Provider.of<FavModel>(context, listen: false).remove(index);
                            }
                        ),
                      ),
                    ),
                  );
                },
              );
            }
        )
    );
  }
}