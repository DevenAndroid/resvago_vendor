class StoreTimeData {
  dynamic storeTimeId;
  dynamic vendorId;
  dynamic weekDay;
  dynamic startTime;
  dynamic endTime;
  dynamic status;
  dynamic time;

  StoreTimeData({this.endTime,this.startTime,this.weekDay,this.time,this.status,this.vendorId,this.storeTimeId});

  Map<String, dynamic> toMap() {
    return {
      "storeTimeId": storeTimeId,
      "vendorId": vendorId,
      "weekdays": weekDay,
      "startTime": startTime,
      "endTime": endTime,
      "status": status,
      "time": time
    };
  }

  factory StoreTimeData.fromMap(Map<String, dynamic> map, String storeTimeId,) {
    return StoreTimeData(
      storeTimeId: map['storeTimeId'],
      vendorId: map['vendorId'],
      weekDay: map['weekdays'],
      startTime: map['startTime'],
      endTime: map["endTime"],
      status: map["status"],
      time: map['time'],
    );
  }
}
