part of event_calendar;

class AppointmentEditor extends StatefulWidget {
  @override
  AppointmentEditorState createState() => AppointmentEditorState();
}

class AppointmentEditorState extends State<AppointmentEditor> {
  List<CalendarResource> _selectedResources = _events.resources;
  List<CalendarResource> _unSelectedResources = [];
  Widget _getAppointmentEditor(BuildContext context) {
    print('From editor');
    // print(_selectedAppointment.resourceIds;
    // print(_events.resources);
    return Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              leading: const Text(''),
              title: TextField(
                controller: TextEditingController(text: _subject),
                onChanged: (String value) {
                  _subject = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add title',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: Icon(
                  Icons.access_time,
                  color: Colors.black54,
                ),
                title: Row(children: <Widget>[
                  const Expanded(
                    child: Text('All-day'),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Switch(
                            value: _isAllDay,
                            onChanged: (bool value) {
                              setState(() {
                                _isAllDay = value;
                              });
                            },
                          ))),
                ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                                DateFormat('EEE, MMM dd yyyy')
                                    .format(_startDate),
                                textAlign: TextAlign.left),
                            onTap: () async {
                              final DateTime date = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != _startDate) {
                                setState(() {
                                  final Duration difference =
                                      _endDate.difference(_startDate);
                                  _startDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _startTime.hour,
                                      _startTime.minute,
                                      0);
                                  _endDate = _startDate.add(difference);
                                  _endTime = TimeOfDay(
                                      hour: _endDate.hour,
                                      minute: _endDate.minute);
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: _isAllDay
                              ? const Text('')
                              : GestureDetector(
                                  child: Text(
                                    DateFormat('hh:mm a').format(_startDate),
                                    textAlign: TextAlign.right,
                                  ),
                                  onTap: () async {
                                    final TimeOfDay time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                            hour: _startTime.hour,
                                            minute: _startTime.minute));

                                    if (time != null && time != _startTime) {
                                      setState(() {
                                        _startTime = time;
                                        final Duration difference =
                                            _endDate.difference(_startDate);
                                        _startDate = DateTime(
                                            _startDate.year,
                                            _startDate.month,
                                            _startDate.day,
                                            _startTime.hour,
                                            _startTime.minute,
                                            0);
                                        _endDate = _startDate.add(difference);
                                        _endTime = TimeOfDay(
                                            hour: _endDate.hour,
                                            minute: _endDate.minute);
                                      });
                                    }
                                  })),
                    ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                              DateFormat('EEE, MMM dd yyyy').format(_endDate),
                              textAlign: TextAlign.left,
                            ),
                            onTap: () async {
                              final DateTime date = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != _endDate) {
                                setState(() {
                                  final Duration difference =
                                      _endDate.difference(_startDate);
                                  _endDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _endTime.hour,
                                      _endTime.minute,
                                      0);
                                  if (_endDate.isBefore(_startDate)) {
                                    _startDate = _endDate.subtract(difference);
                                    _startTime = TimeOfDay(
                                        hour: _startDate.hour,
                                        minute: _startDate.minute);
                                  }
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: _isAllDay
                              ? const Text('')
                              : GestureDetector(
                                  child: Text(
                                    DateFormat('hh:mm a').format(_endDate),
                                    textAlign: TextAlign.right,
                                  ),
                                  onTap: () async {
                                    final TimeOfDay time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                            hour: _endTime.hour,
                                            minute: _endTime.minute));

                                    if (time != null && time != _endTime) {
                                      setState(() {
                                        _endTime = time;
                                        final Duration difference =
                                            _endDate.difference(_startDate);
                                        _endDate = DateTime(
                                            _endDate.year,
                                            _endDate.month,
                                            _endDate.day,
                                            _endTime.hour,
                                            _endTime.minute,
                                            0);
                                        if (_endDate.isBefore(_startDate)) {
                                          _startDate =
                                              _endDate.subtract(difference);
                                          _startTime = TimeOfDay(
                                              hour: _startDate.hour,
                                              minute: _startDate.minute);
                                        }
                                      });
                                    }
                                  })),
                    ])),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(
                Icons.public,
                color: Colors.black87,
              ),
              title: Text(_timeZoneCollection[_selectedTimeZoneIndex]),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return _TimeZonePicker();
                  },
                ).then((dynamic value) => setState(() {}));
              },
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(Icons.lens,
                  color: _colorCollection[_selectedColorIndex]),
              title: Text(
                _colorNames[_selectedColorIndex],
              ),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return _ColorPicker();
                  },
                ).then((dynamic value) => setState(() {}));
              },
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: Icon(
                Icons.subject,
                color: Colors.black87,
              ),
              title: TextField(
                controller: TextEditingController(text: _notes),
                onChanged: (String value) {
                  _notes = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add description',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: Icon(
                Icons.subject,
                color: Colors.black87,
              ),
              title: TextField(
                controller: TextEditingController(text: _test11),
                onChanged: (String value) {
                  _test11 = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add test11',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            _resourceIds == null || _resourceIds.isEmpty
                ? Container()
                : ListTile(
                    leading: Icon(
                      Icons.people,
                      size: 20,
                      color: Colors.blueGrey,
                    ),
                    title: Text(
                        _getSelectedResourceText(
                            _resourceIds, _events.resources),
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                            fontWeight: FontWeight.w400)),
                  ),
            SizedBox(
              height: 10,
            ),
            _events.resources == null || _events.resources.isEmpty
                ? Container()
                : Container(
                    margin: EdgeInsets.only(bottom: 5),
                    height: 50,
                    child: ListTile(
                      leading: Container(
                          width: 30,
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.people,
                            color: Colors.teal,
                            size: 20,
                          )),
                      title: RawMaterialButton(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: _getResourceEditor(TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300)),
                        ),
                        onPressed: () {
                          showDialog<Widget>(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return _ResourcePicker(
                                _unSelectedResources,
                                onChanged: (_PickerChangedDetails details) {
                                  _resourceIds == null
                                      ? _resourceIds = <Object>[
                                          details.resourceId
                                        ]
                                      : _resourceIds.add(details.resourceId);
                                  _selectedResources = _getSelectedResources(
                                      _resourceIds, _events.resources);
                                  _unSelectedResources =
                                      _getUnSelectedResources(
                                          _selectedResources,
                                          _events.resources);
                                },
                              );
                            },
                          ).then((dynamic value) => setState(() {
                                /// update the color picker changes
                              }));
                        },
                      ),
                    )),
          ],
        ));
  }

  /// Returns the selected resources based on the id collection passed
  List<CalendarResource> _getSelectedResources(
      List<Object> _resourceIds, List<CalendarResource> resourceCollection) {
    if (_resourceIds == null || _resourceIds.isEmpty) {
      return null;
    }

    final List<CalendarResource> _selectedResources = <CalendarResource>[];
    for (int i = 0; i < _resourceIds.length; i++) {
      final CalendarResource resourceName =
          _getResourceFromId(_resourceIds[i], resourceCollection);
      _selectedResources.add(resourceName);
    }

    return _selectedResources;
  }

  /// Returns the resource from the id passed.
  CalendarResource _getResourceFromId(
      Object resourceId, List<CalendarResource> resourceCollection) {
    return resourceCollection
        .firstWhere((resource) => resource.id == resourceId);
  }

  /// Returns the available resource, by filtering the resource collection from
  /// the selected resource collection.
  List<CalendarResource> _getUnSelectedResources(
      List<CalendarResource> selectedResources,
      List<CalendarResource> resourceCollection) {
    if (selectedResources == null || selectedResources.isEmpty) {
      return resourceCollection;
    }

    List<CalendarResource> collection = resourceCollection.sublist(0);
    for (int i = 0; i < resourceCollection.length; i++) {
      final CalendarResource resource = resourceCollection[i];
      for (int j = 0; j < selectedResources.length; j++) {
        final CalendarResource selectedResource = selectedResources[j];
        if (resource.id == selectedResource.id) {
          collection.remove(resource);
        }
      }
    }

    return collection;
  }

  String _getSelectedResourceText(
      List<Object> resourceIds, List<CalendarResource> resourceCollection) {
    String resourceNames;
    for (int i = 0; i < resourceIds.length; i++) {
      final String name = resourceCollection
          .firstWhere((resource) => resource.id == resourceIds[i])
          .displayName;
      resourceNames =
          resourceNames == null ? name : resourceNames + ', ' + name;
    }

    return resourceNames;
  }

  Widget _getResourceEditor([TextStyle hintTextStyle]) {
    if (_selectedResources == null || _selectedResources.isEmpty) {
      return Text('Add people', style: hintTextStyle);
    }

    List<Widget> chipWidgets = <Widget>[];
    for (int i = 0; i < _selectedResources.length; i++) {
      final CalendarResource selectedResource = _selectedResources[i];
      chipWidgets.add(Chip(
        padding: EdgeInsets.only(left: 0),
        avatar: CircleAvatar(
          backgroundColor: Color.fromRGBO(0, 116, 227, 1),
          backgroundImage: selectedResource.image,
          child: selectedResource.image == null
              ? Text(selectedResource.displayName[0])
              : null,
        ),
        label: Text(selectedResource.displayName),
        onDeleted: () {
          _selectedResources.removeAt(i);
          _resourceIds.removeAt(i);
          _unSelectedResources =
              _getUnSelectedResources(_selectedResources, _events.resources);
          setState(() {});
        },
      ));
    }

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: chipWidgets,
    );
  }

  @override
  Widget build([BuildContext context]) {
    // print(_resourceIds[0]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text(getTile()),
              backgroundColor: _colorCollection[_selectedColorIndex],
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    icon: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      final List<Meeting> meetings = <Meeting>[];
                      if (_selectedAppointment != null) {
                        _events.appointments.removeAt(
                            _events.appointments.indexOf(_selectedAppointment));
                        _events.notifyListeners(CalendarDataSourceAction.remove,
                            <Meeting>[]..add(_selectedAppointment));
                      }
                      meetings.add(Meeting(
                          from: _startDate,
                          to: _endDate,
                          background: _colorCollection[_selectedColorIndex],
                          startTimeZone: _selectedTimeZoneIndex == 0
                              ? ''
                              : _timeZoneCollection[_selectedTimeZoneIndex],
                          endTimeZone: _selectedTimeZoneIndex == 0
                              ? ''
                              : _timeZoneCollection[_selectedTimeZoneIndex],
                          description: _notes,
                          isAllDay: _isAllDay,
                          eventName: _subject == '' ? '(No title)' : _subject,
                          test11: _test11,
                          resourceIds: ['0001', '0002']));

                      _events.appointments.add(meetings[0]);

                      _events.notifyListeners(
                          CalendarDataSourceAction.add, meetings);
                      _selectedAppointment = null;
                      print(meetings[0].from);
                      print(meetings[0].to);
                      print(meetings[0].description);

                      // print(widget.appointment[0].location);
                      // print(widget.appointment[0].notes);
                      // widget.appointment[0].resourceIds.forEach((element) {
                      //   // print(element);
                      //   print(widget
                      //       .events.resources[int.parse(element)].displayName);
                      //   handleposttodatabase(
                      //       desc: widget.appointment[0].subject,
                      //       location: widget.appointment[0].location,
                      //       provider: widget.events
                      //           .resources[int.parse(element)].displayName,
                      //       notes: widget.appointment[0].notes,
                      //       eTime: widget.appointment[0].endTime,
                      //       sTime: widget.appointment[0].startTime);
                      // });
                      Navigator.pop(context);
                    })
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Stack(
                children: <Widget>[_getAppointmentEditor(context)],
              ),
            ),
            floatingActionButton: _selectedAppointment == null
                ? const Text('')
                : FloatingActionButton(
                    onPressed: () {
                      if (_selectedAppointment != null) {
                        _events.appointments.removeAt(
                            _events.appointments.indexOf(_selectedAppointment));
                        _events.notifyListeners(CalendarDataSourceAction.remove,
                            <Meeting>[]..add(_selectedAppointment));
                        _selectedAppointment = null;
                        Navigator.pop(context);
                      }
                    },
                    child:
                        const Icon(Icons.delete_outline, color: Colors.white),
                    backgroundColor: Colors.red,
                  )));
  }

  String getTile() {
    return _subject.isEmpty ? 'New event' : 'Event details';
  }
}

