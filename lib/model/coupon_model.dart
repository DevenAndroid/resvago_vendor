class CouponData {
  final dynamic promoCodeName;
  final dynamic code;
  final dynamic discount;
  final dynamic valetedDate;
  final dynamic? docid;

  CouponData(
      {required this.promoCodeName,
      this.code,
      this.discount,
      this.valetedDate,
      this.docid});

  Map<String, dynamic> toMap() {
    return {
      'promoCodeName': promoCodeName,
      'code': code,
      'discount': discount,
      'valetedDate': valetedDate,
      'docid': docid,
    };
  }

  factory CouponData.fromMap(Map<String, dynamic> map) {
    return CouponData(
      promoCodeName: map['promoCodeName'],
      code: map['code'],
      discount: map['discount'],
      valetedDate: map['valetedDate'],
      docid: map['docid'],
    );
  }
}
