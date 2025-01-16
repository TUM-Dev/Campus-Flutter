import 'package:campus_flutter/base/enums/device.dart';
import 'package:campus_flutter/base/enums/error_handling_view_type.dart';
import 'package:campus_flutter/base/errorHandling/error_handling_router.dart';
import 'package:campus_flutter/base/extensions/context.dart';
import 'package:campus_flutter/base/services/device_type_service.dart';
import 'package:campus_flutter/base/util/delayed_loading_indicator.dart';
import 'package:campus_flutter/campusComponent/view/news/news_card_view.dart';
import 'package:campus_flutter/campusComponent/viewmodel/news_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: ref.watch(newsViewModel).newsBySource,
      builder: (context, snapshot) {
        return DefaultTabController(
          length: snapshot.data?.length ?? 0,
          child: Scaffold(
            appBar: AppBar(
              title: Text(context.tr("news")),
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  for (var newsSourceTitle in snapshot.data?.keys ?? <String>[])
                    Tab(text: newsSourceTitle),
                ],
              ),
            ),
            body: () {
              if (snapshot.hasData) {
                return TabBarView(
                  children: [
                    for (var collection in snapshot.data!.values)
                      Scrollbar(
                        child: GridView.count(
                          crossAxisCount: crossAxisCount(context),
                          mainAxisSpacing: context.padding,
                          crossAxisSpacing: context.padding,
                          padding: EdgeInsets.all(context.padding),
                          childAspectRatio: 1.1,
                          children: [
                            for (var news in collection)
                              LayoutBuilder(
                                builder: (context, constraints) => NewsCardView(
                                  news: news,
                                  width: constraints.maxWidth,
                                ),
                              ),
                          ],
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
                return Center(
                  child: DelayedLoadingIndicator(
                    name: context.tr("news"),
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
        return 3;
      case Device.portraitTablet:
        return 2;
      case Device.phone:
        return 1;
    }
  }
}
