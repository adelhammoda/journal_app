import 'package:flutter/material.dart';
import 'package:journal_app/bloc/journal_edit_bloc.dart';
import 'package:journal_app/bloc/journal_editng_bloc_provider.dart';
import 'package:journal_app/classes/data_format.dart';
import 'package:journal_app/classes/material.dart';
import 'package:journal_app/widgets/widgets.dart';
import 'package:responsive_s/responsive_s.dart';

class EditJournal extends StatefulWidget {
  const EditJournal({Key? key}) : super(key: key);

  @override
  _EditJournalState createState() => _EditJournalState();
}

class _EditJournalState extends State<EditJournal> {
  late JournalEditBloc _journalEditBloc;
  late FormatDate _formatDates;
  late MoodIcons _moodIcons;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _formatDates = FormatDate();
    _moodIcons = MoodIcons();
    _noteController = TextEditingController();
    _noteController.text = '';
  }

  @override
  void dispose() {
    _noteController.dispose();
    _journalEditBloc.dispose();
    super.dispose();
  }

  Future<String> _selectDate(String selectedDate) async {
    DateTime _initialDate = DateTime.parse(selectedDate);
    final DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _initialDate,
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (_pickedDate != null) {
      selectedDate = DateTime(
              _pickedDate.year,
              _pickedDate.month,
              _pickedDate.day,
              _pickedDate.hour,
              _pickedDate.minute,
              _pickedDate.second,
              _pickedDate.millisecond,
              _pickedDate.microsecond)
          .toString();
    }
    return selectedDate;
  }

  void _addOrUpdateJournal() {
    _journalEditBloc.saveJournalChanged.add('Save');
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _journalEditBloc = JournalEditingBlocProvider.of(context).journalEditBloc;
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text(
            'Entry',
            style: TextStyle(color: Colors.lightGreen.shade800),
          ),
          automaticallyImplyLeading: false,
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightGreen,
                  Colors.lightGreen.shade200,
                  Colors.lightGreen.shade50
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        body: SafeArea(
          minimum: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: _journalEditBloc.dataEdit,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData) return Container();
                  return TextButton(
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: responsive.setWidth(5),
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: responsive.setWidth(2),
                        ),
                        Text(
                          _formatDates
                              .dateFormatShortMonthDayYear(snapshot.data ?? ''),
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.black54)
                      ],
                    ),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      String _pickerDate =
                          await _selectDate(snapshot.data ?? '');
                      _journalEditBloc.dataEditChanged.add(_pickerDate);
                    },
                  );
                },
              ),
              StreamBuilder(
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return DropdownButton<MoodIcons>(
                    value: _moodIcons.getMoodIconsList()[_moodIcons
                        .getMoodIconsList()
                        .indexWhere((icon) => icon.title == snapshot.data)],
                    onChanged: (selectedIcon) {
                      if (selectedIcon != null)
                        _journalEditBloc.moodEditChanged
                            .add(selectedIcon.title);
                    },
                    items: _moodIcons.getMoodIconsList().map((moodIcon) {
                      return DropdownMenuItem<MoodIcons>(
                        value: moodIcon,
                        child: Transform(
                          child: Icon(moodIcon.icon, color: moodIcon.color),
                          transform: Matrix4.identity()
                            ..rotateZ(moodIcon.rotation),
                        ),
                        onTap: () {},
                      );
                    }).toList(growable: false),
                  );
                },
                stream: _journalEditBloc.moodEdit,
              ),
              StreamBuilder(
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData) return Container();
                  // _noteController.value =
                  //     _noteController.value.copyWith(text: snapshot.data);
                  return TextField(
                    controller: _noteController,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (input) =>
                        _journalEditBloc.noteEditChanged.add(input),
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: 'Note', icon: Icon(Icons.subject)),
                  );
                },
                stream: _journalEditBloc.noteEdit,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end ,
                mainAxisSize: MainAxisSize.max ,
                children: [
                  TextButton(onPressed: ()=>Navigator.of(context).pop(),style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade100)
                  ), child: Text('Cancel')),
                  SizedBox(width: responsive.setWidth(3),),
                  TextButton(onPressed: ()=>_addOrUpdateJournal(),style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.lightGreen.shade100)
                  ), child: Text('Save'))
                ],
              )
            ],
          ),
        ));
  }
}
