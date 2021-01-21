class DeleteResponse<T> {
  Status status;

  T data;

  String message;

  DeleteResponse.completed(this.data) : status = Status.Complete;

  DeleteResponse.deletingLoading() : status = Status.DeletingLoading;

  DeleteResponse.deletingSuccessfully() : status = Status.DeletingSuccessfully;

  DeleteResponse.deletingError(this.message) : status = Status.DeletingError;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { 
  Complete,
  DeletingLoading,
  DeletingSuccessfully,
  DeletingError,
}
