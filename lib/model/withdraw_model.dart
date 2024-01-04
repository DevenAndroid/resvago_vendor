class WithdrawMoneyModel {
  dynamic amount;
  dynamic time;
  String? userId;
  String? status;
  dynamic docid;

  WithdrawMoneyModel({this.amount, this.time, this.userId, this.status,this.docid});

  WithdrawMoneyModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    time = json['time'];
    userId = json['userId'];
    status = json['status'];
    docid = json['docid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['time'] = this.time;
    data['userId'] = this.userId;
    data['status'] = this.status;
    data['docid'] = this.docid;
    return data;
  }
}
