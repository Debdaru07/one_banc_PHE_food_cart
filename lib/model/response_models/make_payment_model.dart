class MakePaymentResponseModel {
  int? responseCode;
  int? outcomeCode;
  String? responseMessage;
  String? errorDetails;
  String? timestamp;
  String? requesterIp;
  String? timetaken;
  String? taxRefNumber;

  MakePaymentResponseModel(
      {this.responseCode,
      this.outcomeCode,
      this.responseMessage,
      this.errorDetails,
      this.timestamp,
      this.requesterIp,
      this.timetaken,
      this.taxRefNumber});

  MakePaymentResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    outcomeCode = json['outcome_code'];
    responseMessage = json['response_message'];
    errorDetails = json['error_details'];
    timestamp = json['timestamp'];
    requesterIp = json['requester_ip'];
    timetaken = json['timetaken'];
    taxRefNumber = json['txn_ref_no'];
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
    data['txn_ref_no'] = taxRefNumber;
    return data;
  }
}
