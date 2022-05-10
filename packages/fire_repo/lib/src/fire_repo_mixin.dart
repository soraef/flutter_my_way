import 'package:cloud_firestore/cloud_firestore.dart';

import 'fire_collection.dart';
import 'fire_repo.dart';
import 'fire_repo_id.dart';

abstract class FireRepoAll<T, Id extends FireRepoId<C>,
        C extends FireCollection>
    with
        FireRepoGet<T, Id, C>,
        FireRepoQuery<T, Id, C>,
        FireRepoQueryCursors<T, Id, C>,
        FireRepoGetStream<T, Id, C>,
        FireRepoList<T, Id, C>,
        FireRepoStore<T, Id, C>,
        FireRepoDelete<T, Id, C> {}

abstract class FireRepoRead<T, Id extends FireRepoId<C>,
        C extends FireCollection>
    with
        FireRepoGet<T, Id, C>,
        FireRepoQuery<T, Id, C>,
        FireRepoQueryCursors<T, Id, C>,
        FireRepoGetStream<T, Id, C>,
        FireRepoList<T, Id, C> {}

abstract class FireRepoWrite<T, Id extends FireRepoId<C>,
        C extends FireCollection>
    with FireRepoStore<T, Id, C>, FireRepoDelete<T, Id, C> {}

mixin FireRepoGet<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements FireRepo<T, Id, C> {
  Future<T?> get(Id id) async {
    final doc = await config.doc(id).get();
    return doc.data();
  }
}

mixin FireRepoDelete<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements FireRepo<T, Id, C> {
  Future<void> delete(T entity) async {
    await config.entityDoc(entity).delete();
  }
}

mixin FireRepoGetStream<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements FireRepo<T, Id, C> {
  Stream<T> getStream(Id id) {
    return config
        .doc(id)
        .snapshots()
        .map((doc) => doc.data())
        .where((e) => e != null)
        .map((e) => e!);
  }
}

mixin FireRepoList<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements FireRepo<T, Id, C> {
  Future<List<T>> list(C collectionPath) async {
    final snapshot = await config.collection(collectionPath).get();
    return snapshot.docs.map((e) => e.data()).whereType<T>().toList();
  }
}

mixin FireRepoStore<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements FireRepo<T, Id, C> {
  Future<void> store(T entity) async {
    await config.entityDoc(entity).set(entity, SetOptions(merge: true));
  }
}

typedef FireRepoWhere<T> = Query<T?> Function(
    CollectionReference<T?> collection);

mixin FireRepoQuery<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements FireRepo<T, Id, C> {
  Future<List<T>> query(
    C collectionPath,
    FireRepoWhere where,
  ) async {
    final colRef = config.collection(collectionPath);
    final snapshot = await where(colRef).get();

    return snapshot.docs.map((e) => e.data()).whereType<T>().toList();
  }
}

mixin FireRepoQueryCursors<T, Id extends FireRepoId<C>,
    C extends FireCollection> implements FireRepo<T, Id, C> {
  Future<List<T>> queryCursor({
    required C collectionPath,
    required FireRepoWhere where,
    required int limit,
    required Id? afterId,
  }) async {
    final colRef = config.collection(collectionPath);
    var query = where(colRef);

    if (afterId != null) {
      query = query.startAfterDocument(await config.doc(afterId).get());
    }
    final snapshot = await query.limit(limit).get();
    return snapshot.docs.map((e) => e.data()).whereType<T>().toList();
  }
}
