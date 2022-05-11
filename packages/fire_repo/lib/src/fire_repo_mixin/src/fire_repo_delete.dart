import 'package:fire_repo/fire_repo.dart';

abstract class RepoDelete<T> {
  Future<void> delete(T entity);
}

mixin FireRepoDelete<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements FireRepo<T, Id, C>, RepoDelete<T> {
  @override
  Future<void> delete(T entity) async {
    await config.entityDoc(entity).delete();
  }
}
