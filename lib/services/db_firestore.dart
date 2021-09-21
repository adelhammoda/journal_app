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
        .doc(journal.documentId)
        .delete().then((value) => print('deleted ///////////'))
        .catchError((e) => print(e.toString()));
  }

  @override
  Future<Journal> getJournal(String documentID) {
    //TODO: implement getJournal
    throw '';
  }

  @override
  Stream<List<Journal>> gitJournalList(String uid) {
    return _firestore
        .collection(_collectionJournal)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot<Map<String,dynamic>> snapshot) {
      List<Journal> _journalDocs =
          snapshot.docs.map((e) => Journal.fromDocs(e)).toList();
      _journalDocs.sort((comp1, comp2) => comp2.date.compareTo(comp1.date));

      return _journalDocs;
    });
  }

  @override
  Future<bool> updateJournal(Journal journal) async {
    late bool result;
    await _firestore.collection(_collectionJournal).doc(journal.uid).update({
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
    }).catchError((e) {
      result= false;
    }).then((value) {
      result =true;
    });
    return result;
  }

  @override
  void updateJournalWithTransaction(Journal journal) {
    // TODO: implement updateJournalWithTransaction
  }
}
