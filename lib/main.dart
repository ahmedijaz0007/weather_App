import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reorderable List with Deletion',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DragDropListScreen(),
    );
  }
}

class DragDropListScreen extends StatefulWidget {
  @override
  _DragDropListScreenState createState() => _DragDropListScreenState();
}

class _DragDropListScreenState extends State<DragDropListScreen> {
  List<String> items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"];

  void deleteItem(String item) {
    setState(() {
      items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reorderable List with Deletion")),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = items.removeAt(oldIndex);
                  items.insert(newIndex, item);
                });
              },
              children: List.generate(items.length, (index) {
                return Dismissible(
                  key: Key(items[index]),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // Delete item on swipe
                    deleteItem(items[index]);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${items[index]} deleted")));
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    title: Text(items[index]),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
