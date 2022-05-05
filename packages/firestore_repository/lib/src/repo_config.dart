import 'package:cloud_firestore/cloud_firestore.dart';

import 'repo_id.dart';

class RepoConfig<Id extends FireRepoId, T> {
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final Id Function(T) getId;
  final Id example;

  RepoConfig({
    required this.fromJson,
    required this.toJson,
    required this.getId,
    required this.example,
  });

  CollectionReference<T?> collection() {
    return collectionWithoutConverter().withConverter(
      fromFirestore: (snapshot, _) {
        final data = snapshot.data();
        if (data != null) return fromJson(data);
        return null;
      },
      toFirestore: (data, _) => data != null ? toJson(data) : {},
    );
  }

  CollectionReference<dynamic> collectionWithoutConverter() {
    CollectionReference<dynamic>? _collection;

    for (var i = 0; i < example.collectionIds.length; i++) {
      if (_collection == null) {
        _collection =
            FirebaseFirestore.instance.collection(example.collectionIds[i]);
      } else {
        _collection = _collection
            .doc(example.documentIds[i - 1])
            .collection(example.collectionIds[i]);
      }
    }

    return _collection!;
  }

  DocumentReference<T?> doc(FireRepoId id) {
    return collection().doc(id.docId);
  }

  DocumentReference<dynamic> docWithoutConverter(FireRepoId id) {
    return collectionWithoutConverter().doc(id.docId);
  }

  DocumentReference<T?> entityDoc(T entity) {
    final id = getId(entity);
    return collection().doc(id.docId);
  }
}
