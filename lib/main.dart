import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Uri dataApi = Uri.parse('https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/all.json');

class HeroList {
  final int id;
  final String name;
  final String photo;

  HeroList(
      this.id,
      this.name,
      this.photo
      );
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List <HeroList> allHeros = [];

  fetchData() async {
    var response = await http.get(dataApi);
    if(response.statusCode == 200)  {
      String responseBody = response.body;
      var jsonBody = jsonDecode(responseBody);
      for(var data in jsonBody) {
        allHeros.add(new HeroList(
            data['id'], data['name'], data['images']['lg']));
      }
      setState(() {
        allHeros.forEach((element) => print("Name : ${element.name} - ${element.photo}"));
      });
    }
  }

  @override
  void initState() {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch Superheros Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Superheros Data'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                ),
                itemCount: allHeros.length,
                itemBuilder: (context, i) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        //border: Border.all(color: Colors.black)
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 0.1,
                              sigmaY: 0.1,
                            ),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  elevation: 20,
                                  child: Image.network(allHeros[i].photo)
                              )
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                                child: Text(allHeros[i].name)
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
            ),
          ),
        ),
      ),
    );
  }
}

