class SettingModel {
  dynamic preparationTime;
  dynamic averageMealForMember;
  bool? setDelivery;
  bool? cancellation;
  bool? menuSelection;
  bool? twoStepVerification;
  dynamic docid;
  dynamic time;
  dynamic userID;

  SettingModel({
    this.preparationTime,
    this.averageMealForMember,
    this.cancellation,
    this.setDelivery,
    this.twoStepVerification,
    this.docid,
    this.menuSelection,
    this.time,
    this.userID
  });

  Map<String, dynamic> toMap() {
    return {
      "preparationTime": preparationTime,
      "averageMealForMember": averageMealForMember,
      "cancellation": cancellation,
      "setDelivery": setDelivery,
      "twoStepVerification": twoStepVerification,
      "docid": docid,
      "menuSelection": menuSelection,
      "time": time,
      "userID": userID,
    };
  }

  factory SettingModel.fromMap(Map<String, dynamic> map) {
    return SettingModel(
      preparationTime: map['preparationTime'],
      averageMealForMember: map['averageMealForMember'],
      setDelivery: map['setDelivery'],
      cancellation: map['cancellation'],
      twoStepVerification: map['twoStepVerification'],
      docid: map['docid'],
      menuSelection: map['menuSelection'],
      time: map['time'],
      userID: map['userID'],
    );
  }
}
