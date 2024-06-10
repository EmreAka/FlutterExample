import 'package:flutter_example/core/models/model_interface.dart';
import 'package:flutter_example/shared/constants/hive_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user.model.g.dart';

@HiveType(typeId: HiveConstants.userTypeId)
class UserModel implements IModel<UserModel> {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? username;
  @HiveField(3)
  String? email;
  @HiveField(4)
  AddressModel? address;
  @HiveField(5)
  String? phone;
  @HiveField(6)
  String? website;
  @HiveField(7)
  CompanyModel? company;

  UserModel(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.address,
      this.phone,
      this.website,
      this.company});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    address =
        json['address'] != null ? AddressModel.fromJson(json['address']) : null;
    phone = json['phone'];
    website = json['website'];
    company =
        json['company'] != null ? CompanyModel.fromJson(json['company']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['phone'] = phone;
    data['website'] = website;
    if (company != null) {
      data['company'] = company!.toJson();
    }
    return data;
  }
  
  @override
  UserModel fromJson(Map<String, Object?> json) => UserModel.fromJson(json);
}

@HiveType(typeId: HiveConstants.addressTypeId)
class AddressModel implements IModel<AddressModel>{
  @HiveField(0)
  String? street;
  @HiveField(1)
  String? suite;
  @HiveField(2)
  String? city;
  @HiveField(3)
  String? zipcode;
  @HiveField(4)
  GeoModel? geo;

  AddressModel({this.street, this.suite, this.city, this.zipcode, this.geo});

  AddressModel.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    suite = json['suite'];
    city = json['city'];
    zipcode = json['zipcode'];
    geo = json['geo'] != null ? GeoModel.fromJson(json['geo']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['street'] = street;
    data['suite'] = suite;
    data['city'] = city;
    data['zipcode'] = zipcode;
    if (geo != null) {
      data['geo'] = geo!.toJson();
    }
    return data;
  }
  
  @override
  AddressModel fromJson(Map<String, Object?> json) => AddressModel.fromJson(json);
}

@HiveType(typeId: HiveConstants.geoTypeId)
class GeoModel implements IModel<GeoModel>{
  @HiveField(0)
  String? lat;
  @HiveField(1)
  String? lng;

  GeoModel({this.lat, this.lng});

  GeoModel.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
  
  @override
  GeoModel fromJson(Map<String, Object?> json) => GeoModel.fromJson(json);
}

@HiveType(typeId: HiveConstants.companyTypeId)
class CompanyModel implements IModel<CompanyModel>{
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? catchPhrase;
  @HiveField(2)
  String? bs;

  CompanyModel({this.name, this.catchPhrase, this.bs});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    catchPhrase = json['catchPhrase'];
    bs = json['bs'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['catchPhrase'] = catchPhrase;
    data['bs'] = bs;
    return data;
  }
  
  @override
  CompanyModel fromJson(Map<String, Object?> json) => CompanyModel.fromJson(json);
}
