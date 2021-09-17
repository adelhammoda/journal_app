import 'dart:async';

import 'package:journal_app/models/journal.dart';
import 'package:journal_app/services/db_firestore_api.dart';



class JournalEditBloc {
  final DbApi dbApi;
  final bool add;
  Journal selectedJournal;

  JournalEditBloc(this.add, this.selectedJournal, this.dbApi) {
    _startEditListener().then((finished) => _getJournal(add, selectedJournal));
  }

  final StreamController<String> _dataController =
      StreamController<String>.broadcast();

  Sink<String> get dataEditChanged => _dataController.sink;

  Stream<String> get dataEdit => _dataController.stream;

  //
  final StreamController<String> _moodController =
      StreamController<String>.broadcast();

  Sink<String> get moodEditChanged => _moodController.sink;

  Stream<String> get moodEdit => _moodController.stream;
  final StreamController<String> _noteController =
      StreamController<String>.broadcast();

  Sink<String> get noteEditChanged => _noteController.sink;

  Stream<String> get noteEdit => _noteController.stream;
  final StreamController<String> _saveJournalController =
      StreamController<String>.broadcast();

  Sink<String> get saveJournalChanged => _saveJournalController.sink;

  Stream<String> get saveJournal => _saveJournalController.stream;

  void dispose() {
    _dataController.close();
    _moodController.close();
    _noteController.close();
    _saveJournalController.close();
  }

  Future<bool> _startEditListener() async {
    _dataController.stream.listen((date) {
      selectedJournal.date = date;
    });
    _moodController.stream.listen((mood) {
      selectedJournal.mood = mood;
    });
    _noteController.stream.listen((note) {
      selectedJournal.note = note;
    });
    _saveJournalController.stream.listen((action) {
      if (action == 'Save') {
        _saveJournal();
      }
    });
    return true;
  }

  void _getJournal(bool add, Journal journal) {
    if (add) {
      selectedJournal = Journal();
      selectedJournal.date = DateTime.now().toString();
      selectedJournal.mood = 'Very Satisfied';
      selectedJournal.note = '';
      selectedJournal.uid = journal.uid;
    } else {
      selectedJournal.date = journal.date;
      selectedJournal.mood = journal.mood;
      selectedJournal.note = journal.note;
    }
    dataEditChanged.add(selectedJournal.date);
    moodEditChanged.add(selectedJournal.mood);
    noteEditChanged.add(selectedJournal.note);
  }

  void _saveJournal() {
    Journal journal = Journal(
      documentId: selectedJournal.documentId,
      date: DateTime.parse(selectedJournal.date).toIso8601String(),
      mood: selectedJournal.mood,
      note: selectedJournal.note,
      uid: selectedJournal.uid,
    );
    add ? dbApi.addJournal(journal) : dbApi.updateJournal(journal);
  }
}
