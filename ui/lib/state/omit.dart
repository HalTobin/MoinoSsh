import 'dart:async';

/// Defaulted<T> is a type alias defined as:
typedef Defaulted<T> = FutureOr<T>;

/// Omit is a sentinel class that implements Future<T>:
/// (`Omit`) that means "don't change this field"
final class Omit<T> implements Future<T> {
    const Omit();

    @override
    dynamic noSuchMethod(Invocation invocation) {
        return super.noSuchMethod(invocation);
    }
}