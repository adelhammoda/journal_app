import 'package:flutter/material.dart';
import 'package:journal_app/bloc/authentication_bloc_proiverder.dart';
import 'package:journal_app/bloc/authentication_block.dart';
import 'package:journal_app/bloc/home_bloc.dart';
import 'package:journal_app/bloc/home_bloc_provider.dart';
import 'package:journal_app/bloc/journal_edit_bloc.dart';
import 'package:journal_app/bloc/journal_editng_bloc_provider.dart';
import 'package:journal_app/classes/data_format.dart';
import 'package:journal_app/classes/material.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/screens/EditJournal.dart';
import 'package:journal_app/services/db_firestore.dart';
import 'package:journal_app/widgets/widgets.dart';
import 'package:responsive_s/responsive_s.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Responsive responsive;
  late AuthenticationBLoC _authenticationBloc;
  late HomeBloc _homeBloc;
  late String _uid;
  MoodIcons _moodIcons = MoodIcons();
  FormatDate _formatDates = FormatDate();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
  }

  @override
  void dispose() {
    super.dispose();
    _homeBloc.dispose();
    // _authenticationBloc.dispose();
  }

  void _addOrEditJournal({required bool add, required Journal journal}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => JournalEditingBlocProvider(
              widget: EditJournal(),
              journalEditBloc: JournalEditBloc(add, journal, DbFireStore())),
          fullscreenDialog: true),
    );
  }

  Future<bool> _confirmDeleteJournal() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete Journal'),
              content: Text('Are you sure you would like to delete?'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('CANCEL')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('DELETE'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildListViewSeparated(AsyncSnapshot<List<Journal>> snapshot) {
      return snapshot.data!.length > 0
          ? ListView.separated(
              itemBuilder: (context, int index) {
                String _titleDate = _formatDates
                    .dateFormatShortMonthDayYear(snapshot.data![index].date);
                String _subtitle = snapshot.data![index].mood +
                    "\n" +
                    snapshot.data![index].note;
                return Dismissible(
                    confirmDismiss: (direction) async {
                      bool confirmDismiss = await _confirmDeleteJournal();
                      if (confirmDismiss) {
                        print(snapshot.data![index].uid);
                        _homeBloc.deleteJournal.add(snapshot.data![index]);
                      }
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    key: Key(snapshot.data![index].documentId),
                    child: ListTile(
                      trailing: Transform(
                        transform: Matrix4.identity()
                          ..rotateZ(_moodIcons
                              .getMoodRotation(snapshot.data![index].mood)),
                        alignment: Alignment.center,
                        child: Icon(
                          _moodIcons.getMoodIcon(snapshot.data![index].mood),
                          color: _moodIcons
                              .getMoodColor(snapshot.data![index].mood),
                        ),
                      ),
                      title: Text(_titleDate),
                      subtitle: Text(_subtitle),
                      onTap: () {
                        _addOrEditJournal(
                            add: false, journal: snapshot.data![index]);
                      },
                      leading: Column(
                        children: <Widget>[
                          Text(
                            _formatDates.dateFormatDayNumber(
                                snapshot.data![index].date),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32.0,
                                color: Colors.lightGreen),
                          ),
                          Text(_formatDates.dateFormatShortDayName(
                              snapshot.data![index].date)),
                        ],
                      ),
                    ));
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                    color: Colors.grey,
                  ),
              itemCount: snapshot.data == null ? 0 : snapshot.data!.length)
          : Center(child: Text('No thing to show. Try add something',style: TextStyle(
        fontSize: responsive.setFont(5)
      ),));
    }

    responsive = new Responsive(context);
    return Scaffold(
      drawer: MyDrawer(),
      backgroundColor: Colors.lightGreen.shade50,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.lightGreen.shade800,
            ),
            onPressed: () {
              _authenticationBloc.logoutUser.add(true);
            },
          ),
        ],
        bottom: PreferredSize(
          child: Container(),
          preferredSize: Size.fromHeight(responsive.setHeight(3)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.lightGreen,
              Colors.lightGreen.shade50,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          width: 60,
        ),
        elevation: 0.0,
        title: Text('Journal app'),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.lightGreen.shade50,
              Colors.lightGreen,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          height: responsive.setHeight(10),
          width: 60,
        ),
        elevation: 0,
      ),
      body: StreamBuilder<List<Journal>>(
          stream: _homeBloc.listJournal,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.hasData)
              return _buildListViewSeparated(snapshot);
            else
              return Center(child: Text('Add journal'));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen.shade300,
        onPressed: () async {
          _addOrEditJournal(add: true, journal: Journal(uid: _uid));
        },
        tooltip: 'Add Journal',
        child: Icon(Icons.add),
      ),
    );
  }
}
