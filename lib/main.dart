import 'package:flutter/material.dart';
import 'calendar.dart';
import 'searched.dart';

import 'package:provider/provider.dart';

void main() => runApp(MaterialApp(
    theme: ThemeData(
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            onPrimary: Colors.black,
            primary: Colors.pink,
            secondary: Colors.green[100]!,
            onSecondary: Colors.green[100]!,
            error: Colors.red,
            onError: Colors.red,
            background: Colors.green[100]!,
            onBackground:Colors.black,
            surface: Colors.green[100]!,
            onSurface: Colors.black),
        scaffoldBackgroundColor: Colors.green[100],
        primaryColor: Colors.pinkAccent,
        appBarTheme: const AppBarTheme(color: Colors.pinkAccent)),
    home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController searchController = TextEditingController();
  bool name = false;
  DateTime now = DateTime.now();
  DateTimeRange? _selectedDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 10));

  void _show() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(
          DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(
          DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
    //  currentDate: DateTime.now(),
      saveText: 'OK',
    );

    if (result != null) {
      setState(() {
        _selectedDateRange = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        title: Row(
          children: [
            MaterialButton(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Searched(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ));
                },
                child: const Icon(Icons.search, color: Colors.black)),
            const Center(
                child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Imieniny',style: TextStyle(color: Colors.white),),
            )),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size(double.maxFinite, 0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () => _show(),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(10),
                child: Text(
                  "${_selectedDateRange?.start.toString().split(' ')[0]} / ${_selectedDateRange?.end.toString().split(' ')[0]}",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Calendar(selectedDateRange: _selectedDateRange),
    );
  }
}
