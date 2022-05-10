import 'fire_collection.dart';
import 'fire_repo_id.dart';
import 'repo_config.dart';

abstract class FireRepo<T, Id extends FireRepoId<C>, C extends FireCollection> {
  final FireRepoConfig<T, Id, C> config;

  FireRepo(this.config);
}
