class MemberResponse<T> {
  Status status;

  T data;

  String message;

  MemberResponse.completed(this.data) : status = Status.Complete;

  MemberResponse.savingLoading(this.data, this.message) : status = Status.SavingLoading;

  MemberResponse.savingSuccessfully(this.data) : status = Status.SavingSuccessfully;

  MemberResponse.savingError(this.data, this.message) : status = Status.SavingError;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { 
  Complete,
  SavingLoading,
  SavingSuccessfully,
  SavingError,
}
