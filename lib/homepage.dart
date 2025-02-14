import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: HomePage()));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Define lists to hold names and item details
  List<Map<String, dynamic>> people = [
    {'name': 'ALWENSY', 'quantity': 2},
    {'name': 'AUREL', 'quantity': 3},
    {'name': 'HABIBAH', 'quantity': 1},
  ];

  List<Map<String, dynamic>> items = [
    {'number': '1', 'name': 'PALU', 'quantity': 5},
    {'number': '2', 'name': 'PAKU', 'quantity': 8},
    {'number': '3', 'name': 'KURSI', 'quantity': 3},
  ];

  // Function to add a product to the shopping list
  void _addItem(String itemName, int quantity) {
    setState(() {
      items.add({
        'number': (items.length + 1).toString(),
        'name': itemName,
        'quantity': quantity
      });
      // Update corresponding person quantity if necessary (syncing)
      people.forEach((person) {
        if (person['name'] == itemName) {
          person['quantity'] += quantity;
        }
      });
    });
  }

  // Function to remove a product from the shopping list
  void _removeItem(String itemName) {
    setState(() {
      items.removeWhere((item) => item['name'] == itemName);
      // Update corresponding person quantity when an item is removed
      people.forEach((person) {
        if (person['name'] == itemName) {
          person['quantity'] = 0;
        }
      });
    });
  }

  // Function to increase the quantity of a product
  void _increaseQuantity(String itemName) {
    setState(() {
      for (var item in items) {
        if (item['name'] == itemName) {
          item['quantity']++;
        }
      }
      // Syncing the person quantity with the updated item quantity
      people.forEach((person) {
        if (person['name'] == itemName) {
          person['quantity']++;
        }
      });
    });
  }

  // Function to decrease the quantity of a product
  void _decreaseQuantity(String itemName) {
    setState(() {
      for (var item in items) {
        if (item['name'] == itemName && item['quantity'] > 0) {
          item['quantity']--;
        }
      }
      // Syncing the person quantity with the updated item quantity
      people.forEach((person) {
        if (person['name'] == itemName && person['quantity'] > 0) {
          person['quantity']--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              // Tab 1 with person icon
              Tab(
                icon: Icon(
                  Icons.person,
                  size: 24,
                  color: Colors.black,
                ),
              ),
              // Tab 2 with shopping cart icon
              Tab(
                icon: Icon(
                  Icons.shopping_cart,
                  size: 24,
                  color: Colors.black,
                ),
              ),
              // Tab 3 with shopping bag icon
              Tab(
                icon: Icon(
                  Icons.shopping_bag,
                  size: 24,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Content of Tab 1 (Person Icon)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: people
                    .map((person) => _buildPersonItem(
                        person['name'], person['quantity'], context))
                    .toList(),
              ),
            ),
            // Content of Tab 2 (Shopping Cart Icon)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: items
                    .map((item) => _buildItem(item['number'], item['name'],
                        item['quantity'], context))
                    .toList(),
              ),
            ),
            // Content of Tab 3 (Shopping Bag Icon)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PENGELUARAN BELANJA',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ...items.map((item) => _buildItem(
                      item['number'], item['name'], item['quantity'], context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonItem(String name, int quantity, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Text(
            name, // Person name
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Roboto', // Custom font
            ),
          ),
          Spacer(),
          Text(
            'Jumlah Pembelian: $quantity',
            style: TextStyle(
              fontSize: 18,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
      String number, String itemName, int quantity, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Text(
            number, // Number before item name
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              itemName, // Item name
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            'Qty: $quantity',
            style: TextStyle(
              fontSize: 18,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle, color: Colors.orange),
            onPressed: () => _decreaseQuantity(itemName),
          ),
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.green),
            onPressed: () => _increaseQuantity(itemName),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _removeItem(itemName); // Remove item when clicked
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$itemName removed')),
              );
            },
          ),
        ],
      ),
    );
  }
}
