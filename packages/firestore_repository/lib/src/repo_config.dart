import 'package:cloud_firestore/cloud_firestore.dart';

import 'repo_id.dart';

class RepoConfig<Id extends FireRepoId, T> {
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final Id Function(T) getId;

  RepoConfig({
    required this.fromJson,
    required this.toJson,
    required this.getId,
  });

  CollectionReference<T?> collection(CollectionPath collectionPath) {
    return collectionWithoutConverter(collectionPath).withConverter(
      fromFirestore: (snapshot, _) {
        final data = snapshot.data();
        if (data != null) return fromJson(data);
        return null;
      },
      toFirestore: (data, _) => data != null ? toJson(data) : {},
    );
  }

  CollectionReference<dynamic> collectionWithoutConverter(
    CollectionPath collectionPath,
  ) {
    CollectionReference<dynamic>? _collection;

    for (var i = 1; i <= collectionPath.collectionIds.length; i++) {
      if (_collection == null) {
        _collection = FirebaseFirestore.instance
            .collection(collectionPath.collectionIds.getString(i));
      } else {
        _collection = _collection
            .doc(collectionPath.documentIds.getString(i - 1))
            .collection(collectionPath.collectionIds.getString(i));
      }
    }

    return _collection!;
  }

  DocumentReference<T?> doc(Id id) {
    return collection(id.path).doc(id.docId);
  }

  DocumentReference<dynamic> docWithoutConverter(Id id) {
    return collectionWithoutConverter(id.path).doc(id.docId);
  }

  DocumentReference<T?> entityDoc(T entity) {
    final id = getId(entity);
    return collection(id.path).doc(id.docId);
  }
}
