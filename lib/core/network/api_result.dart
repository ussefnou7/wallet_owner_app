import '../errors/app_failure.dart';

sealed class ApiResult<T> {
  const ApiResult();

  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure failure) failure,
  });
}

class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);

  final T data;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure failure) failure,
  }) {
    return success(data);
  }
}

class ApiError<T> extends ApiResult<T> {
  const ApiError(this.error);

  final AppFailure error;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure failure) failure,
  }) {
    return failure(error);
  }
}
