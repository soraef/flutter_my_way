import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entity_store/repository/firestore_repo.dart';
import 'package:entity_store/repository/id.dart';

abstract class RepoSave<T> {
  Future<void> save(T entity);
}

mixin FireRepoSave<T, Id extends FirestoreId>
    implements FirestoreRepo<T, Id>, RepoSave<T> {
  @override
  Future<void> save(T entity) async {
    await converter.entityDoc(entity).set(entity, SetOptions(merge: true));
  }
}
