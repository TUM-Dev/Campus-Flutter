import 'package:campus_flutter/base/networking/apis/tumCabeApi/tum_cabe_api_service.dart';
import 'package:campus_flutter/base/networking/protocols/api.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TumCabeApi extends Api {

  final TumCabeService tumCabeService;

  TumCabeApi({required this.tumCabeService});

  @override
  String get baseURL => kIsWeb ? "tum-proxy.resch.io" : "app.tum.de";

  @override
  Map<String, String> get baseHeaders {
    return {
      "x-app-version": "0.1.0",
      "x-app-build": "11",
      "x-device-id": "not available",
      "x-os-version": "16.4.1"
    };

    // TODO:

    /*Map<String, String> headerEntries = {};

    PackageInfo.fromPlatform().then((value) { headerEntries
        .addAll({
          "x-app-version": [value.version],
          "x-app-build": [value.buildNumber],
        });

    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      deviceInfo.iosInfo.then((value) => headerEntries
          .addAll({
            "x-device-id": [value.identifierForVendor ?? "not available"],
            "x-os-version": [value.systemVersion]
          }));
    } else if (Platform.isAndroid) {
      deviceInfo.androidInfo.then((value) => headerEntries
          .addAll({"x-device-id": [value.id], "x-os-version": [value.version.toString()]}));
    }});

    return headerEntries;*/
  }

  @override
  String get path => "/api/";

  @override
  bool get needsAuth => false;

  @override
  String get paths {
    switch (tumCabeService) {
      case TumCabeServiceMovie _:
        return "${path}kino";
      case TumCabeServiceCafeteria _:
        return "${path}mensen";
      case TumCabeServiceNews news:
        return "${path}news/${news.source}/getAll";
      case TumCabeServiceNewsSources _:
        return "${path}news/sources";
      case TumCabeServiceNewsAlert _:
        return "${path}news/alert";
      case TumCabeServiceRegisterDevice registerDevice:
        return "${path}device/register/${registerDevice.publicKey}";
    }
  }

  @override
  Map<String, String> get parameters => {};
}