library event_calendar;

// import 'choice.dart' as choices;
import 'dart:math';
import 'package:flutter/material.dart';
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

List<Color> _colorCollection = [Colors.red, Colors.blue, Colors.green];
List<String> _colorNames = ['Red', 'Blue', 'Green'];
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
  List<String> eventNameCollection;
  // List<Meeting> appointments;
  List<Meeting> appointments = [
    Meeting(
        from: DateTime.now(),
        to: DateTime.now().add(Duration(hours: 1)),
        background: Colors.teal,
        description: 'Test',
        resourceIds: <String>['0001', '0002'])
  ];

  List<CalendarResource> _employeeCollection = [
    CalendarResource(id: '0001', displayName: 'Ahmed', color: Colors.red),
    CalendarResource(id: '0002', displayName: 'Ali', color: Colors.teal)
  ];

  @override
  void initState() {
    _calendarView = CalendarView.timelineWeek;
    //  appointments = getMeetingDetails();
    _events = DataSource(appointments, _employeeCollection);
    allemolyees = [
      S2Choice<String>(value: '0001', title: 'Ahmed'),
      S2Choice<String>(value: '0002', title: 'Ali'),
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
        body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: getEventCalendar(_calendarView, _events, onCalendarTapped)));
  }

  SfCalendar getEventCalendar(
      [CalendarView _calendarView,
      CalendarDataSource _calendarDataSource,
      CalendarTapCallback calendarTapCallback]) {
    return SfCalendar(
        view: _calendarView,
        dataSource: _calendarDataSource,
        onTap: calendarTapCallback,
        initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0),
        monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        timeSlotViewSettings: TimeSlotViewSettings(
            minimumAppointmentDuration: const Duration(minutes: 60)));
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

    setState(() {
      _selectedAppointment = null;
      _isAllDay = false;
      _selectedColorIndex = 0;
      _selectedTimeZoneIndex = 0;
      _subject = '';
      _notes = '';
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

  // List<Meeting> getMeetingDetails() {
  //   final List<Meeting> meetingCollection = <Meeting>[];
  //   eventNameCollection = <String>[];
  //   eventNameCollection.add('General Meeting');
  //   eventNameCollection.add('Plan Execution');
  //   eventNameCollection.add('Project Plan');
  //   eventNameCollection.add('Consulting');
  //   eventNameCollection.add('Support');
  //   eventNameCollection.add('Development Meeting');
  //   eventNameCollection.add('Scrum');
  //   eventNameCollection.add('Project Completion');
  //   eventNameCollection.add('Release updates');
  //   eventNameCollection.add('Performance Check');

  //   _colorCollection = <Color>[];
  //   _colorCollection.add(const Color(0xFF0F8644));
  //   _colorCollection.add(const Color(0xFF8B1FA9));
  //   _colorCollection.add(const Color(0xFFD20100));
  //   _colorCollection.add(const Color(0xFFFC571D));
  //   _colorCollection.add(const Color(0xFF85461E));
  //   _colorCollection.add(const Color(0xFFFF00FF));
  //   _colorCollection.add(const Color(0xFF3D4FB5));
  //   _colorCollection.add(const Color(0xFFE47C73));
  //   _colorCollection.add(const Color(0xFF636363));

  //   _colorNames = <String>[];
  //   _colorNames.add('Green');
  //   _colorNames.add('Purple');
  //   _colorNames.add('Red');
  //   _colorNames.add('Orange');
  //   _colorNames.add('Caramel');
  //   _colorNames.add('Magenta');
  //   _colorNames.add('Blue');
  //   _colorNames.add('Peach');
  //   _colorNames.add('Gray');

  //   _timeZoneCollection = <String>[];
  //   _timeZoneCollection.add('Default Time');
  //   _timeZoneCollection.add('AUS Central Standard Time');
  //   _timeZoneCollection.add('AUS Eastern Standard Time');
  //   _timeZoneCollection.add('Afghanistan Standard Time');
  //   _timeZoneCollection.add('Alaskan Standard Time');
  //   _timeZoneCollection.add('Arab Standard Time');
  //   _timeZoneCollection.add('Arabian Standard Time');
  //   _timeZoneCollection.add('Arabic Standard Time');
  //   _timeZoneCollection.add('Argentina Standard Time');
  //   _timeZoneCollection.add('Atlantic Standard Time');
  //   _timeZoneCollection.add('Azerbaijan Standard Time');
  //   _timeZoneCollection.add('Azores Standard Time');
  //   _timeZoneCollection.add('Bahia Standard Time');
  //   _timeZoneCollection.add('Bangladesh Standard Time');
  //   _timeZoneCollection.add('Belarus Standard Time');
  //   _timeZoneCollection.add('Canada Central Standard Time');
  //   _timeZoneCollection.add('Cape Verde Standard Time');
  //   _timeZoneCollection.add('Caucasus Standard Time');
  //   _timeZoneCollection.add('Cen. Australia Standard Time');
  //   _timeZoneCollection.add('Central America Standard Time');
  //   _timeZoneCollection.add('Central Asia Standard Time');
  //   _timeZoneCollection.add('Central Brazilian Standard Time');
  //   _timeZoneCollection.add('Central Europe Standard Time');
  //   _timeZoneCollection.add('Central European Standard Time');
  //   _timeZoneCollection.add('Central Pacific Standard Time');
  //   _timeZoneCollection.add('Central Standard Time');
  //   _timeZoneCollection.add('China Standard Time');
  //   _timeZoneCollection.add('Dateline Standard Time');
  //   _timeZoneCollection.add('E. Africa Standard Time');
  //   _timeZoneCollection.add('E. Australia Standard Time');
  //   _timeZoneCollection.add('E. South America Standard Time');
  //   _timeZoneCollection.add('Eastern Standard Time');
  //   _timeZoneCollection.add('Egypt Standard Time');
  //   _timeZoneCollection.add('Ekaterinburg Standard Time');
  //   _timeZoneCollection.add('FLE Standard Time');
  //   _timeZoneCollection.add('Fiji Standard Time');
  //   _timeZoneCollection.add('GMT Standard Time');
  //   _timeZoneCollection.add('GTB Standard Time');
  //   _timeZoneCollection.add('Georgian Standard Time');
  //   _timeZoneCollection.add('Greenland Standard Time');
  //   _timeZoneCollection.add('Greenwich Standard Time');
  //   _timeZoneCollection.add('Hawaiian Standard Time');
  //   _timeZoneCollection.add('India Standard Time');
  //   _timeZoneCollection.add('Iran Standard Time');
  //   _timeZoneCollection.add('Israel Standard Time');
  //   _timeZoneCollection.add('Jordan Standard Time');
  //   _timeZoneCollection.add('Kaliningrad Standard Time');
  //   _timeZoneCollection.add('Korea Standard Time');
  //   _timeZoneCollection.add('Libya Standard Time');
  //   _timeZoneCollection.add('Line Islands Standard Time');
  //   _timeZoneCollection.add('Magadan Standard Time');
  //   _timeZoneCollection.add('Mauritius Standard Time');
  //   _timeZoneCollection.add('Middle East Standard Time');
  //   _timeZoneCollection.add('Montevideo Standard Time');
  //   _timeZoneCollection.add('Morocco Standard Time');
  //   _timeZoneCollection.add('Mountain Standard Time');
  //   _timeZoneCollection.add('Mountain Standard Time (Mexico)');
  //   _timeZoneCollection.add('Myanmar Standard Time');
  //   _timeZoneCollection.add('N. Central Asia Standard Time');
  //   _timeZoneCollection.add('Namibia Standard Time');
  //   _timeZoneCollection.add('Nepal Standard Time');
  //   _timeZoneCollection.add('New Zealand Standard Time');
  //   _timeZoneCollection.add('Newfoundland Standard Time');
  //   _timeZoneCollection.add('North Asia East Standard Time');
  //   _timeZoneCollection.add('North Asia Standard Time');
  //   _timeZoneCollection.add('Pacific SA Standard Time');
  //   _timeZoneCollection.add('Pacific Standard Time');
  //   _timeZoneCollection.add('Pacific Standard Time (Mexico)');
  //   _timeZoneCollection.add('Pakistan Standard Time');
  //   _timeZoneCollection.add('Paraguay Standard Time');
  //   _timeZoneCollection.add('Romance Standard Time');
  //   _timeZoneCollection.add('Russia Time Zone 10');
  //   _timeZoneCollection.add('Russia Time Zone 11');
  //   _timeZoneCollection.add('Russia Time Zone 3');
  //   _timeZoneCollection.add('Russian Standard Time');
  //   _timeZoneCollection.add('SA Eastern Standard Time');
  //   _timeZoneCollection.add('SA Pacific Standard Time');
  //   _timeZoneCollection.add('SA Western Standard Time');
  //   _timeZoneCollection.add('SE Asia Standard Time');
  //   _timeZoneCollection.add('Samoa Standard Time');
  //   _timeZoneCollection.add('Singapore Standard Time');
  //   _timeZoneCollection.add('South Africa Standard Time');
  //   _timeZoneCollection.add('Sri Lanka Standard Time');
  //   _timeZoneCollection.add('Syria Standard Time');
  //   _timeZoneCollection.add('Taipei Standard Time');
  //   _timeZoneCollection.add('Tasmania Standard Time');
  //   _timeZoneCollection.add('Tokyo Standard Time');
  //   _timeZoneCollection.add('Tonga Standard Time');
  //   _timeZoneCollection.add('Turkey Standard Time');
  //   _timeZoneCollection.add('US Eastern Standard Time');
  //   _timeZoneCollection.add('US Mountain Standard Time');
  //   _timeZoneCollection.add('UTC');
  //   _timeZoneCollection.add('UTC+12');
  //   _timeZoneCollection.add('UTC-02');
  //   _timeZoneCollection.add('UTC-11');
  //   _timeZoneCollection.add('Ulaanbaatar Standard Time');
  //   _timeZoneCollection.add('Venezuela Standard Time');
  //   _timeZoneCollection.add('Vladivostok Standard Time');
  //   _timeZoneCollection.add('W. Australia Standard Time');
  //   _timeZoneCollection.add('W. Central Africa Standard Time');
  //   _timeZoneCollection.add('W. Europe Standard Time');
  //   _timeZoneCollection.add('West Asia Standard Time');
  //   _timeZoneCollection.add('West Pacific Standard Time');
  //   _timeZoneCollection.add('Yakutsk Standard Time');

  //   final DateTime today = DateTime.now();
  //   final Random random = Random();
  //   for (int month = -1; month < 2; month++) {
  //     for (int day = -5; day < 5; day++) {
  //       for (int hour = 9; hour < 18; hour += 5) {
  //         meetingCollection.add(Meeting(
  //           from: today
  //               .add(Duration(days: (month * 30) + day))
  //               .add(Duration(hours: hour)),
  //           to: today
  //               .add(Duration(days: (month * 30) + day))
  //               .add(Duration(hours: hour + 2)),
  //           background: _colorCollection[random.nextInt(9)],
  //           startTimeZone: '',
  //           endTimeZone: '',
  //           description: '',
  //           isAllDay: false,
  //           eventName: eventNameCollection[random.nextInt(7)],
  //         ));
  //       }
  //     }
  //   }

  //   return meetingCollection;
  // }
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
