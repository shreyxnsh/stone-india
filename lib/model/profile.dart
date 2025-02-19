class ProfileModel {
  var id;
  String? address;
  String? city;
  String? country;
  String? first_name;
  String? last_name;
  String? mobile_number;
  String? profile_image;
  String? role;
  String? state;

  ProfileModel({ this.id,
        this.address,
        this.city,
        this.country,
        this.first_name,
        this.last_name,
        this.mobile_number,
        this.profile_image,
        this.role,
        this.state,
      });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      mobile_number: json['contact_number'],
      profile_image: json['profile_image'],
      role: json['role'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['city'] = city;
    data['country'] = country;
    data['first_name'] = first_name;
    data['last_name'] = last_name;
    data['contact_number'] = mobile_number;
    data['profile_image'] = profile_image;
    data['role'] = role;
    data['state'] = state;
    return data;
  }
}




