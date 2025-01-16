import 'package:campus_flutter/base/enums/device.dart';
import 'package:campus_flutter/base/enums/error_handling_view_type.dart';
import 'package:campus_flutter/base/errorHandling/error_handling_router.dart';
import 'package:campus_flutter/base/extensions/context.dart';
import 'package:campus_flutter/base/networking/apis/tumdev/campus_backend.pb.dart';
import 'package:campus_flutter/base/services/device_type_service.dart';
import 'package:campus_flutter/base/util/delayed_loading_indicator.dart';
import 'package:campus_flutter/base/util/url_launcher.dart';
import 'package:campus_flutter/campusComponent/model/student_club_collection.dart';
import 'package:campus_flutter/campusComponent/view/studentClub/student_club_grid_view.dart';
import 'package:campus_flutter/campusComponent/viewmodel/student_club_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentClubsScreen extends ConsumerWidget {
  const StudentClubsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: ref.watch(studentClubViewModel).collections,
      builder: (context, snapshot) {
        return DefaultTabController(
          length: snapshot.data?.length ?? 0,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Student Clubs"),
              actions: [
                IconButton(
                  onPressed: () => UrlLauncher.urlString(
                    studentClubUrl(context),
                    ref,
                  ),
                  icon: const Icon(Icons.open_in_new),
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  for (var collection
                      in snapshot.data ?? <StudentClubCollection>[])
                    Tab(text: collection.parsedTitle),
                ],
              ),
            ),
            body: () {
              if (snapshot.hasData) {
                return TabBarView(
                  children: [
                    for (var collection in snapshot.data!)
                      Scrollbar(
                        child: StudentClubGridView(
                          studentClubs: collection.clubs,
                          padding: EdgeInsets.all(context.padding),
                          crossAxisCount: crossAxisCount(context),
                          withinScrollView: false,
                        ),
                      ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: ErrorHandlingRouter(
                    error: snapshot.error,
                    errorHandlingViewType: ErrorHandlingViewType.fullScreen,
                  ),
                );
              } else {
                return const Center(
                  child: DelayedLoadingIndicator(
                    name: "Student Clubs",
                  ),
                );
              }
            }(),
          ),
        );
      },
    );
  }

  int crossAxisCount(BuildContext context) {
    switch (DeviceService.getType(context)) {
      case Device.landscapeTablet:
        return 6;
      case Device.portraitTablet:
        return 4;
      case Device.phone:
        return 2;
    }
  }

  String studentClubUrl(BuildContext context) {
    if (context.locale.languageCode == "de") {
      return "https://www.sv.tum.de/sv/hochschulgruppen/";
    } else {
      return "https://www.sv.tum.de/en/sv/student-groups/";
    }
  }
}
