import 'package:cloud_firestore/cloud_firestore.dart';

import 'fire_collection.dart';
import 'fire_repo_id.dart';

class FireRepoConfig<T, Id extends FireRepoId<C>, C extends FireCollection> {
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final Id Function(T) getId;

  FireRepoConfig({
    required this.fromJson,
    required this.toJson,
    required this.getId,
  });

  CollectionReference<T?> collection(C collectionPath) {
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
    FireCollection collectionPath,
  ) {
    CollectionReference<dynamic>? _collection;

    for (var i = 0; i < collectionPath.collectionIds.length; i++) {
      if (_collection == null) {
        _collection = FirebaseFirestore.instance
            .collection(collectionPath.collectionIds.values[i]);
      } else {
        _collection = _collection
            .doc(collectionPath.documentIds.values[i - 1])
            .collection(collectionPath.collectionIds.values[i]);
      }
    }

    return _collection!;
  }

  DocumentReference<T?> doc(Id repoId) {
    return collection(repoId.collection).doc(repoId.id);
  }

  DocumentReference<dynamic> docWithoutConverter(Id repoId) {
    return collectionWithoutConverter(repoId.collection).doc(repoId.id);
  }

  DocumentReference<T?> entityDoc(T entity) {
    final repoId = getId(entity);
    return collection(repoId.collection).doc(repoId.id);
  }
}
