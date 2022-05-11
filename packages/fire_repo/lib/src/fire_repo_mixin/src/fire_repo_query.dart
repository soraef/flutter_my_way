import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_repo/fire_repo.dart';

abstract class QueryParams {}

abstract class RepoQuery<P extends QueryParams, R> {
  Future<List<R>> query(P params);
}

class FireQueryParams<C extends FireCollection> implements QueryParams {
  final C collection;
  final FireRepoWhere where;

  FireQueryParams({
    required this.collection,
    required this.where,
  });
}

typedef FireRepoWhere<T> = Query<T?> Function(
    CollectionReference<T?> collection);

mixin FireRepoQuery<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements FireRepo<T, Id, C>, RepoQuery<FireQueryParams<C>, T> {
  @override
  Future<List<T>> query(FireQueryParams<C> params) async {
    final colRef = config.collection(params.collection);
    final snapshot = await params.where(colRef).get();

    return snapshot.docs.map((e) => e.data()).whereType<T>().toList();
  }
}
