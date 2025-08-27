import 'package:flutter/material.dart';
import 'database.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyStorageApp());
}

class MyStorageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mina Utrymmen',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RoomListPage(),
    );
  }
}

class RoomListPage extends StatefulWidget {
  @override
  _RoomListPageState createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  List<Map<String, dynamic>> rooms = [];

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.query('rooms');
    setState(() {
      rooms = data;
    });
  }

  Future<void> addRoom(String name) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('rooms', {'name': name});
    fetchRooms();
  }

  void showAddRoomDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Nytt rum"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: "Rumsnamn"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Avbryt")),
          ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  addRoom(controller.text);
                  Navigator.pop(context);
                }
              },
              child: Text("Spara"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mina Utrymmen")),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.search),
            title: Text("Sök i alla rum"),
            onTap: () {
              // TODO: Lägg till global söksida
            },
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                return ListTile(
                  title: Text(room['name']),
                  onTap: () {
                    // TODO: Öppna rumsvy
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddRoomDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
