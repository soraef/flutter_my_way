import 'fire_collection.dart';

abstract class RepoId {}

abstract class FireRepoId<Collection extends FireCollection> implements RepoId {
  final String id;
  final Collection collection;

  FireRepoId({
    required this.id,
    required this.collection,
  });
}
