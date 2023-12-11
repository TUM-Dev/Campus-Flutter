import 'package:campus_flutter/base/views/seperated_list.dart';
import 'package:campus_flutter/homeComponent/widgetComponent/views/widget_frame_view.dart';
import 'package:campus_flutter/navigaTumComponent/model/navigatum_navigation_property.dart';
import 'package:campus_flutter/base/extensions/context.dart';
import 'package:campus_flutter/navigaTumComponent/viewModels/navigatum_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigaTumRoomDetailsView extends ConsumerWidget {
  const NavigaTumRoomDetailsView({
    super.key,
    required this.id,
    required this.properties,
  });

  final String id;
  final List<NavigaTumNavigationProperty> properties;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WidgetFrameView(
      title: context.localizations.roomDetails,
      child: Card(
        child: SeparatedList.list(
          data: properties,
          tile: (property) => _detail(
            ref.read(navigaTumDetailsViewModel(id)).icon(property.name),
            property.text,
            context,
          ),
        ),
      ),
    );
  }

  Widget _detail(IconData iconData, String detail, BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(detail),
    );
  }
}
