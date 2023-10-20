class CreateSlotData {
  dynamic slotId;
  dynamic vendorId;
  dynamic startDateForLunch;
  dynamic endDateForLunch;
  dynamic startTimeForLunch;
  dynamic endTimeForLunch;
  dynamic startDateForDinner;
  dynamic endDateForDinner;
  dynamic startTimeForDinner;
  dynamic endTimeForDinner;
  dynamic lunchDuration;
  dynamic dinnerDuration;
  dynamic noOfGuest;
  dynamic setOffer ;
  dynamic slot;
  dynamic dinnerSlot;
  dynamic time;

  CreateSlotData({
    this.time,
    this.vendorId,
    this.slotId,
    this.endDateForDinner,
    this.endDateForLunch,
    this.endTimeForLunch,
    this.startDateForDinner,
    this.startDateForLunch,
    this.startTimeForLunch,
    this.startTimeForDinner,
    this.endTimeForDinner,
    this.lunchDuration,
    this.dinnerDuration,
    this.noOfGuest,
    this.setOffer,
    required this.slot,
    required this.dinnerSlot,
  });

  Map<String, dynamic> toMap() {
    return {
      "time": time,
      "vendorId": vendorId,
      "slotId": slotId,
      "endDateForDinner": endDateForDinner,
      "endDateForLunch": endDateForLunch,
      "endTimeForLunch": endTimeForLunch,
      "startDateForDinner": startDateForDinner,
      "startDateForLunch": startDateForLunch,
      "startTimeForLunch": startTimeForLunch,
      "startTimeForDinner": startTimeForDinner,
      "endTimeForDinner": endTimeForDinner,
      "noOfGuest": noOfGuest,
      "setOffer": setOffer,
      "slot": slot,
      "dinnerSlot": dinnerSlot
    };
  }

  factory CreateSlotData.fromMap(Map<String, dynamic> map, String slotId) {
    return CreateSlotData(
      slotId: slotId,
      vendorId: map["endDateForDinner"],
      startDateForLunch: map["startDateForLunch"],
      endDateForLunch: map["endDateForLunch"],
      startTimeForLunch: map["startTimeForLunch"],
      endTimeForLunch: map["endTimeForLunch"],
      startDateForDinner: map["startDateForDinner"],
      endDateForDinner: map["endDateForDinner"],
      startTimeForDinner: map["startTimeForDinner"],
      endTimeForDinner: map["endTimeForDinner"],
      lunchDuration: map["lunchDuration"],
      dinnerDuration: map["dinnerDuration"],
      noOfGuest: map["noOfGuest"],
      setOffer: map["setOffer"],
      slot: map["slot"],
      dinnerSlot: map["dinnerSlot"],
      time: map["time"],
    );
  }
}
