library event_calendar;

// import 'choice.dart' as choices;
import 'dart:math';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:intl/intl.dart';
import 'package:smart_select/smart_select.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

part 'color-picker.dart';

part 'timezone-picker.dart';

part 'appointment-editor.dart';

void main() => runApp(const MaterialApp(
      home: EventCalendar(),
      debugShowCheckedModeBanner: false,
    ));

//ignore: must_be_immutable
class EventCalendar extends StatefulWidget {
  const EventCalendar({Key key}) : super(key: key);

  @override
  EventCalendarState createState() => EventCalendarState();
}

List<Color> _colorCollection = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.black,
  Colors.yellow,
  Colors.pink
];
List<String> _colorNames = ['Red', 'Blue', 'Green', 'Black', 'Yellow', 'Pink'];
int _selectedColorIndex = 0;
int _selectedTimeZoneIndex = 0;
List<String> _timeZoneCollection = ['Arab Standard Time'];
DataSource _events;
Meeting _selectedAppointment;
DateTime _startDate;
TimeOfDay _startTime;
DateTime _endDate;
TimeOfDay _endTime;
bool _isAllDay;
String _subject = '';
String _notes = '';
String _test11 = '';
List<Object> _resourceIds;
List<S2Choice<String>> allemolyees = [];
List<String> _prov = [];

class EventCalendarState extends State<EventCalendar> {
  EventCalendarState();

