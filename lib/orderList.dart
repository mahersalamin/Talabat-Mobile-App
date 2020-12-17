import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'OrderModel.dart';

class orderingPage extends StatefulWidget {
  @override
  _orderingPageState createState() => _orderingPageState();
}

class _orderingPageState extends State<orderingPage> {

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
                  Center(
                    child: Consumer<OrderModel>(
                      builder:(context,todo,child){
                       return Column(
                       children: [
                         Text('Total price to be paid is  :  ${todo.totalPrice}'),
                         RaisedButton(
                           child: Text('Confirm orders'),
                           color: Colors.green[400],
                           onPressed: (){
                             if(todo.totalPrice>0){
                                  confirmDialog();
                                }
                             else
                              Toast.show("No orders", context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM );
                           },
                         )
                       ],
                       );
                      }
                    ),
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

  void confirmDialog() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Confirm orders '),

        content: Consumer<OrderModel>(
            builder:(context,todo,child)=>
                Text('Total price of orders:\n ${todo.totalPrice}')
        ),

        actions: [
          Consumer <OrderModel>(
            builder: (context,todo,child) =>
            MaterialButton(
              color: Colors.green,
              child: Icon(Icons.done_outline),
              textColor: Colors.white,
              shape: CircleBorder(),
              padding: EdgeInsets.all(16),

              onPressed: (){
                todo.removeEverything();
                Toast.show(
                    "Order confirmed, Have a nice day",
                    context,
                    duration: Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM
                );
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),

          ),

          MaterialButton(
            color: Colors.red[400],
            child: Icon(Icons.exit_to_app),
            textColor: Colors.white,
            shape: CircleBorder(),
            padding: EdgeInsets.all(16),

            onPressed: (){
              Toast.show(
                  "Order still saved, continue shopping",
                  context,
                  duration: Toast.LENGTH_SHORT,
                  gravity: Toast.BOTTOM
              );
              //Navigator.of(context, rootNavigator: true).pop();
              Navigator.pop(context);

            },
          ),
        ],

      ),
    );

  }
}