import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Id {
  final String value;

  Id(this.value);
}

abstract class FirestoreId extends Id {
  FirestoreId(super.value, this.collectionId);
  final CollectionId collectionId;

  CollectionReference<dynamic> collection() {
    return collectionId.collection();
  }

  DocumentReference<dynamic> document() {
    return collectionId.document(value);
  }
}

abstract class CollectionId {
  CollectionReference<dynamic> collection();
  DocumentReference<dynamic> document(String docId) {
    return collection().doc(docId);
  }
}

mixin CollectionId1 on CollectionId {
  String get collection1;

  @override
  CollectionReference<dynamic> collection() {
    return FirebaseFirestore.instance.collection(collection1);
  }
}

mixin CollectionId2 on CollectionId {
  String get collection1;
  String get document1;
  String get collection2;

  @override
  CollectionReference<dynamic> collection() {
    return FirebaseFirestore.instance
        .collection(collection1)
        .doc(document1)
        .collection(collection2);
  }
}
