class ApiResponse {
  dynamic result;
  bool isSuccess;
  String? message;
  int? statusCode;
  Map<String, dynamic>? formErrors;
  bool isFileUpload;
  int uploadProgress;
  bool progressStarted;

  ApiResponse(
      {required this.result,
      required this.isSuccess,
      required this.statusCode,
      this.message = '',
      this.formErrors,
      this.isFileUpload = false,
      this.progressStarted = false,
      this.uploadProgress = 0});
}
