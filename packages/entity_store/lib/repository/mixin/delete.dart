import 'package:entity_store/repository/firestore_repo.dart';
import 'package:entity_store/repository/id.dart';

abstract class RepoDelete<T> {
  Future<void> delete(T entity);
}

mixin FireRepoDelete<T, Id extends FirestoreId>
    implements FirestoreRepo<T, Id>, RepoDelete<T> {
  @override
  Future<void> delete(T entity) async {
    await converter.entityDoc(entity).delete();
  }
}
