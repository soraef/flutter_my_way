abstract class Result<V, E> {
  /// return true if result is ok
  bool get isOk => this is Ok<V, E>;

  /// return true if result is error
  bool get isErr => this is Err<V, E>;

  /// return [Ok] value if result is ok
  V? get ok => isOk ? (this as Ok<V, E>).value : null;

  /// return [Err] value if return is err
  E? get err => isErr ? (this as Err<V, E>).value : null;

  Result<U, E> mapOk<U>(U Function(V ok) transform) {
    return okThen((ok) => Ok(transform(ok)));
  }

  Result<V, U> mapErr<U>(U Function(E err) transform) {
    return errThen((err) => Err(transform(err)));
  }

  /// return new result value
  /// transform [Ok] value if result is ok
  /// return this if result is err
  Result<U, E> okThen<U>(Result<U, E> Function(V ok) transform) {
    if (isOk) {
      return transform(ok!);
    } else {
      return Err(err!);
    }
  }

  Result<V, U> errThen<U>(Result<V, U> Function(E err) transform) {
    if (isErr) {
      return transform(err!);
    } else {
      return Ok(ok!);
    }
  }

  V okOr(V defaultValue) {
    return isOk ? ok! : defaultValue;
  }

  E errOr(E defaultErr) {
    return isErr ? err! : defaultErr;
  }

  void when({
    required Function(V value) ok,
    required Function(E error) err,
  }) {
    if (isOk) {
      ok(this.ok!);
    } else {
      err(this.err!);
    }
  }

  U fold<U>({
    required U Function(V ok) ok,
    required U Function(E err) err,
  }) {
    if (isOk) {
      return ok(this.ok!);
    } else {
      return err(this.err!);
    }
  }
}

class Ok<V, E> extends Result<V, E> {
  final V value;
  Ok(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ok<V, E> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Ok($value)';
}

class Err<V, E> extends Result<V, E> {
  final E value;
  Err(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ok<V, E> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Err($value)';
}
