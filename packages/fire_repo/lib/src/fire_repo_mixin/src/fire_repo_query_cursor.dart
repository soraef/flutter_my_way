import 'package:fire_repo/fire_repo.dart';

import 'fire_repo_query.dart';

abstract class QueryCursorParams {}

abstract class RepoQueryCursor<P extends QueryCursorParams, R> {
  Future<List<R>> queryCursor(P params);
}

class FireQueryCoursorParams<Id extends FireRepoId<C>, C extends FireCollection>
    implements QueryCursorParams {
  final C collection;
  final FireRepoWhere where;
  final Id? afterId;

  FireQueryCoursorParams({
    required this.collection,
    required this.where,
    this.afterId,
  });
}

mixin FireRepoQueryCursor<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements
        FireRepo<T, Id, C>,
        RepoQueryCursor<FireQueryCoursorParams<Id, C>, T> {
  @override
  Future<List<T>> queryCursor(FireQueryCoursorParams<Id, C> params) async {
    final colRef = config.collection(params.collection);
    var query = params.where(colRef);

    if (params.afterId != null) {
      query = query.startAfterDocument(await config.doc(params.afterId!).get());
    }

    final snapshot = await query.get();
    return snapshot.docs.map((e) => e.data()).whereType<T>().toList();
  }
}
