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
      title: 'Everyday a fact',
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
  String results;

  getCatFact() {
    API.getRandomFact().then((value) {
      setState(() {
        var all = json.decode(value.body);
        results = all['text'];
      });
    });
  }

  _BuildListViewState() {
    getCatFact();
  }

  listaCatFact() {
    return Text(results);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cat Facts")),
      body: listaCatFact(),
    );
  }
}
