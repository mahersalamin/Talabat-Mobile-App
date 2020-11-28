import 'package:flutter/material.dart';
import 'package:mytalabat_app/Menu.dart';

class FavModel extends ChangeNotifier{
  final List <Menu> list=[];
  int get itemsNum => list.length;
  Menu getItem(int index) => list[index];
  bool itemExists (Menu menu) => list.indexOf(menu)>=0? true :false;
  void add(Menu menu){
    list.add(menu);
    notifyListeners();
  }
  void remove (index){
    list.removeAt(index);
    notifyListeners();
  }
  void removeEverything (Menu menu){
    list.clear();
    notifyListeners();
  }
}