import '../errors/app_exception.dart';

sealed class ApiResult<T> {
  const ApiResult();

  R when<R>({
    required R Function(T data) success,
    required R Function(AppException failure) failure,
  });
}

class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);

  final T data;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException failure) failure,
  }) {
    return success(data);
  }
}

class ApiError<T> extends ApiResult<T> {
  const ApiError(this.error);

  final AppException error;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException failure) failure,
  }) {
    return failure(error);
  }
}
