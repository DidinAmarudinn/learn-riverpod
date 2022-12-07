import 'package:freezed_annotation/freezed_annotation.dart';
part 'request_pagnation_state.freezed.dart';
@freezed
abstract class RequestPagnationState<T> with _$RequestPagnationState<T> {
  const factory RequestPagnationState.data(List<T> items) = _Data;
  const factory RequestPagnationState.loading() = _Loading;
  const factory RequestPagnationState.error(String message) = _Error;
  const factory RequestPagnationState.onGoingLoading(List<T> items) = _OnGoingLoading;
  const factory RequestPagnationState.onGoingError(List<T> items, String error) = _OnGoingError;
}
