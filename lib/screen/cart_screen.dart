import 'package:flutter/material.dart';
import 'package:foodapp/provider/cart_provider.dart';
import 'package:foodapp/screen/home_screen.dart';
import 'package:foodapp/utils/popupmessages.dart';
import 'package:provider/provider.dart';

class Cartscreen extends StatefulWidget {
  Cartscreen({Key? key}) : super(key: key);
  static String routeName = '/cart_screen';

  @override
  State<Cartscreen> createState() => _CartscreenState();
}

class _CartscreenState extends State<Cartscreen> {
  Widget _buildplaceOrdeBtn(CartProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 18, right: 18, top: 5),
      child: InkWell(
        onTap: () {
          PopUpmesaage.alert(context, "Success", "Order Successfully placed ",
              () {
            cartProvider.emptyCart();
            Navigator.of(context).pushNamedAndRemoveUntil(
                HomeScreen.routeName, (Route<dynamic> route) => false);
          });
        },
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green.shade900,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: const Center(
            child: Text(
              "Place Order",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildccartData(cartProviderData, CartProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemCount: cartProviderData.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          String key = cartProviderData.keys.elementAt(index);
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: cartProviderData[key]['dish_Type'] == 2
                                  ? Colors.green
                                  : Colors.red)),
                      child: Icon(Icons.circle,
                          color: cartProviderData[key]['dish_Type'] == 2
                              ? Colors.green
                              : Colors.red,
                          size: 10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 2, left: 2),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 244,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartProviderData[key]['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 8),
                            child: Text(
                              'INR ' +
                                  cartProviderData[key]['price'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.black),
                            ),
                          ),
                          Text(
                            cartProviderData[key]['dish_calories'].toString() +
                                ' calories',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.green.shade900,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              cartProvider.changeCartItemQty(key);
                            },
                            child: const Icon(
                              Icons.remove,
                              size: 26.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            cartProviderData[key]['qty'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              var id = {'dish_id': key};
                              cartProvider.addTOcart(id);
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                    ),
                    child: SizedBox(
                      width: 75,
                      child: Text(
                        'INR ' +
                            (cartProviderData[key]['price'] *
                                    cartProviderData[key]['qty'].toDouble())
                                .toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 8),
                child: Divider(
                  color: Colors.grey,
                  endIndent: 10,
                  indent: 10,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _nocartdata() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Image.asset("assets/images/noData.png")),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'You have no items in your cart',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Order Summary',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
      ),
      body: cartProvider.items.length == 0
          ? _nocartdata()
          : Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height - 136,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 18, right: 18, top: 15, bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 3,
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  color: Colors.green.shade900,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      cartProvider.items.length.toString() +
                                          ' Dishes - ' +
                                          cartProvider.items.length.toString() +
                                          ' Items',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              _buildccartData(cartProvider.items, cartProvider),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Amount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'INR ' +
                                          cartProvider.cartTotalAmt
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.lightGreen.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                _buildplaceOrdeBtn(cartProvider),
              ],
            ),
    );
  }
}
