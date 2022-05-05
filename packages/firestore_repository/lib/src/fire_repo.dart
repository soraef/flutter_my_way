import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_repository/src/repo_config.dart';
import 'package:firestore_repository/src/repo_id.dart';

abstract class FireRepo<Id extends FireRepoId, T> {
  final RepoConfig<Id, T> config;

  FireRepo(this.config);
}

abstract class FireRepoAll<Id extends FireRepoId, T>
    with
        FireRepoGet<Id, T>,
        FireRepoGetStream<Id, T>,
        FireRepoList<Id, T>,
        FireRepoStore<Id, T>,
        FireRepoDelete<Id, T> {}

abstract class FireRepoRead<Id extends FireRepoId, T>
    with FireRepoGet<Id, T>, FireRepoGetStream<Id, T>, FireRepoList<Id, T> {}

abstract class FireRepoWrite<Id extends FireRepoId, T>
    with FireRepoStore<Id, T>, FireRepoDelete<Id, T> {}

mixin FireRepoGet<Id extends FireRepoId, T> implements FireRepo<Id, T> {
  Future<T?> get(Id id) async {
    final doc = await config.doc(id).get();
    return doc.data();
  }
}

mixin FireRepoDelete<Id extends FireRepoId, T> implements FireRepo<Id, T> {
  Future<void> delete(T entity) async {
    await config.entityDoc(entity).delete();
  }
}

mixin FireRepoGetStream<Id extends FireRepoId, T> implements FireRepo<Id, T> {
  Stream<T> getStream(Id id) {
    return config
        .doc(id)
        .snapshots()
        .map((doc) => doc.data())
        .where((e) => e != null)
        .map((e) => e!);
  }
}

mixin FireRepoList<Id extends FireRepoId, T> implements FireRepo<Id, T> {
  Future<List<T>> list(CollectionPath collectionPath) async {
    final snapshot = await config.collection(collectionPath).get();
    return snapshot.docs.map((e) => e.data()).whereType<T>().toList();
  }
}

mixin FireRepoStore<Id extends FireRepoId, T> implements FireRepo<Id, T> {
  Future<void> store(T entity) async {
    await config.entityDoc(entity).set(entity, SetOptions(merge: true));
  }
}
