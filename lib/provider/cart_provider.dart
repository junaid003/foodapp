import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  num cartTotalAmt = 0;
  Map cartData = {};

  Map get items {
    return cartData;
  }

  num get totalAmt {
    return cartTotalAmt;
  }

  void addTOcart(data) {
    var dishid = data['dish_id'];
    if (cartData.containsKey(dishid)) {
      cartData[dishid]['qty'] = cartData[dishid]['qty'] + 1;
    } else {
      cartData[dishid] = {
        'dish_id': dishid,
        'qty': 1,
        'price': data['dish_price'],
        'name': data['dish_name'],
        'dish_calories': data['dish_calories'],
        'dish_Type': data['dish_Type'],
      };
    }

    cartTotalPrice();
    refresh();
  }

  changeCartItemQty(dish_id) {
    if (cartData[dish_id]['qty'] == 1) {
      cartData.remove(dish_id);
    } else {
      cartData[dish_id]['qty'] = cartData[dish_id]['qty'] - 1;
    }
    cartTotalPrice();
    refresh();
  }

  cartTotalPrice() async {
    cartTotalAmt = 0;
    cartData.forEach((key, value) {
      cartTotalAmt = cartTotalAmt + value['qty'] * value['price'];
    });
    refresh();
  }

  void refresh() {
    notifyListeners();
  }

  void emptyCart() {
    cartData = {};
    refresh();
  }
}
