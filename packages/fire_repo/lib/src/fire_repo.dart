import 'fire_collection.dart';
import 'fire_repo_id.dart';
import 'fire_repo_mixin/fire_repo_mixin.dart';
import 'fire_repo_config.dart';

abstract class FireRepo<T, Id extends FireRepoId<C>, C extends FireCollection> {
  final FireRepoConfig<T, Id, C> config;

  FireRepo(this.config);
}

abstract class FireRepoAll<T, Id extends FireRepoId<C>,
        C extends FireCollection>
    with
        FireRepoGet<T, Id, C>,
        FireRepoQuery<T, Id, C>,
        FireRepoQueryCursor<T, Id, C>,
        FireRepoGetStream<T, Id, C>,
        FireRepoList<T, Id, C>,
        FireRepoSave<T, Id, C>,
        FireRepoDelete<T, Id, C> {}

abstract class FireRepoRead<T, Id extends FireRepoId<C>,
        C extends FireCollection>
    with
        FireRepoGet<T, Id, C>,
        FireRepoQuery<T, Id, C>,
        FireRepoQueryCursor<T, Id, C>,
        FireRepoGetStream<T, Id, C>,
        FireRepoList<T, Id, C> {}

abstract class FireRepoWrite<T, Id extends FireRepoId<C>,
        C extends FireCollection>
    with FireRepoSave<T, Id, C>, FireRepoDelete<T, Id, C> {}
