class MakePaymentResponseModel {
  int? responseCode;
  int? outcomeCode;
  String? responseMessage;
  String? errorDetails;
  String? timestamp;
  String? requesterIp;
  String? timetaken;

  MakePaymentResponseModel(
      {this.responseCode,
      this.outcomeCode,
      this.responseMessage,
      this.errorDetails,
      this.timestamp,
      this.requesterIp,
      this.timetaken});

  MakePaymentResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    outcomeCode = json['outcome_code'];
    responseMessage = json['response_message'];
    errorDetails = json['error_details'];
    timestamp = json['timestamp'];
    requesterIp = json['requester_ip'];
    timetaken = json['timetaken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['outcome_code'] = this.outcomeCode;
    data['response_message'] = this.responseMessage;
    data['error_details'] = this.errorDetails;
    data['timestamp'] = this.timestamp;
    data['requester_ip'] = this.requesterIp;
    data['timetaken'] = this.timetaken;
    return data;
  }
}
