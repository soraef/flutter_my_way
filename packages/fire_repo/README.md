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
  final user = User("userId", "soraef");
  final repo = UserRepo();

  repo.store(user);
  repo.get(UserRepoId("userId"));
  repo.list(FireListParams(collection: UserCollection(), limit: 10));
  repo.delete(user);

  // query
  repo.query(
    FireQueryParams(
      collection: UserCollection(),
      where: (collection) => collection.where("name", isEqualTo: "soraef"),
    ),
  );

  // query cursor for infinity loading
  // get the entities of limit from the next of afterId.
  repo.queryCursor(
    FireQueryCoursorParams(
      collection: UserCollection(),
      where: (collection) => collection.orderBy("createdAt").limit(10),
    ),
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
Consider the following case of creating a Repository for the User class.
In Firestore, we want to store `User` in the path `/users/{userId}`.
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
#### 1.Define UserCollection　
Create a `UserCollection` that extends `FireCollection`.
This class defines that `User` will be stored under `/users` in the Firestore.
```dart
class UserCollection extends FireCollection {
  UserCollection()
      : super(
          collectionIds: CollectionIds(["users"]),
          documentIds: DocumentIds([]),
        );
}
```

#### 2. Define UserRepoId
Next, define `UserRepoId`, which extends `FireRepoId`.
This class is used as the Id when getting User from Repository.
Internally, it holds the information that the `User` object is stored on `/users/{userId}`.

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

#### 3. Configure FireRepoConfig for UserRepository
Define the settings used by UserRepository as `userRepoConfig`.
This `userRepoConfig` defines the mapping between `User` and json and from User to UserRepoId.

```dart
final userRepoConfig = FireRepoConfig<User, UserRepoId, UserCollection>(
  fromJson: User.fromJson,
  toJson: (user) => user.toJson,
  getId: UserRepoId.fromEntity,
);
```

#### 4. Define UserRepository
```dart
class UserRepo extends FireRepoAll {
  @override
  FireRepoConfig<User, UserRepoId, UserCollection> get config => userRepoConfig;
}
```

### TodoRepository
Consider the case of creating a Repository for a Todo class that will be stored in the second level of the Firestore, such as `/users/{userId}/todos/{todoId}`.

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

class TodoCollection extends FireCollection {
  TodoCollection({
    required String userId,
  }) : super(
          collectionIds: CollectionIds(["users", "todos"]),
          documentIds: DocumentIds([userId]),
        );
}

class TodoRepoId extends FireRepoId<TodoCollection> {
  TodoRepoId({
    required String id,
    required String userId,
  }) : super(id: id, collection: TodoCollection(userId: userId));

  factory TodoRepoId.fromEntity(Todo todo) {
    return TodoRepoId(userId: todo.userId, id: todo.id);
  }
}

final todoRepoConfig = FireRepoConfig<Todo, TodoRepoId, TodoCollection>(
  fromJson: Todo.fromJson,
  toJson: (user) => user.toJson,
  getId: TodoRepoId.fromEntity,
);
```

In this case, we used mixin to implement only FireRepoGet.
The `TodoGetRepo` is a Repository that can be used only with the get method.
By using mixin, you can define a Repository that can only perform specific operations.

```dart
class TodoGetRepo with FireRepoGet<Todo, TodoRepoId, TodoCollection> {
  @override
  FireRepoConfig<Todo, TodoRepoId, TodoCollection> get config => todoRepoConfig;
}
```


