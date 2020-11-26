import 'dart:convert';

import 'package:flutter/material.dart';

import 'api.dart';
import 'model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temos que Pegar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BuildListView(),
    );
  }
}

class BuildListView extends StatefulWidget {
  @override
  _BuildListViewState createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
  var results = new List<Welcome>();

  getCatFact() {
    API.getFacts().then((value) {
      setState(() {
        Map<String, dynamic> map = json.decode(value.body);
        Iterable list = map["results"];

        results = list.map((results) => Welcome.fromJson(results)).toList();
      });
    });
  }

  _BuildListViewState() {
    getCatFact();
  }

  listaCatFact() {
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              results[index].text,
              style: TextStyle(fontSize: 25),
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cat Facts")),
      body: listaCatFact(),
    );
  }
}
