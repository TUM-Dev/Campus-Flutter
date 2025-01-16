import 'package:campus_flutter/base/enums/credentials.dart';
import 'package:campus_flutter/base/routing/routes.dart';
import 'package:campus_flutter/base/util/padded_divider.dart';
import 'package:campus_flutter/homeComponent/view/widget/widget_frame_view.dart';
import 'package:campus_flutter/onboardingComponent/viewModels/onboarding_viewmodel.dart';
import 'package:campus_flutter/settingsComponent/views/appearance_settings_view.dart';
import 'package:campus_flutter/settingsComponent/views/calendar_settings_view.dart';
import 'package:campus_flutter/settingsComponent/views/contact_view.dart';
import 'package:campus_flutter/settingsComponent/views/general_settings_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

final useWebView = StateProvider<bool>((ref) => true);
final showStudentCardPicture = StateProvider<bool>((ref) => true);
final hideFailedGrades = StateProvider<bool>((ref) => false);
final showWeekends = StateProvider<bool>((ref) => false);
final showHiddenCalendarEntries = StateProvider<bool>((ref) => false);

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (MediaQuery.orientationOf(context) == Orientation.landscape) {
      return Row(
        children: [
          const Expanded(
            child: Column(
              children: [
                GeneralSettingsView(),
                AppearanceSettingsView(),
                CalendarSettingsView(),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const ContactView(),
                _resetButtons(context, ref),
                _versionNumberText(),
              ],
            ),
          ),
        ],
      );
    } else {
      return ListView(
        children: [
          const GeneralSettingsView(),
          const AppearanceSettingsView(),
          const CalendarSettingsView(),
          const ContactView(),
          _resetButtons(context, ref),
          _versionNumberText(),
        ],
      );
    }
  }

  Widget _resetButtons(BuildContext context, WidgetRef ref) {
    final List<Widget> widgets = [
      _resetPreferencesButton(context, ref),
      _resetAllButton(context, ref),
    ];
    return WidgetFrameView(
      child: Card(
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => widgets[index],
          separatorBuilder: (context, index) => const PaddedDivider(height: 0),
          itemCount: widgets.length,
        ),
      ),
    );
  }

  Widget _resetPreferencesButton(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () => context.mounted
          ? ref.read(onboardingViewModel).resetPreferences(ref)
          : null,
      dense: true,
      title: Text(
        context.tr("resetPreferences"),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _resetAllButton(BuildContext context, WidgetRef ref) {
    final loginStatus = ref.read(onboardingViewModel).credentials.value;
    return ListTile(
      dense: true,
      title: loginStatus != Credentials.tumId
          ? Text(
              context.tr("login"),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            )
          : Text(
              context.tr("logout"),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
      onTap: () {
        if (loginStatus != Credentials.none) {
          ref.read(onboardingViewModel).logout(ref);
        }
        context.go(onboarding);
      },
    );
  }

  Widget _versionNumberText() {
    return Center(
      child: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
              context.tr(
                "versionNumber",
                args: [snapshot.data!.version, snapshot.data!.buildNumber],
              ),
            );
          } else {
            return Text(
              context.tr("versionNumber", args: ["-.-.-", "-"]),
            );
          }
        },
      ),
    );
  }
}
