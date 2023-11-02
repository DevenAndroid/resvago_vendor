class BankData {
  final dynamic bankName;
  final dynamic bankAccountNumber;
  final dynamic accountHolderName;
  final dynamic ifscCode;
  final dynamic? docid;
  final dynamic? userID;


  BankData(
      {required this.bankName,
        this.bankAccountNumber,
        this.accountHolderName,
        this.ifscCode,
        this.userID,
        this.docid});

  Map<String, dynamic> toMap() {
    return {
      'bankName': bankName,
      'bankAccountNumber': bankAccountNumber,
      'accountHolderName': accountHolderName,
      'ifscCode': ifscCode,
      'userID': userID,
      'docid': docid,
    };
  }

  factory BankData.fromMap(Map<String, dynamic> map) {
    return BankData(
      bankName: map['bankName'],
      bankAccountNumber: map['bankAccountNumber'],
      accountHolderName: map['accountHolderName'],
      ifscCode: map['ifscCode'],
      userID: map['userID'],
      docid: map['docid'],
    );
  }
}
