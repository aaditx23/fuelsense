class LoginState {
  bool isLoading = false;
  bool isSuccess = false;
  String? message;
  int? code;

  LoginState({required this.isLoading, required this.isSuccess, this.message, int? code});

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
    int? code,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      code: code ?? this.code
    );
  }

  LoginState empty(){
   return LoginState(isLoading: false, isSuccess: false);
  }
}
