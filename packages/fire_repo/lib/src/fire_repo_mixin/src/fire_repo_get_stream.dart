import 'package:fire_repo/fire_repo.dart';

abstract class RepoGetStream<R, Id extends RepoId> {
  Stream<R> getStream(Id id);
}

mixin FireRepoGetStream<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements FireRepo<T, Id, C>, RepoGetStream<T, Id> {
  @override
  Stream<T> getStream(Id id) {
    return config
        .doc(id)
        .snapshots()
        .map((doc) => doc.data())
        .where((e) => e != null)
        .map((e) => e!);
  }
}
