class ServiceTimeSloat {
  String? timeSloat;
  String? timeSloatEnd;

  ServiceTimeSloat({this.timeSloat, this.timeSloatEnd});

  ServiceTimeSloat.fromJson(Map<String, dynamic> json) {
    timeSloat = json['time_slot'];
    timeSloatEnd = json['time_slot_end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time_slot'] = timeSloat;
    data['time_slot_end'] = timeSloatEnd;
    return data;
  }
}