import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: UserTable(),
  ));
}

class UserTable extends StatelessWidget {
  // Sample list of users
  final List<Map<String, dynamic>> users = [
    {'name': 'John Doe', 'email': 'john@example.com', 'age': 30},
    {'name': 'Jane Smith', 'email': 'jane@example.com', 'age': 25},
    {'name': 'Alice Johnson', 'email': 'alice@example.com', 'age': 28},
    {'name': 'Bob Brown', 'email': 'bob@example.com', 'age': 35},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Table'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Age')),
            ],
            rows: users.map((user) {
              return DataRow(cells: [
                DataCell(Text(user['name'])),
                DataCell(Text(user['email'])),
                DataCell(Text(user['age'].toString())),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
