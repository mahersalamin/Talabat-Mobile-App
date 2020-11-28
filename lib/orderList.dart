import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Menu.dart';
import 'OrderModel.dart';

class orderingPage extends StatefulWidget {
  @override
  _orderingPageState createState() => _orderingPageState();
}

class _orderingPageState extends State<orderingPage> {
  int totalPrice=0;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Order List"),
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Column(
                    children: [
                      Text('Total price to be paid is fixed now, so we are sorry :  9999'),
                      RaisedButton(
                        child: Text('Confirm orders'),
                        color: Colors.green[400],
                        onPressed: (){

                        },
                      )
                    ],
                  )
                ],
              ),
            ),
            Consumer<OrderModel>(
                builder: (context, todo  , child){
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: todo.list.length,
                    itemBuilder: (context , index){
                      return ListTile(
                        leading: Image.network(
                            'http://appback.ppu.edu/static/${todo.list[index].menuImage}',
                            width: MediaQuery.of(context).size.width/3, fit:BoxFit.cover),
                        title: Text(todo.list[index].menuName),
                        subtitle: Text(todo.list[index].menuPrice.toString()),
                        trailing: IconButton(
                            icon:Icon(Icons.delete_forever),
                            color: Colors.red,
                            onPressed: (){
                              Provider.of<OrderModel>(context, listen: false).remove(index);
                            }
                        ),
                      );
                    },
                  );
                }
            ),

          ],
        )
    );
  }

  // void Calculate(List<Menu> calcPriceList){
  //   calcPriceList.forEach(element){
  //     totalPrice+=element.menuPrice;
  //   }
  //
  // }
}