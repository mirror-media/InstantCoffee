class MemberResponse<T> {
  Status status;

  T data;

  String message;

  MemberResponse.loading(this.message) : status = Status.Loading;

  MemberResponse.completed(this.data) : status = Status.Complete;

  MemberResponse.savingLoading(this.data, this.message) : status = Status.SavingLoading;

  MemberResponse.savingSuccessfully(this.data) : status = Status.SavingSuccessfully;

  MemberResponse.savingError(this.data, this.message) : status = Status.SavingError;

  MemberResponse.error(this.message) : status = Status.Error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { 
  Loading, 
  Complete,
  SavingLoading,
  SavingSuccessfully,
  SavingError,
  Error,
}