/// Signature for callback which reports the picker value changed
typedef _PickerChanged = void Function(
    _PickerChangedDetails pickerChangedDetails);

/// Picker to display the available resource collection, and returns the
/// selected resource id.
class _ResourcePicker extends StatefulWidget {
  _ResourcePicker(this.resourceCollection, {this.onChanged});

  final List<CalendarResource> resourceCollection;

  final _PickerChanged onChanged;

  @override
  State<StatefulWidget> createState() => _ResourcePickerState();
}

class _ResourcePickerState extends State<_ResourcePicker> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.light(),
        child: AlertDialog(
          content: Container(
              width: 500,
              height: (widget.resourceCollection.length * 50).toDouble(),
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: widget.resourceCollection.length,
                itemBuilder: (BuildContext context, int index) {
                  final CalendarResource resource =
                      widget.resourceCollection[index];
                  return Container(
                      height: 50,
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        leading: CircleAvatar(
                          backgroundColor: Color.fromRGBO(0, 116, 227, 1),
                          backgroundImage: resource.image,
                          child: resource.image == null
                              ? Text(resource.displayName[0])
                              : null,
                        ),
                        title: Text(resource.displayName),
                        onTap: () {
                          setState(() {
                            widget.onChanged(
                                _PickerChangedDetails(resourceId: resource.id));
                          });

                          // ignore: always_specify_types
                          Future.delayed(const Duration(milliseconds: 200), () {
                            // When task is over, close the dialog
                            Navigator.pop(context);
                          });
                        },
                      ));
                },
              )),
        ));
  }
}

class _PickerChangedDetails {
  _PickerChangedDetails({this.index, this.resourceId});

  final int index;

  final Object resourceId;
}
