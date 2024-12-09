import 'package:flutter/material.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;

  const ExpandableTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool isExpanded = false;
  bool isOverflowing = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Measure if the text overflows 3 lines
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: widget.text,
            style: const TextStyle(fontSize: 16),
          ),
          maxLines: 3,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              maxLines: isExpanded ? null : 3, // Expand or collapse
              overflow:
                  isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
            if (isOverflowing)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded; // Toggle expansion
                  });
                },
                child: Text(
                  isExpanded ? "Show less" : "Show more",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
