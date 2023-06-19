import 'package:campus_flutter/base/helpers/stringToDouble.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tuition.g.dart';

@JsonSerializable()
class Tuition {
  @JsonKey(name: "soll", fromJson: stringToDouble)
  final double? amount;
  @JsonKey(name: "frist")
  final DateTime deadline;
  @JsonKey(name: "semester_bezeichnung")
  final String semester;
  @JsonKey(name: "semester_id")
  final String semesterID;

  Tuition({
    required this.amount,
    required this.deadline,
    required this.semester,
    required this.semesterID
  });

  factory Tuition.fromJson(Map<String, dynamic> json) => _$TuitionFromJson(json);

  Map<String, dynamic> toJson() => _$TuitionToJson(this);
}

@JsonSerializable()
class TuitionData {
  @JsonKey(name: "rowset")
  Tuitions profilesAttribute;

  TuitionData({required this.profilesAttribute});

  factory TuitionData.fromJson(Map<String, dynamic> json) => _$TuitionDataFromJson(json);

  Map<String, dynamic> toJson() => _$TuitionDataToJson(this);
}

@JsonSerializable()
class Tuitions {
  @JsonKey(name: "row")
  final Tuition tuition;

  Tuitions({required this.tuition});

  factory Tuitions.fromJson(Map<String, dynamic> json) => _$TuitionsFromJson(json);

  Map<String, dynamic> toJson() => _$TuitionsToJson(this);
}