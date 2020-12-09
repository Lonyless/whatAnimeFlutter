import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:api/conn.dart';

import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';

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

class Dados extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Animes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
            appBar: AppBar(
                title: Text("Dados sobre o Anime",
                    style: TextStyle(fontSize: 25))),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nome original do Anime: \n" +
                        listRecente['docs'][0]['anime'] +
                        "\n",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Nome em inglês: \n" +
                        listRecente['docs'][0]['title_english'] +
                        "\n",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Episodio: " +
                        listRecente['docs'][0]['episode'].toString() +
                        "\n",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "É adulto?: " +
                        listRecente['docs'][0]['is_adult'].toString(),
                    style: TextStyle(fontSize: 20),
                  )
                ])));
  }
}

var listRecente;

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

    listRecente = Map<String, dynamic>.from(response.data);

    Conn db = Conn();

    db.getCount().then((value) => {
          db.insertRecente(new Recente(value, listRecente['docs'][0]['anime'])),
          listar()
        });

    //db.deleteAll();

    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => Dados()));

    //print(listRecente['docs']);

    //print(listRecente['docs'][0]['anime']);
  }

  pickAnime(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(top: 30, bottom: 30),
          child: Text(
            "Escolha uma foto de anime e aperte em consultar! xD",
            //  textAlign: TextAlign.center,
            style: GoogleFonts.shadowsIntoLight(fontSize: 40),
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
          width: 390,
          margin: EdgeInsets.only(top: 30, bottom: 10),
          child: CupertinoButton(
            borderRadius: BorderRadius.circular(25),
            color: Colors.lightBlue[300],
            child: Text(
              "Selecionar Foto",
              style: TextStyle(fontSize: 30),
            ),
            onPressed: () => {_imgFromGallery()},
          ),
        ),
        Container(
          width: 390,
          margin: EdgeInsets.only(left: 10, right: 10),
          child: CupertinoButton(
            borderRadius: BorderRadius.circular(25),
            color: Colors.lightGreen[500],
            child: Text("Consultar", style: TextStyle(fontSize: 30)),
            onPressed: () => {sendFile(_image)},
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    listar();
  }

  Conn db = Conn();
  List<Recente> recente = List<Recente>();

  listar() {
    db.getRecentes().then((lista) {
      setState(() {
        recente = lista;
      });
    });
  }

  Widget build(BuildContext context) {
    Widget recentes = Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 30),
          child: Text(
            "Animes pesquisados recentemente",
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
        
        ListView.builder(
          padding: EdgeInsets.only(top: 100, left: 30, right: 30),
          itemCount: recente.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(right: 90),
                    child: Text(recente[index].nome,
                        style: TextStyle(fontSize: 20))),
                Divider(
                  thickness: 2.3,
                  color: Colors.grey[400],
                  height: 40,
                ),
              ],
            );
          },
        )
      ],
    );

    return Scaffold(
        appBar: AppBar(
            title: Text("Anime Finder ^-^", style: TextStyle(fontSize: 25))),
        body: PageView(
          children: [
            pickAnime(context),
            recentes,
          ],
        ));
  }
}
