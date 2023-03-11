//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<Appointment> _appointments = <Appointment>[];

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
      // перебираем все элементы списка, в котором лежат даты этих дней
      if (appointments[i].startTime !=
          previousDay.add(const Duration(days: 1))) {
        // это условие разделяет месячные одного месяца от другого
        if (number > 1) {
          // number - сколько раз(не дней) они были
          if (previousBreak - //  если в этот раз они пришли намного раньше/позже, чем в прошлый
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
    int averageBreak = (allBreaks / (number - 1))
        .round(); // средний перерыв = среднее  арифметическое между всеми перерывами
    int averageDuration =
        (duration / number + 1).round(); // средняя продолжительность
    if (averageBreak > 40 || averageBreak < 21) {
      // проверяем, если перерывы между месячными длятся правильное количество времени
      norm = false;
      reason = 'break lasts abnormally';
    }
    if (averageDuration > 5 || averageDuration < 2) {
      // проверяем, если сами месячные длятся правильное количество времени
      norm = false;
      reason = 'average duration is abnormal';
    }
    var start = appointments[appointments.length - 1]
        .startTime
        .add(Duration(days: averageBreak));
    var end = appointments[appointments.length - 1]
        .startTime
        .add(Duration(days: (averageBreak + averageDuration)));
    setState(() {
      // добавляем "предсказание"
      _appointments.add(Appointment(
          startTime: start,
          endTime: end,
          color: const Color.fromARGB(132, 174, 0, 255)));
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
