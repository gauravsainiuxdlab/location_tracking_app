abstract class DataState<T> {
  final T? data;
  final String? error;
  final int? errorCode;

  const DataState({this.data, this.error, this.errorCode});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T? data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed({super.error, super.errorCode});
}
