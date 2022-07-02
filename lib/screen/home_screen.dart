import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodapp/provider/cart_provider.dart';
import 'package:foodapp/screen/cart_screen.dart';
import 'package:foodapp/screen/login_type_screen.dart';
import 'package:foodapp/utils/globals.dart';
import 'package:provider/provider.dart';

import 'phone_sigin_sncreen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home_screen';

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  _buildmenuContainer(SinglecategorieDishes, CartProvider cartProvider) {
    return ListView.builder(
      itemCount: SinglecategorieDishes.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  SinglecategorieDishes[index]['dish_Type'] == 2
                                      ? Colors.green
                                      : Colors.red)),
                      child: Icon(Icons.circle,
                          color: SinglecategorieDishes[index]['dish_Type'] == 2
                              ? Colors.green
                              : Colors.red,
                          size: 10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Container(
                        width: MediaQuery.of(context).size.width - 125,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 125,
                                  child: Text(
                                    SinglecategorieDishes[index]['dish_name'],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'INR ' +
                                        SinglecategorieDishes[index]
                                                ['dish_price']
                                            .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    SinglecategorieDishes[index]
                                                ['dish_calories']
                                            .toString() +
                                        ' calories',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              SinglecategorieDishes[index]['dish_description'],
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Container(
                                width: 140,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.lightGreen.shade600,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (cartProvider.items.containsKey(
                                              SinglecategorieDishes[index]
                                                  ['dish_id'])) {
                                            cartProvider.changeCartItemQty(
                                                SinglecategorieDishes[index]
                                                    ['dish_id']);
                                          }
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
                                        cartProvider.items.containsKey(
                                                SinglecategorieDishes[index]
                                                    ['dish_id'])
                                            ? cartProvider.items[
                                                    SinglecategorieDishes[index]
                                                        ['dish_id']]['qty']
                                                .toString()
                                            : '0',
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
                                          cartProvider.addTOcart(
                                              SinglecategorieDishes[index]);
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
                            ),
                            SinglecategorieDishes[index]['addonCat'].length == 0
                                ? Container(
                                    width: 0,
                                    height: 0,
                                  )
                                : const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text('Customization Available',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Colors.red)),
                                  ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Image.network(
                        SinglecategorieDishes[index]['dish_image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
            )
          ],
        );
      },
    );
  }

  Widget _buildDrawer(CartProvider cartProvider) {
    return Drawer(
        child: Column(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[Colors.green, Colors.lightGreen],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.blue[200],
                    child: Image.network(
                      'https://www.ateneo.edu/sites/default/files/styles/large/public/2021-11/istockphoto-517998264-612x612.jpeg?itok=aMC1MRHJ',
                      fit: BoxFit.fill,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  Globals.username,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ),
              Text(
                'ID : ' + Globals.userId,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut().then((r) {
                Globals.username = '';
                Globals.userId = '';
                Globals.categories = [];
                Globals.categorieDishes = [];
                cartProvider.emptyCart();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    sigintypescreen.routeName, (Route<dynamic> route) => false);
              });
            },
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 30, left: 10),
                  child: Icon(
                    Icons.logout,
                    color: Colors.grey,
                    size: 35.0,
                  ),
                ),
                Text(
                  'Log out',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  Cartscreen.routeName,
                );
              },
              child: SizedBox(
                width: 50,
                height: 30,
                child: Stack(
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      color: Colors.grey,
                      size: 35.0,
                    ),
                    Positioned(
                        right: 10,
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(cartProvider.items.length.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.white)),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(cartProvider),
      body: DefaultTabController(
        length: Globals.categories.length,
        initialIndex: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TabBar(
              labelColor: Colors.red,
              isScrollable: true,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.red,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.15,
              ),
              labelPadding: EdgeInsets.zero,
              tabs:
                  List<Widget>.generate(Globals.categories.length, (int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Tab(text: Globals.categories[index].toString()),
                );
              }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SizedBox(
                    width: double.infinity,
                    child: TabBarView(
                      children: List<Widget>.generate(Globals.categories.length,
                          (int index) {
                        return _buildmenuContainer(
                            Globals.categorieDishes[index], cartProvider);
                      }),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
