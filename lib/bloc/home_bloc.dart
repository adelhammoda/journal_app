import 'dart:async';

import 'package:journal_app/models/journal.dart';
import 'package:journal_app/services/authentication_api.dart';
import 'package:journal_app/services/db_firestore_api.dart';



class HomeBloc {
  final DbApi dbApi;
  final AuthenticationApi authenticationApi;
  final StreamController<List<Journal>> _journalController =
  new StreamController<List<Journal>>.broadcast();

  HomeBloc(this.dbApi, this.authenticationApi) {
    _startListeners();
  }


  Sink<List<Journal>> get _addListJournal => _journalController.sink;

  Stream<List<Journal>> get listJournal => _journalController.stream;
  final StreamController<Journal> _journalDeleteController =
  StreamController<Journal>.broadcast();

  void dispose() {
    _journalController.close();
    _journalDeleteController.close();
  }

  void _startListeners() async {
    // Retrieve Firestore Journal Records as List<Journal> not DocumentSnapshot

    authenticationApi.currentUserUid().then((userUID) {
      dbApi.gitJournalList(userUID).listen((journalDocs) {
        _addListJournal.add(journalDocs);
      });
    });

    _journalDeleteController.stream.listen((journal) {
      dbApi.deleteJournal(journal);
    });
  }
}
