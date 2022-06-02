import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_repo/fire_repo.dart';

abstract class RepoSave<T> {
  Future<void> save(T entity);
}

mixin FireRepoSave<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements FireRepo<T, Id, C>, RepoSave<T> {
  @override
  Future<void> save(T entity) async {
    await config.entityDoc(entity).set(entity, SetOptions(merge: true));
  }
}
