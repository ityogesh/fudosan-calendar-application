class HolidayModel {
  DateTime _eventdate;

  HolidayModel(this._eventdate);

  DateTime get eventdate => this._eventdate;
/* 
  factory HolidayModel.fromJson(Map<String, String> json) {
    return HolidayModel(eventdate: json['startdate']);
  } */
}
