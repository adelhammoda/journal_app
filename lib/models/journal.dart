


class Journal{
   String documentId;
   String uid;
   String mood;
   String date;
   String note;
   Journal({this.note='',this.date='',this.documentId='',this.mood='',this.uid=''});
   factory Journal.fromDocs(dynamic doc)=>Journal(
     documentId: doc.documentID,
       date: doc["date"],
       mood: doc["mood"],
       note: doc["note"],
       uid: doc["uid"],
   );
}