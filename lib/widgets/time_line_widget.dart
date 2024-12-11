import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:recipe/const/app_styles.dart';
import 'package:timelines/timelines.dart';

class TimeLineWidget extends StatefulWidget {
  final List<String> steps;
  List<bool> isCheckedList;
  TimeLineWidget({
    super.key,
    required this.steps,
    required this.isCheckedList,
  });

  @override
  State<TimeLineWidget> createState() => _TimeLineWidgetState();
}

class _TimeLineWidgetState extends State<TimeLineWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 5, right: 20),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.steps.length,
            itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isCheckedList[index] = !widget.isCheckedList[index];
                  });
                },
                child: CustomTimeLineWidget(
                    isCheckedList: widget.isCheckedList,
                    index: index,
                    steps: widget.steps)))
        // .animate(delay: 1000.ms)
        // .fadeIn(delay: (500).ms)
        // .slideY(begin: 0.2, end: 0),
        );
  }
}

class CustomTimeLineWidget extends StatelessWidget {
  final List<bool> isCheckedList;
  final int index;
  final List<String> steps;
  const CustomTimeLineWidget({
    Key? key,
    required this.isCheckedList,
    required this.index,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const dashedLine = DashedLineConnector(
      gap: 5,
      dash: 6,
      color: AppColors.button,
    );
    const dotIndicator = DotIndicator(
      size: 25,
      color: AppColors.button,
      child: Icon(
        Icons.check,
        size: 15,
        color: Colors.black,
      ),
    );
    const outLinedIndicator = OutlinedDotIndicator(
      size: 25,
      color: AppColors.button,
    );
    return SizedBox(
        child: TimelineTile(
      node: TimelineNode(
          indicatorPosition: 0.1,
          startConnector: index == 0
              ? null
              : isCheckedList[index]
                  ? const SolidLineConnector(
                      color: AppColors.button,
                    )
                  : dashedLine,
          endConnector: index == steps.length - 1
              ? null
              : isCheckedList[index]
                  ? const SolidLineConnector(
                      color: AppColors.button,
                    )
                  : dashedLine,
          indicator: isCheckedList[index] ? dotIndicator : outLinedIndicator),
      contents: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Step ${index + 1}",
              style: AppTextStyles.setps,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              steps[index],
              style: AppTextStyles.body,
            ),
          ],
        )
            .animate(delay: 200.ms)
            .fadeIn(delay: (350 * index).ms)
            .slideY(begin: 0.3, end: 0),
      ),
      nodePosition: 0.03,
    ));
  }
}
