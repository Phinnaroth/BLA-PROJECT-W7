enum AsyncValueStatus { loading, success, error }

class AsyncValue<T> {
  final T? data;
  final Object? error;
  final AsyncValueStatus status;

  AsyncValue._({this.data, this.error, required this.status});

  AsyncValue.loading() : this._(status: AsyncValueStatus.loading);
  AsyncValue.success(T data) : this._(status: AsyncValueStatus.success, data: data);
  AsyncValue.error(Object error) : this._(status: AsyncValueStatus.error, error: error);

  bool get isloading => status == AsyncValueStatus.loading;
  bool get isSuccess => status == AsyncValueStatus.success;
  bool get isError => status == AsyncValueStatus.error;
}