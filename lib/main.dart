import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'model.dart';

import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animes',
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
  File _image;

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  sendFile(File file) async {
    final bytes = _image.readAsBytesSync();

    String img64 = base64Encode(bytes);

    Dio dio = new Dio();
    var url = 'https://trace.moe/api/search';
    var len = await file.length();
    var response = await dio.post(url,
        data: '{ "image" : "' + img64 + '" }',
        options: Options(
            method: 'POST',
            headers: {
              Headers.contentLengthHeader: len,
            },
            contentType: 'application/json',
            responseType: ResponseType.json // or ResponseType.JSON
            ));

    var result = Map<String, dynamic>.from(response.data);

    print(result['docs']);

    print(result['docs'][0]['anime']);
  }

  pickAnime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(top: 50, bottom: 10),
          child: Text(
            "Escolha uma foto de anime!",
            //  textAlign: TextAlign.center,
            style: TextStyle(fontSize: 33),
          ),
        ),
        Container(
          margin: EdgeInsets.all(20),
          child: RaisedButton(
            color: Colors.lightBlue[300],
            child: Text(
              "Selecionar Foto",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () => {_imgFromGallery()},
          ),
        ),
        Container(
            color: Colors.grey[350],
            constraints: BoxConstraints(minWidth: 500, minHeight: 300),
            child: Container(
              //margin: EdgeInsets.all(50),
              constraints: BoxConstraints(minWidth: 300, maxHeight: 200),
              child: _image != null
                  ? Image.file(
                      _image,
                    )
                  : null,
            )),
        Container(
          margin: EdgeInsets.all(30),
          child: RaisedButton(
            color: Colors.lightGreen[500],
            child: Text("Enviar", style: TextStyle(fontSize: 30)),
            onPressed: () => {sendFile(_image)},
          ),
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Anime Finder ^-^", style: TextStyle(fontSize: 25))),
        body: pickAnime());
  }
}
