import 'package:entity_collection/entity_collection.dart';
import 'package:fire_repo/fire_repo.dart';

typedef Updater<T> = T Function(T prev);

abstract class Store<T> {
  T get state;
  void update(Updater<T> updater);
}

mixin EntityStore<Id, E extends Entity<Id>> implements Store<EntityMap<Id, E>> {
  void put(E entity) {
    update((prev) => prev.put(entity));
  }

  void putAll(Iterable<E> entities) {
    update((prev) => prev.putAll(entities));
  }

  void remove(E entity) {
    update((prev) => prev.remove(entity));
  }

  void removeById(E entity) {
    update((prev) => prev.removeById(entity.id));
  }
}

mixin RepoGetStore<EntityId, E extends Entity<EntityId>, Id extends RepoId>
    implements Store<EntityMap<EntityId, E>> {
  RepoGet<E, Id> get repo;
  Id Function(EntityId) get fromEntityId;

  /// RepoからEntityを取得して、Storeに保存し、Entityを返す
  Future<E?> get(EntityId id) async {
    final entity = await repo.get(fromEntityId(id));
    update((prev) => entity != null ? prev.put(entity) : prev);
    return entity;
  }

  /// StoreにEntityがなければ[get]してEntityを返す
  Future<E?> getUnlessExist(EntityId id) async {
    final entity = state.byId(id);
    if (entity != null) return entity;
    return await get(id);
  }
}

mixin RepoListStore<Id, E extends Entity<Id>, P extends ListParams>
    implements Store<EntityMap<Id, E>> {
  RepoList<P, E> get repo;

  Future<List<E>> list(P params) async {
    final entities = await repo.list(params);
    update((prev) => prev.putAll(entities));
    return entities;
  }
}

mixin RepoSaveStore<EntityId, E extends Entity<EntityId>>
    implements Store<EntityMap<EntityId, E>> {
  RepoSave<E> get repo;

  Future<E> save(E entity) async {
    await repo.save(entity);
    update((prev) => prev.put(entity));
    return entity;
  }
}

mixin RepoDeleteStore<EntityId, E extends Entity<EntityId>, Id extends RepoId>
    implements Store<EntityMap<EntityId, E>> {
  RepoDelete<E> get repo;

  Future<E> delete(E entity) async {
    await repo.delete(entity);
    update((prev) => prev.removeById(entity.id));
    return entity;
  }
}

// abstract class RepoStore<EntityId, E extends Entity<EntityId>,
//         Id extends RepoId, P extends ListParams>
//     with RepoGetStore<EntityId, E, RepoId>, RepoListStore<EntityId, E, P>
//     implements Store<EntityMap<EntityId, E>> {
      
//     }
