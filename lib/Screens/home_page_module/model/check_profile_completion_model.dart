class CheckProfileCompletionModel {
  bool? status;
  String? message;
  bool? isComplete;
  int? completionPercentage;

  CheckProfileCompletionModel(
      {this.status, this.message, this.isComplete, this.completionPercentage});

  CheckProfileCompletionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isComplete = json['isComplete'];
    completionPercentage = json['completionPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['isComplete'] = isComplete;
    data['completionPercentage'] = completionPercentage;
    return data;
  }
}
