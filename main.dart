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
  var img = new Image.network(
      'https://media.tenor.com/images/47f855960d5dc83774d7b3b428964c93/tenor.gif');

  getCatFact() {
    API.getRandomFact().then((value) {
      setState(() {
        var all = json.decode(value.body);
        results = all['text'];
      });
    });
  }

  getCatImage() {
    API.getRandomPicture().then((value) {
      setState(() {
        var all = json.decode(value.body);
        img = new Image.network(all[0]['url']);
      });
    });
  }

  /*
  Future<String> getJSONData() async {
    var response = await http
        .get(Uri.encodeFull("https://cat-fact.herokuapp.com/facts/random"));
    setState(() {
      // otem os dados JSON
      results = json.decode(response.body)['text'];
    });
    return "Dados obtidos com sucesso";
  }
  */

  _BuildListViewState() {
    getCatFact();
    getCatImage();
  }

  listaCat() {
    return Column(
      children: [
        Text(results),
        FlatButton(
          child: Text("press me for a cat fact"),
          onPressed: () => {getCatFact()},
        ),
        Container(
          height: 300,
          width: 300,
          child: img,
        ),
        FlatButton(
          child: Text("press me for a cat pic"),
          onPressed: () => {getCatImage()},
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cat Facts")),
      body: listaCat(),
    );
  }
}
