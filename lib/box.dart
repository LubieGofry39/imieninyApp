import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imieniny/translation.dart';
import 'notifications.dart';
import 'saving.dart';

// ignore: must_be_immutable
class Box extends StatefulWidget {
  String names;
  String holidays;
  DateTime day;
  DateTime now;
  bool ifChecked;
  Box(this.names, this.holidays, this.day, this.now, this.ifChecked, {super.key});

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  
 

  late final NotificationService service;

  @override
  initState() {
    service = NotificationService();
    service.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String currentDayOfWeek = Transation().dzienTyg(widget.day.weekday - 1);

    if (widget.day.weekday == widget.now.weekday &&
        widget.day.day == widget.now.day) {
      currentDayOfWeek = "dziś";
    }

    return GestureDetector(
      onLongPress: () async {
        String msg;
        if (widget.day.day + 1 != widget.now.day &&
            widget.day.day != widget.now.day) {
          setState(() {
            widget.ifChecked = ! widget.ifChecked;
          });
          if ( widget.ifChecked) {
            msg =
                "Masz zaplanowane przypomienie na ${widget.day.day} ${Transation().miesiac(widget.day.month)}";
            var id = widget.day.month * 100 + widget.day.day;
            SQLHelper.createItem(widget.day.day,widget.day.month);
          //  print(SQLHelper.getItems());
            NotificationService()
            .scheduleNotifications(id, widget.names, widget.now);

          } else {
            msg = "Wycofanie przypomnienia";
            var id = widget.day.month * 100 + widget.day.day;
            SQLHelper.deleteItem(id);
            NotificationService().cancelNotifications(id);
          }
        } else if (widget.day.day + 1 == widget.now.day) {
          msg = "Nie można cofnąć czasu";
        } else {
          msg = "To już dziś";
        }
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      },
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: widget.day.day == widget.now.day
                      ? const LinearGradient(
                          colors: [
                            Colors.yellow,
                            Colors.pink,
                          ],
                        )
                      : null,
                  border: Border.all(
                      color:  widget.ifChecked ? Colors.red : Colors.black,
                      width:  widget.ifChecked ? 3 : 1),
                  borderRadius: BorderRadius.circular(20),
                  color:  widget.ifChecked ? Colors.amberAccent : null),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                  widget.names,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                
                const Divider(color: Colors.purple,thickness: 3)
                ,Text(
                  widget.holidays,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                  ],
                ),
              )),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              height: 30,
              width: 25 +
                  (currentDayOfWeek.length + widget.day.day.toString().length) *
                      9,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(50)),
              child: Text("${widget.day.day} $currentDayOfWeek")),
        )
      ]),
    );
  }
}
