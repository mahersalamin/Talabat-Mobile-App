import 'package:flutter/material.dart';
import 'package:mytalabat_app/Menu.dart';

class OrderModel extends ChangeNotifier{
  final List <Menu> list=[];
  int get itemsNum => list.length;
  Menu getItem(int index) => list[index];
  bool itemExists (Menu menu) => list.indexOf(menu)>=0? true :false;
  void add(Menu menu){
    list.add(menu);
    notifyListeners();
  }
  void remove (Menu menu){
    list.remove(menu);
    notifyListeners();
  }
  void removeEverything (Menu menu){
    list.clear();
    notifyListeners();
  }
}