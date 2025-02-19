class NotificationListModel {
  List<NotificationData>? notificationData;
  String? message;
  bool? status;

  NotificationListModel({this.notificationData, this.message, this.status});

  factory NotificationListModel.fromJson(Map<String, dynamic> json) {
    return NotificationListModel(
        notificationData: json['data'] != null ? (json['data'] as List).map((i) => NotificationData.fromJson(i)).toList() : null,
        message: json['messages'],
        status: json['status']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messages'] = message;
    data['status'] = status;
    if (notificationData != null) {
      data['data'] = notificationData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  String? notification;
  String? date;
  String? time;

  NotificationData({this.notification, this.date, this.time});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notification: json['message'],
      date: json['created_at'],
      time: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = notification;
    data['created_at'] = date;
    data['created_at'] = time;
    return data;
  }
}
