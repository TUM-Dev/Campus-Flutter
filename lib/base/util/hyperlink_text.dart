import 'package:campus_flutter/base/util/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HyperLinkListTile extends ConsumerStatefulWidget {
  const HyperLinkListTile({
    super.key,
    this.link,
    this.uri,
    required this.label,
    this.dense = false,
  });

  final String? link;
  final Uri? uri;
  final String label;
  final bool dense;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HyperlinkTextState();
}

class _HyperlinkTextState extends ConsumerState<HyperLinkListTile> {
  late TapGestureRecognizer tapGestureRecognizer;

  @override
  void dispose() {
    tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    tapGestureRecognizer = TapGestureRecognizer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: widget.dense,
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: widget.label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            WidgetSpan(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: const Icon(Icons.open_in_new, size: 15),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (widget.link != null) {
          UrlLauncher.urlString(widget.link!, ref);
        } else if (widget.uri != null) {
          UrlLauncher.url(widget.uri!, ref);
        }
      },
    );
  }
}
