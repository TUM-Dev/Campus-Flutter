// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mvvResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MvvResponse _$MvvResponseFromJson(Map<String, dynamic> json) => MvvResponse(
      departures: (json['departureList'] as List<dynamic>)
          .map((e) => Departure.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MvvResponseToJson(MvvResponse instance) =>
    <String, dynamic>{
      'departureList': instance.departures,
    };
