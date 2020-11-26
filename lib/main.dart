import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  String results = "";

  Future<String> getJSONData() async {
    var response = await http
        .get(Uri.encodeFull("https://cat-fact.herokuapp.com/facts/random"));
    setState(() {
      // otem os dados JSON
      results = json.decode(response.body)['text'];
    });
    return "Dados obtidos com sucesso";
  }

  /*
  getCatFact() {
    API.getRandomFact().then((value) {
      setState(() {
        var all = json.decode(value.body);
        results = all['text'];
      });
    });
  }*/

  _BuildListViewState() {
    getJSONData();
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
