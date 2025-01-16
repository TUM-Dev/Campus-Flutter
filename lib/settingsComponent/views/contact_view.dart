import 'dart:io';

import 'package:campus_flutter/base/util/hyperlink_text.dart';
import 'package:campus_flutter/base/routing/routes.dart';
import 'package:campus_flutter/base/util/seperated_list.dart';
import 'package:campus_flutter/homeComponent/view/widget/widget_frame_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContactView extends ConsumerWidget {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WidgetFrameView(
      title: context.tr("contactMore"),
      child: Card(
        child: SeparatedList.widgets(
          widgets: [
            HyperLinkListTile(
              dense: true,
              link: _betaTester(),
              label: context.tr("becomeABetaTester"),
            ),
            HyperLinkListTile(
              dense: true,
              link: "https://github.com/TUM-Dev",
              label: context.tr("usOnGitHub"),
            ),
            const HyperLinkListTile(
              dense: true,
              link: "https://app.tum.de",
              label: "TUM-Dev Website",
            ),
            const HyperLinkListTile(
              dense: true,
              link: "https://tum.sexy/",
              label: "TUM.sexy",
            ),
            HyperLinkListTile(
              dense: true,
              link: "https://www.tum.dev/privacy",
              label: context.tr("privacyPolicy"),
            ),
            _licensesButton(context),
            _feedbackButton(context),
          ],
        ),
      ),
    );
  }

  String _betaTester() {
    if (Platform.isAndroid) {
      return "https://play.google.com/store/apps/details?id=de.tum.tca_flutter";
    } else {
      return "https://testflight.apple.com/join/4Ddi6f2f";
    }
  }

  Widget _feedbackButton(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        "Feedback",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: () => context.push(feedback),
    );
  }

  Widget _licensesButton(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        context.tr("licenses"),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: () => showLicensePage(context: context),
    );
  }
}
