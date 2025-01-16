import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_flutter/base/extensions/string_capitalize.dart';
import 'package:campus_flutter/base/util/string_parser.dart';
import 'package:campus_flutter/base/networking/apis/tumdev/campus_backend.pbgrpc.dart';
import 'package:campus_flutter/base/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NewsCardView extends ConsumerWidget {
  const NewsCardView({
    super.key,
    required this.news,
    required this.width,
    this.isCarousel = false,
  });

  final News news;
  final double width;
  final bool isCarousel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = news.imageUrl.toString().contains("src_1.png")
        ? news.link.toString()
        : news.imageUrl.toString();
    if (isCarousel) {
      return body(imageUrl, context);
    } else {
      return InkWell(
        onTap: () {
          if (imageUrl.isNotEmpty) {
            context.push(networkImage, extra: (imageUrl, null));
          }
        },
        child: body(imageUrl, context),
      );
    }
  }

  Widget body(String imageUrl, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).cardTheme.color,
      ),
      child: AspectRatio(
        aspectRatio: 1.1,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fadeOutDuration: Duration.zero,
                  fadeInDuration: Duration.zero,
                  placeholder: (context, string) => Image.asset(
                    "assets/images/placeholders/news_placeholder.png",
                    fit: BoxFit.fill,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/placeholders/news_placeholder.png",
                    fit: BoxFit.fill,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          news.title.capitalizeFirstLetter(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          StringParser.dateFormatter(
                            news.date.toDateTime(),
                            context,
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          news.sourceTitle,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
