import 'package:flutter/material.dart';
import 'package:mytalabat_app/Menu.dart';

class OrderModel extends ChangeNotifier{
  final List <Menu> list=[];
  int _totalPrice=0;
  int get itemsNum => list.length;
  Menu getItem(int index) => list[index];
  bool itemExists (Menu menu) => list.indexOf(menu)>=0? true :false;
  void add(Menu menu){
    list.add(menu);
    this._totalPrice+=menu.menuPrice;
    notifyListeners();
  }
  int get totalPrice => _totalPrice;

  void remove (index){
    this._totalPrice-=list[index].menuPrice;
    list.removeAt(index);
    notifyListeners();
  }
  void removeEverything (){
    list.clear();
    _totalPrice=0;
    notifyListeners();
  }
}