import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class Searched extends StatefulWidget {
  @override
  State<Searched> createState() => _SearchedState();
}

class _SearchedState extends State<Searched> {
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        leadingWidth: 20,
        toolbarHeight: 100,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: TextField(
              controller: name,
              onSubmitted: (s) {
                setState(() {});
              },
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: '...',
                  suffixIcon: Icon(Icons.close),
                  fillColor: Colors.white,
                  filled: true,
                  border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      )),
                  hintStyle: TextStyle(fontSize: 16, color: Colors.black)),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Czyje imieniny?',
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: name.text == ""
          ? null
          : SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              '${snapshot.error} occurred',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final data = snapshot.data;
                          return daysOfName(data!, 0);
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      );
                    },
                    future: extractName(name.text.toLowerCase(), 0),
                  ),
                  FutureBuilder(
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              '${snapshot.error} occurred',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final data = snapshot.data;

                          return daysOfName(data!, 1);
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    future: extractName(name.text.toLowerCase(), 1),
                  ),
                ],
              ),
            ),
    );
  }
}

Widget daysOfName(String days, int version) {
  String _daysWithSpaces = '';
  int number = 0;
  for (int i = 0; i < days.length; i++) {
    _daysWithSpaces += days[i];
    if (days[i] == ' ' && version == 0 || days[i] == '.' && version == 1) {
      number += 1;
      if (number == 2 && version == 0 || number == 1 && version == 1) {
        _daysWithSpaces += '\n';
        number = 0;
      }
    }
  }

  return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Text(
          _daysWithSpaces,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )),
      ));
}

Future<String> extractName(String imie, int version) async {
  String url = 'https://imienniczek.pl/imieniny-$imie';

  final response = await http.Client().get(Uri.parse(url));

  if (response.statusCode == 200) {
    var document = parser.parse(response.body);
    try {
      var responseString1 = document.getElementsByClassName('box')[version];
      print(responseString1);

      return responseString1.text.trim();
    } catch (e) {
      return 'ERROR1!';
    }
  } else {
    return 'Brak imienia w bazie';
  }
}
