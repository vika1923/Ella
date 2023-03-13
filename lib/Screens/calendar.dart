//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<Appointment> _appointments = <Appointment>[];
  bool problem = false;
  String answer = '';

  void _handleTapDate(DateTime date) {
    List<Appointment> appointments = _appointments;
    bool add = true;

    for (int i = 0; i < appointments.length; i++) {
      if (date == appointments[i].startTime) {
        add = false;
        break;
      }
    }
    if (add) {
      appointments.add(
          Appointment(startTime: date, endTime: date, color: Colors.purple));
    } else {
      appointments.remove(
          Appointment(startTime: date, endTime: date, color: Colors.purple));
    }
    setState(() {
      _appointments = appointments;
    });
  }

  void healthy(List<Appointment> appointments) {
    String reason = '?';
    bool norm = true;
    dynamic previousBreak = 28;
    int duration = 0;
    int allBreaks = 0;
    int number = 1;
    appointments.sort((a, b) => a.startTime.compareTo(b.startTime));
    DateTime previousDay = appointments[0].startTime;
    for (int i = 1; i < appointments.length; i++) {
      if (appointments[i].startTime !=
          previousDay.add(const Duration(days: 1))) {
        if (number > 1) {
          if (previousBreak -
                      (appointments[i]
                          .startTime
                          .difference(previousDay)
                          .inDays) >
                  7 ||
              previousBreak -
                      (appointments[i]
                          .startTime
                          .difference(previousDay)
                          .inDays) <
                  -7) {
            norm = false;
            reason = 'breaks are different';
          }
        }
        previousBreak =
            appointments[i].startTime.difference(previousDay).inDays;
        allBreaks += previousBreak as int;
        number++;
      } else {
        duration++;
      }
      previousDay = appointments[i].startTime;
    }
    int averageBreak = 28;
    int averageDuration = 4;
    if (number > 1) {
      averageBreak = (allBreaks / (number - 1)).round();
      averageDuration = (duration / number + 1).round();
      if (averageBreak > 40 || averageBreak < 21) {
        norm = false;
        reason = 'breaks last abnormally';
      }
      if (averageDuration > 5 || averageDuration < 2) {
        norm = false;
        reason = 'average duration is abnormal';
      }
    }
    var start = appointments[appointments.length - 1]
        .startTime
        .add(Duration(days: averageBreak));
    var end = appointments[appointments.length - 1]
        .startTime
        .add(Duration(days: (averageBreak + averageDuration)));
    setState(() {
      _appointments.add(Appointment(
          startTime: start,
          endTime: end,
          color: Color.fromARGB(132, 174, 0, 255)));
    });
    setState(() {
      problem = !norm;
      answer = reason;
    });
    print(
        'norm: $norm,  duration: $averageDuration,  break: $averageBreak, reason: $reason');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: () {
            healthy(_appointments);
            if (problem) {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return Center(
                          child: Card(
                        child: InkWell(
                          splashColor: Color.fromARGB(149, 223, 64, 251),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                              width: 200,
                              height: 100,
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                        'It looks your $answer. Consultation with our specialists is recommended.'),
                                  ))),
                        ),
                      ));
                    },
                  ));
            }
          },
          child: const Text('Check')),
      body: SafeArea(
        child: SfCalendar(
          view: CalendarView.month,
          firstDayOfWeek: 1,
          dataSource: _getCalendarDataSource(_appointments),
          todayHighlightColor: Colors.purpleAccent,
          monthCellBuilder:
              (BuildContext buildContext, MonthCellDetails details) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.purple[100],
                  border: Border.all(color: Colors.purpleAccent, width: 4)),
              child: Center(
                  child: Text(details.date.day.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))),
            );
          },
          onTap: (CalendarTapDetails details) {
            DateTime date = details.date!;
            _handleTapDate(date);
          },
        ),
      ),
    );
  }
}

_AppointmentDataSource _getCalendarDataSource(appointments) {
  return _AppointmentDataSource(appointments);
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
