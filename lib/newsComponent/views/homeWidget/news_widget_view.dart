import 'package:campus_flutter/base/enums/error_handling_view_type.dart';
import 'package:campus_flutter/base/util/delayed_loading_indicator.dart';
import 'package:campus_flutter/base/util/horizontal_slider.dart';
import 'package:campus_flutter/base/errorHandling/error_handling_router.dart';
import 'package:campus_flutter/homeComponent/widgetComponent/views/widget_frame_view.dart';
import 'package:campus_flutter/newsComponent/viewModel/news_viewmodel.dart';
import 'package:campus_flutter/newsComponent/views/news_card_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsWidgetView extends ConsumerStatefulWidget {
  const NewsWidgetView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsWidgetViewState();
}

class _NewsWidgetViewState extends ConsumerState<NewsWidgetView> {
  @override
  void initState() {
    ref.read(newsViewModel).fetch(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetFrameView(
      title: context.tr("latestNews"),
      child: StreamBuilder(
        stream: ref.watch(newsViewModel).news,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final fiveNews = ref.watch(newsViewModel).latestFiveNews();
            if (fiveNews.isNotEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return HorizontalSlider.height(
                    data: fiveNews,
                    height: 300,
                    child: (news) {
                      return NewsCardView(
                        news: news,
                        width: constraints.maxWidth * 0.8,
                      );
                    },
                  );
                },
              );
            } else {
              return SizedBox(
                height: 300,
                child: Card(
                  child: Center(
                    child: Text(
                      context.tr(
                        "noEntriesFound",
                        args: [context.tr("news")],
                      ),
                    ),
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return SizedBox(
              height: 300,
              child: Card(
                child: ErrorHandlingRouter(
                  error: snapshot.error!,
                  errorHandlingViewType: ErrorHandlingViewType.textOnly,
                  retry: (() => ref.read(newsViewModel).fetch(true)),
                ),
              ),
            );
          } else {
            return SizedBox(
              height: 300,
              child: Card(
                child: DelayedLoadingIndicator(
                  name: context.tr("news"),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
