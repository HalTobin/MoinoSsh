sealed class ResponseResult<T> {}

class ResponseSucceed<T> extends ResponseResult<T> {
    final T data;
    ResponseSucceed(this.data);
}

class ResponseFailed<T> extends ResponseResult<T> {
    final String error;
    ResponseFailed({required this.error});
}