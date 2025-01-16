import 'package:campus_flutter/base/enums/error_handling_view_type.dart';
import 'package:campus_flutter/base/errorHandling/error_handling_router.dart';
import 'package:campus_flutter/base/extensions/context.dart';
import 'package:campus_flutter/base/util/delayed_loading_indicator.dart';
import 'package:campus_flutter/base/util/grid_utility.dart';
import 'package:campus_flutter/base/util/url_launcher.dart';
import 'package:campus_flutter/campusComponent/view/movie/movie_grid_view.dart';
import 'package:campus_flutter/campusComponent/viewmodel/movies_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerWidget {
  const MovieScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: ref.watch(movieViewModel).movies,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("TU Film"),
            actions: [
              IconButton(
                onPressed: () => UrlLauncher.urlString(
                  "https://www.tu-film.de/",
                  ref,
                ),
                icon: const Icon(Icons.open_in_new),
              ),
            ],
          ),
          body: () {
            if (snapshot.hasData) {
              return Scrollbar(
                child: MovieGridView(
                  movies: snapshot.data!,
                  padding: EdgeInsets.all(context.padding),
                  crossAxisCount: GridUtility.campusCrossAxisCount(context),
                  withinScrollView: false,
                ),
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
                  name: context.tr("movies"),
                ),
              );
            }
          }(),
        );
      },
    );
  }
}
