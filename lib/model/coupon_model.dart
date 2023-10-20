class CouponData {
  final dynamic promoCodeName;
  final dynamic code;
  final dynamic discount;
  final dynamic startDate;
  final dynamic endDate;
  final dynamic? docid;

  CouponData(
      {required this.promoCodeName,
      this.code,
      this.discount,
      this.startDate,
      this.endDate,
      this.docid});

  Map<String, dynamic> toMap() {
    return {
      'promoCodeName': promoCodeName,
      'code': code,
      'discount': discount,
      'startDate': startDate,
      'endDate': endDate,
      'docid': docid,
    };
  }

  factory CouponData.fromMap(Map<String, dynamic> map) {
    return CouponData(
      promoCodeName: map['promoCodeName'],
      code: map['code'],
      discount: map['discount'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      docid: map['docid'],
    );
  }
}
