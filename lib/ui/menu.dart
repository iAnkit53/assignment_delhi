import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MenuUI extends StatefulWidget {
  @override
  _MenuUIState createState() => _MenuUIState();
}

class _MenuUIState extends State<MenuUI> {
  int selectedIndex = 0;
  double total = 8.00;
  int items = 1;
  double tax = 0.05;

  List<dynamic> categories = [];
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchMenuData();
  }

  Future<void> fetchMenuData() async {
    final response = await http.get(Uri.parse(
        'https://staging.app2food.com/v30/api/store/menu?store_id=11002'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        categories = data['data']['category'];
        products = data['data']['product'];
      });
      print('API Success 200 LBAnkit ');
    } else {
      throw Exception('Failed to load menu data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Menu',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            Container(
              width: 82.0,
              height: 20.0,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
                child: Text('Back'),
              ),
            ),
          ],
        ),
      ),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Row(
                children: [
                  SingleChildScrollView(
                    child:
      ConstrainedBox(
      // constraints: BoxConstraints(minHeight: constraint.maxHeight),
      constraints: BoxConstraints(minHeight: 500, minWidth: 132),
                      child: IntrinsicHeight(
                            child: NavigationRail(
                              selectedIndex: selectedIndex,
                              onDestinationSelected: (int index) {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              labelType: NavigationRailLabelType.none,
                              destinations: categories
                                  .map((category) =>
                                  NavigationRailDestination(
                                      // indicatorShape:
                                      icon: Container(
                                          height: 110,
                                          width: 140,
                                          child: Column(
                                            children: [
                                              SizedBox(height: 12,),
                                              Container(
                                                  height: 62,
                                                  width: 62,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: Image.asset('assets/1.png')),
                                              category['category_name'].toString().length < 14 ? Text(category['category_name'], style:  TextStyle(fontSize: 12, color: Colors.black),) :
                                              Text("${category['category_name'].toString().substring(0, 14)}.." ,style:  TextStyle(fontSize: 12, color: Colors.black), )
                                            ],
                                          )),
                                      selectedIcon: Container(
                                          height: 110,
                                          width: 140,
                                          decoration: BoxDecoration(
                                            color: Colors.white, // Set your desired background color
                                            borderRadius: BorderRadius.all(Radius.circular(6.0)), // Set corner radius
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.2), // Shadow color
                                                spreadRadius: 3.0, // Adjusts shadow spread
                                                blurRadius: 5.0, // Blurs the shadow
                                                offset: Offset(0, 3.0), // Moves shadow slightly downwards
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 12,),
                                              Container(
                                                height: 62,
                                                width: 62,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                                  border: Border.all(
                                                    color: Colors.green,
                                                    width: 3.0,
                                                  ),
                                                ),
                                                child: Image.asset('assets/1.png'),),
                                              category['category_name'].toString().length < 14 ? Center(child: Text(category['category_name'], style:  TextStyle(fontSize: 12, color: Colors.green[800]),)) :
                                              Text("${category['category_name'].toString().substring(0, 14)}.." ,style:  TextStyle(fontSize: 12, color: Colors.green[800]), )],
                                          )),
                                      label: Text(""),
                                      // label: category['category_name'].toString().length < 14 ? Text(category['category_name']) :
                                      // Text("${category['category_name'].toString().substring(0, 16)}\n${category['category_name'].toString().substring(16)}")
                                  )
                              )
                                  .toList(),
                            ),
                          ),
                    ),
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  // Expanded(
                  // Flexible(
                  //   child:
                    SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 800, maxWidth: 256),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          products
                              .where((product) =>
                          product['cid'] ==
                              categories[selectedIndex]['store_category_id'])
                              .map((product) => MenuItem(
                            title: product['product_name'],
                            price: product['product_price'],
                            onAdd: addItem,
                          ))
                              .toList()
                          ,
                        ),
                      ),
                    ),
                    ),
                  // ),
                ],
              ),

      bottomNavigationBar: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : BottomAppBar(
              height: 125,
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0, right: 6.0, left: 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Expanded(
                          flex: 50,
                          child: Text(
                            'MY ORDER',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          )),
                      Expanded(
                        flex: 33,
                        child: Container(
                          width: 60.0,
                          height: 22.0,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green[800],
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                            ),
                            child: Text('Edit'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 62,
                        child: Container(
                          width: 60.0,
                          height: 22.0,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green[800],
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                            ),
                            child: Text('View My Order'),
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(height: 6),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Text('Tax: \$${tax.toStringAsFixed(2)}')),
                          Expanded(flex: 1, child: Text('|')),
                          Expanded(
                              flex: 3,
                              child:
                                  Text('Total: \$${total.toStringAsFixed(2)}')),
                          Expanded(flex: 1, child: Text('|')),
                          Expanded(flex: 3, child: Text('Items: $items')),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                              ),
                              // style: ElevatedButton.styleFrom(primary: Colors.red),
                              child: Text('Cancel'),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                              ),
                              child: Text('Order Now'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void addItem(double price) {
    setState(() {
      items += 1;
      total += price;
      tax = total * 0.05;
    });
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  // final double price;
  final String price;
  final Function(double) onAdd;

  MenuItem({required this.title, required this.price, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600),),
      subtitle: Text(' \$ $price \nAngel Hair Pasta. Served With Vermont Goat Cheese.'),
      trailing: Container(
        height: 39,
        width: 39,
        color: Colors.grey[200],
        child: IconButton(
          icon: Icon(Icons.add),
          color: Colors.green,
          onPressed:(){} // => onAdd(price),
          // onPressed: () => onAdd(price),
        ),
      ),
    );
  }
}
