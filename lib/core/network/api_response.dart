
sealed class ApiResponse<T> {
  const ApiResponse();
}

class ApiLoading<T> extends ApiResponse<T> {
  const ApiLoading();
}

class ApiSuccess<T> extends ApiResponse<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiError<T> extends ApiResponse<T> {
  final String message;
  final dynamic error;
  final int? statusCode;

  const ApiError({
    required this.message,
    this.error,
    this.statusCode,
  });
}