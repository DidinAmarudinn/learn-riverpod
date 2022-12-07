import 'package:fpdart/fpdart.dart';
import 'package:journal_riverpod/reddit_clone/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
