import 'package:entity_collection/entity_collection.dart';
import 'package:entity_store/entity_store/store.dart';
import 'package:entity_store/repository/mixin/delete.dart';
import 'package:entity_store/repository/mixin/get.dart';
import 'package:entity_store/repository/mixin/list.dart';
import 'package:entity_store/repository/mixin/save.dart';

mixin RepoGetStore<Id, E extends Entity<Id>>
    implements Store<EntityMap<Id, E>> {
  RepoGet<E, Id> get repoGet;

  /// RepoからEntityを取得して、Storeに保存し、Entityを返す
  Future<E?> get(Id id) async {
    final entity = await repoGet.get(id);
    update((prev) => entity != null ? prev.put(entity) : prev);
    return entity;
  }

  /// StoreにEntityがなければ[get]してEntityを返す
  Future<E?> getUnlessExist(Id id) async {
    final entity = state.byId(id);
    if (entity != null) return entity;
    return await get(id);
  }
}

mixin RepoListStore<Id, E extends Entity<Id>, Params extends ListParams>
    implements Store<EntityMap<Id, E>> {
  RepoList<Params, E> get repoList;

  Future<List<E>> list(Params params) async {
    final entities = await repoList.list(params);
    update((prev) => prev.putAll(entities));
    return entities;
  }
}

mixin RepoSaveStore<EntityId, E extends Entity<EntityId>>
    implements Store<EntityMap<EntityId, E>> {
  RepoSave<E> get repoSave;

  Future<E> save(E entity) async {
    await repoSave.save(entity);
    update((prev) => prev.put(entity));
    return entity;
  }
}

mixin RepoDeleteStore<EntityId, E extends Entity<EntityId>>
    implements Store<EntityMap<EntityId, E>> {
  RepoDelete<E> get repoDelete;

  Future<E> delete(E entity) async {
    await repoDelete.delete(entity);
    update((prev) => prev.removeById(entity.id));
    return entity;
  }
}
