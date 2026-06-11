class SignupState {
  bool isLoading;
  bool isSuccess;
  String? message;
  int? code;

  SignupState({required this.isLoading, required this.isSuccess, this.message, this.code});

  SignupState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
    int? code,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      code: code ?? this.code,
    );
  }

  SignupState empty(){
    return SignupState(isLoading: false, isSuccess: false, message: null);
  }
}
