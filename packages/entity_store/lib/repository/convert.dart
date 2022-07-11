import 'package:cloud_firestore/cloud_firestore.dart';

import 'id.dart';

class RepoConverter<E, Id extends FirestoreId> {
  final E Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(E) toJson;
  final Id Function(E) getId;

  RepoConverter({
    required this.fromJson,
    required this.toJson,
    required this.getId,
  });

  CollectionReference<E?> collection(CollectionId collectionId) {
    return collectionId.collection().withConverter(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data != null) return fromJson(data);
            return null;
          },
          toFirestore: (data, _) => data != null ? toJson(data) : {},
        );
  }

  DocumentReference<E?> doc(Id id) {
    return collection(id.collectionId).doc();
  }

  DocumentReference<E?> entityDoc(E entity) {
    final id = getId(entity);
    return doc(id);
  }
}
