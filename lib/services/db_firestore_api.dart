import 'package:journal_app/models/journal.dart';

abstract class DbApi {
  Stream<List<Journal>> gitJournalList(String uid);

  Future<Journal> getJournal(String documentID);

  Future<bool> addJournal(Journal journal);

  Future<bool> updateJournal(Journal journal);

  void updateJournalWithTransaction(Journal journal);

  void deleteJournal(Journal journal);
}
