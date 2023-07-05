import 'package:json_annotation/json_annotation.dart';

part 'phone_extension.g.dart';

@JsonSerializable()
class PhoneExtension {
  // TODO: needed?
  //String id;
  @JsonKey(name: "telefonnummer")
  final String phoneNumber;
  @JsonKey(name: "tum_anlage_land")
  final String countryCode;
  @JsonKey(name: "tum_anlage_ortsvorwahl")
  final String areaCode;
  @JsonKey(name: "tum_anlage_nummer")
  final String equipmentNumber;
  @JsonKey(name: "tum_nebenstelle")
  final String branchNumber;

  PhoneExtension({
    required this.phoneNumber,
    required this.countryCode,
    required this.areaCode,
    required this.equipmentNumber,
    required this.branchNumber
  });

  factory PhoneExtension.fromJson(Map<String, dynamic> json) => _$PhoneExtensionFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneExtensionToJson(this);
}