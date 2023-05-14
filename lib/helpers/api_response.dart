class ApiResponse<T> {
  Status status;

  T? data;

  String? message;

  ApiResponse.loading(this.message) : status = Status.LOADING;

  ApiResponse.loadingMore(this.message) : status = Status.LOADINGMORE;

  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

// ignore: constant_identifier_names
enum Status { LOADING, LOADINGMORE, COMPLETED, ERROR }
