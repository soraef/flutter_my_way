This package provides an implementation of the Repository pattern with Firestore as the backend.

## Features

The Repository is a pattern for Entity persistence.
It provides a mixin of operations such as store and get for a single Firestore document.

This package does not provide an implementation that get two or more documents at the same time and maps them to Entity.

CRUD operations on Entity can be easily defined by defining a Repository class with the necessary settings in Usage.

```dart
/// some settings...

class UserRepo extends FireRepoAll {
  @override
  FireRepoConfig<User, UserRepoId, UserCollection> get config => userRepoConfig;
}

void main() {
  final repo = UserRepo();
  repo.store(user);
  repo.get(UserRepoId("userId"));
  repo.list(UserCollection());
  repo.delete(user);

  // query
  repo.query(
    UserCollection(),
    (collection) => collection.where("name", isEqualTo: "soraef"),
  );

  // query cursor for infinity loading
  // get the entities of limit from the next of afterId.
  repo.queryCursor(
    collectionPath: UserCollection(),
    where: (collection) => collection.orderBy("createdAt"),
    limit: 10,
    afterId: null,
  );
}
```

## Getting started

```
flutter pub add fire_repo
```

## Usage
Implement Repository for the `User` class stored in the `/users/{userId}` document and the `Todo` class stored in the `/users/{userId}/todos/{todoId}` document.

### UserRepository
次のようなUserクラスのRepositoryを作成する場合を考えます。
Firestoreでは`/users/{userId}`のパスに`User`を保存することにします。
```dart
class User {
  final String id;
  final String name;

  User(this.id, this.name);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["id"], json["name"]);
  }

  Map<String, dynamic> get toJson => {
        "id": id,
        "name": name,
      };
}
```
#### 1. UserCollectionを定義する　
`FireCollection`を継承した`UserCollection`を作成します。
このクラスは`User`がFirestoreの`/users`以下に保存されることを定義します。
```dart
class UserCollection extends FireCollection {
  UserCollection()
      : super(
          collectionIds: CollectionIds(["users"]),
          documentIds: DocumentIds([]),
        );
}
```

#### 2. UserRepoIdを定義する
次に、`FireRepoId`を継承した、`UserRepoId`を定義します。
このクラスはRepositoryからUserを取得するときのIdとして使用します。
内部的には`User`オブジェクトが`/users/{userId}`上に保存されているという情報を保持しています。

```dart

class UserRepoId extends FireRepoId<UserCollection> {
  UserRepoId(
    String id,
  ) : super(id: id, collection: UserCollection());

  factory UserRepoId.fromEntity(User user) {
    return UserRepoId(user.id);
  }
}
```

#### 3. UserRepository用のFireRepoConfigを設定する
UserRepositoryで使用する設定を`userRepoConfig`として定義します。
この`userRepoConfig`は`User`とjsonのマッピングとUserからUserRepoIdへのマッピングを定義します。

```dart
final userRepoConfig = FireRepoConfig<User, UserRepoId, UserCollection>(
  fromJson: User.fromJson,
  toJson: (user) => user.toJson,
  getId: UserRepoId.fromEntity,
);
```

#### 4. UserRepositoryを定義する
```dart
class UserRepo extends FireRepoAll {
  @override
  FireRepoConfig<User, UserRepoId, UserCollection> get config => userRepoConfig;
}
```


### TodoRepository
次のようなTodoクラスのRepositoryを作成する場合を考えます。

```dart
class Todo {
  final String id;
  final String userId;
  final String name;

  Todo(this.id, this.userId, this.name);

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(json["id"], json["userId"], json["name"]);
  }

  Map<String, dynamic> get toJson => {
        "id": id,
        "userId": userId,
        "name": name,
      };
}
```
#### 1. TodoCollectionを定義する　
`FireCollection`を継承した`TodoCollection`を作成します。
このクラスは`Todo`がFirestoreの`/users/{userId}/todos`以下に保存されることを定義します。
```dart
class TodoCollection extends FireCollection {
  TodoCollection({
    required String userId,
  }) : super(
          collectionIds: CollectionIds(["users", "todos"]),
          documentIds: DocumentIds([userId]),
        );
}
```

#### 2. TodoRepoIdを定義する
次に、`FireRepoId`を継承した、`TodoRepoId`を定義します。

```dart

class TodoRepoId extends FireRepoId<TodoCollection> {
  TodoRepoId({
    required String id,
    required String userId,
  }) : super(id: id, collection: TodoCollection(userId: userId));

  factory TodoRepoId.fromEntity(Todo todo) {
    return TodoRepoId(userId: todo.userId, id: todo.id);
  }
}

```

#### 3. TodoRepository用のFireRepoConfigを設定する
```dart
final todoRepoConfig = FireRepoConfig<Todo, TodoRepoId, TodoCollection>(
  fromJson: Todo.fromJson,
  toJson: (user) => user.toJson,
  getId: TodoRepoId.fromEntity,
);
```

#### 4. TodoRepositoryを定義する
今回はmixinを用いて、FireRepoGetのみを実装しました。
`TodoGetRepo`はgetメソッドのみ使うことができるRepositoryにです。
mixinを用いることで、特定の操作のみを行うことのできるRepositoryを定義することができます。

```dart
class TodoGetRepo with FireRepoGet<Todo, TodoRepoId, TodoCollection> {
  @override
  FireRepoConfig<Todo, TodoRepoId, TodoCollection> get config => todoRepoConfig;
}
```


## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.

