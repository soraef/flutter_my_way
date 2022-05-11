import 'package:fire_repo/fire_repo.dart';

abstract class RepoGet<R, RepoId> {
  Future<R?> get(RepoId id);
}

mixin FireRepoGet<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements FireRepo<T, Id, C>, RepoGet<T, Id> {
  @override
  Future<T?> get(Id id) async {
    final doc = await config.doc(id).get();
    return doc.data();
  }
}
