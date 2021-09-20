// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/services/db_firestore_api.dart';

class DbFireStore implements DbApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionJournal = 'journals';

  @override
  Future<bool> addJournal(Journal journal) async {
    DocumentReference? _document =
        await _firestore.collection(_collectionJournal).add({
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
      'uid': journal.uid,
    });
    return _document != null;
  }

  @override
  void deleteJournal(Journal journal) {
    _firestore
        .collection(_collectionJournal)
        .doc(journal.uid)
        .delete()
        .catchError((e) => print(e.toString()));
  }

  @override
  Future<Journal> getJournal(String documentID) {
    //TODO: implement getJournal
    throw '';
  }

  @override
  Stream<List<Journal>> gitJournalList(String uid) {
    // print('${_firestore
    //     .collection(_collectionJournal)
    //     .where('uid', isEqualTo: uid).snapshots()} ][][][][][][][][][]');
    return _firestore
        .collection(_collectionJournal)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot<Map<String,dynamic>> snapshot) {
      print('${snapshot.docs.map((journal) => journal).toList()} [][][][][][][]');
      List<Journal> _journalDocs =
          snapshot.docs.map((e) => Journal.fromDocs(e)).toList();
      _journalDocs.sort((comp1, comp2) => comp2.date.compareTo(comp1.date));

      return _journalDocs;
    });
  }

  @override
  void updateJournal(Journal journal) async {
    await _firestore.collection(_collectionJournal).doc(journal.uid).update({
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
    }).catchError((e) => print('$e'));
  }

  @override
  void updateJournalWithTransaction(Journal journal) {
    // TODO: implement updateJournalWithTransaction
  }
}