  CalendarView _calendarView;
  CalendarController _calendarController;
  List<String> eventNameCollection;
  // List<Meeting> appointments;
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineWorkWeek,
    CalendarView.timelineMonth
  ];
  List<Meeting> appointments = [
    Meeting(
        from: DateTime.now(),
        to: DateTime.now().add(Duration(hours: 1)),
        background: Colors.teal,
        description: 'Test',
        resourceIds: <String>['0001', '0002', '0003', '0004'])
  ];

  List<CalendarResource> _employeeCollection = [
    CalendarResource(id: '0001', displayName: 'Ahmed', color: Colors.red),
    CalendarResource(id: '0002', displayName: 'Ali', color: Colors.teal),
    CalendarResource(id: '0003', displayName: 'Omar', color: Colors.blue),
    CalendarResource(id: '0004', displayName: 'Sami', color: Colors.yellow)
  ];
  double cellWidth = -2;
  @override
  void initState() {
    // _calendarView = CalendarView.timelineWeek;
    _calendarController = CalendarController();
    _calendarController.view = CalendarView.timelineWeek;
    //  appointments = getMeetingDetails();
    _events = DataSource(appointments, _employeeCollection);
    allemolyees = [
      S2Choice<String>(value: '0001', title: 'Ahmed'),
      S2Choice<String>(value: '0002', title: 'Ali'),
      S2Choice<String>(value: '0003', title: 'Omar'),
      S2Choice<String>(value: '0004', title: 'Sami'),
    ];
    _selectedAppointment = null;
    _selectedColorIndex = 0;
    _selectedTimeZoneIndex = 0;
    _subject = '';
    _notes = '';
    _test11 = '';
    _resourceIds = [];

    super.initState();
  }

  @override
  Widget build([BuildContext context]) {
    // _events = DataSource(_shiftCollection, _employeeCollection);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                EasyDialog(
                    fogOpacity: 0.1,
                    height: 600,
                    title: Text("Basic Easy Dialog Title"),
                    description: Text("This is a basic dialog"),
                    contentList: [
                      FlutterSlider(
                        values: [cellWidth],
                        max: 300,
                        min: 0,
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          print(lowerValue);
                          // _upperValue = upperValue;
                          setState(() {
                            cellWidth = lowerValue;
                          });
                        },
                      )
                      // Container(
                      //   color: Colors.red,
                      //   height: 150,
                      // )
                    ]).show(context);
              },
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: getEventCalendar(_events, onCalendarTapped)));
  }

  SfCalendar getEventCalendar(
      [CalendarDataSource _calendarDataSource,
      CalendarTapCallback calendarTapCallback]) {
    return SfCalendar(
      // view: _calendarView,
      controller: _calendarController,
      allowedViews: _allowedViews,
      dataSource: _calendarDataSource,
      onTap: calendarTapCallback,
      initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0),
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      // timeSlotViewSettings: TimeSlotViewSettings(
      //     timeIntervalWidth: cellWidth,
      //     timeIntervalHeight: 50,
      //     minimumAppointmentDuration: const Duration(minutes: 60)),
    );
  }

  void onCalendarViewChange(String value) {
    if (value == 'Day') {
      _calendarView = CalendarView.day;
    } else if (value == 'Week') {
      _calendarView = CalendarView.week;
    } else if (value == 'Work week') {
      _calendarView = CalendarView.workWeek;
    } else if (value == 'Month') {
      _calendarView = CalendarView.month;
    } else if (value == 'Timeline day') {
      _calendarView = CalendarView.timelineDay;
    } else if (value == 'Timeline week') {
      _calendarView = CalendarView.timelineWeek;
    } else if (value == 'Timeline work week') {
      _calendarView = CalendarView.timelineWorkWeek;
    }

    setState(() {});
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }
    // print(calendarTapDetails.resource.);
    print('rrr');
    _events.appointments?.forEach((element) {
      print(element.to.difference(element.from).inSeconds);
    });
    print('ccc');

    setState(() {
      _selectedAppointment = null;
      _isAllDay = false;
      _selectedColorIndex = 0;
      _selectedTimeZoneIndex = 0;
      _subject = '';
      _notes = '';
      _test11 = '';
      _resourceIds = [];
      _prov = [];
      if (_calendarView == CalendarView.month) {
        _calendarView = CalendarView.day;
      } else {
        if (calendarTapDetails.appointments != null &&
            calendarTapDetails.appointments.length == 1) {
          print('heeeeee');
          final Meeting meetingDetails = calendarTapDetails.appointments[0];
          _startDate = meetingDetails.from;
          _endDate = meetingDetails.to;
          _isAllDay = meetingDetails.isAllDay;

          _selectedColorIndex =
              _colorCollection.indexOf(meetingDetails.background);
          _selectedTimeZoneIndex = meetingDetails.startTimeZone == ''
              ? 0
              : _timeZoneCollection.indexOf(meetingDetails.startTimeZone);
          _subject = meetingDetails.eventName == '(No title)'
              ? ''
              : meetingDetails.eventName;
          _notes = meetingDetails.description;
          _test11 = meetingDetails.test11;
          _selectedAppointment = meetingDetails;
          _resourceIds = <Object>[calendarTapDetails.resource.id];
          _resourceIds.forEach((element) {
            _prov.add(element.toString());
          });
        } else {
          _resourceIds = <Object>[calendarTapDetails.resource.id];
          _resourceIds.forEach((element) {
            _prov.add(element.toString());
          });
          // print(_selectedAppointment.resourceIds.length);
          final DateTime date = calendarTapDetails.date;
          _startDate = date;
          _endDate = date.add(const Duration(hours: 1));
        }
        if (_selectedAppointment != null) {
          print(_selectedAppointment.resourceIds.length);
          _selectedAppointment.resourceIds.forEach((element) {
            _prov.add(element.toString());
          });
        }
        // _resourceIds = <Object>[calendarTapDetails.resource.id];
        // _resourceIds.forEach((element) {
        //   _prov.add(element.toString());
        // });
        // print(_resourceIds[0]);
        ////_selectedAppointment.resourceIds===_resourceIds
        print('from call');
        // print(_events.resources.length);

        _startTime =
            TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);

        Navigator.push<Widget>(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => AppointmentEditor()),
        );
      }
    });
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Meeting> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }

  @override
  bool isAllDay(int index) => appointments[index].isAllDay;

  @override
  String getSubject(int index) => appointments[index].eventName;

  @override
  String getStartTimeZone(int index) => appointments[index].startTimeZone;

  @override
  String getNotes(int index) => appointments[index].description;

  @override
  String getEndTimeZone(int index) => appointments[index].endTimeZone;

  @override
  Color getColor(int index) => appointments[index].background;

  @override
  DateTime getStartTime(int index) => appointments[index].from;

  @override
  DateTime getEndTime(int index) => appointments[index].to;
  @override
  List<Object> getResourceIds(int index) => appointments[index].resourceIds;
}

class Meeting {
  Meeting({
    @required this.from,
    @required this.to,
    this.background = Colors.green,
    this.isAllDay = false,
    this.eventName = '',
    this.startTimeZone = '',
    this.endTimeZone = '',
    this.description = '',
    this.test11 = '',
    this.resourceIds,
  });

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
  final String test11;
  final List<Object> resourceIds;
}
