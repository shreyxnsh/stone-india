class ContactListModel {
  List<ContactData>? contactData;

  ContactListModel({this.contactData});

  factory ContactListModel.fromJson(Map<String, dynamic> json) {
    return ContactListModel(
        contactData: json['contacts'] != null ? (json['contacts'] as List).map((i) => ContactData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contactData != null) {
      data['contacts'] = contactData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContactData {
  String? displayName;
  List? phones;
  List? emails;

  ContactData({this.displayName, this.phones, this.emails});

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
        displayName: json['displayName'],
        phones: json['phones'],
        emails: json['emails']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['displayName'] = displayName;
    data['phones'] = phones;
    data['emails'] = emails;
    return data;
  }

}