import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_repo/fire_repo.dart';

abstract class RepoStore<T> {
  Future<void> store(T entity);
}

mixin FireRepoStore<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements FireRepo<T, Id, C>, RepoStore<T> {
  @override
  Future<void> store(T entity) async {
    await config.entityDoc(entity).set(entity, SetOptions(merge: true));
  }
}
