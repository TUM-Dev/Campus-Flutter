import 'package:campus_flutter/calendarComponent/model/calendarDataSource.dart';
import 'package:campus_flutter/providers_get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'calendarsView.dart';

class CalendarMonthView extends ConsumerWidget {
  const CalendarMonthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref.watch(calendarViewModel).events,
        builder: (context, snapshot) {
          return Expanded(child: SfCalendar(
            view: CalendarView.month,
            monthViewSettings: const MonthViewSettings(
                showAgenda: true,
                navigationDirection: MonthNavigationDirection.vertical),
            dataSource: snapshot.hasData
                ? MeetingDataSource(snapshot.data!, context)
                : null,
            firstDayOfWeek: 1,
            showDatePickerButton: true,
            showNavigationArrow: true,
            onTap: (details) {
              showModalSheet(details, null, context, ref);
            },
          ));
        });
  }
}