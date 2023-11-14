import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:imieniny/box.dart';
import 'translation.dart';
import 'saving.dart';

class Calendar extends StatefulWidget {

  final DateTimeRange? selectedDateRange;

   Calendar({super.key, @required this.selectedDateRange});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  bool isLoading = false;

  List<Map<String, dynamic>> _daysOfNamesSaved = [];

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _daysOfNamesSaved = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? now = widget.selectedDateRange?.start;

    return RefreshIndicator(
      backgroundColor: Colors.black,
      onRefresh: () async {
        _refreshJournals();
      },
      child: ListView.builder(
          addAutomaticKeepAlives: false,
          itemCount: (widget.selectedDateRange?.duration.inDays)!+1,
          itemBuilder: (ctx, index) {
            DateTime day = DateTime(now!.year, now!.month, now!.day  + index);
            int id = day.month * 100 + day.day;
            bool ifChecked = false;
            for (int i = 0; i < _daysOfNamesSaved.length; i++) {
              if (_daysOfNamesSaved[i].containsValue(id)) {
                ifChecked = true;
                break;
              }
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                    builder: (ctx, snapshot) {
                      // Checking if future is resolved or not
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'Brak Internetu ty stopo lubcze',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                  
                          // if we got our data
                        } else if (snapshot.hasData) {
                          final data = snapshot.data;
                          return Box(data![0],data[1], day, DateTime.now(), ifChecked);
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      );
                    },
                    future: extractNames(day),
                  ),
                  //
                ],
              )),
            );
          }),
    );
  }
}

Future<List<String>> extractNames(DateTime now) async {
  
  String url =
      'https://www.kalbi.pl/${now.day}-${Transation().miesiac(now.month - 1)}';

  final response = await http.Client().get(Uri.parse(url));

  if (response.statusCode == 200) {
    var document = parser.parse(response.body);
    try {
      var responseString1 =
          document.getElementsByClassName('calCard-name-day')[0];

      
      String names="";
      int i=1;
      while(!responseString1.children[i].text.contains("oraz")){
      
        names+="${responseString1.children[i].text}   ";
        i++;
      }
      var responseString2 =document.getElementsByClassName('calCard-ententa')[0];
      String holidays='';
      
      try {
        for(int j=1;j<10;j++){
        holidays+="${responseString2.children[j].text}\n";
        }
      }catch(e){}
     
      return [names.trim(),holidays.trim()]; 
    } catch (e) {
      print(e);
      return ['ERROR1!','ERROR1!'];
    }
  } else {
    return ['ERROR: ${response.statusCode}.','ERROR: ${response.statusCode}.'];
  }
}

