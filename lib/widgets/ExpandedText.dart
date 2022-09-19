import 'package:Unica/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ExpandedText extends StatefulWidget {
  final int maxLines;

  final int minLines;

  final String text;

  const ExpandedText(
      {Key? key,
      required this.maxLines,
      required this.minLines,
      required this.text})
      : super(key: key);

  @override
  State<ExpandedText> createState() => _ExpandedTextState();
}

class _ExpandedTextState extends State<ExpandedText> {
  bool _isExpanded = false;
  late int _linesLength;

  Widget expandableText(bool isExpanded) {
    return Text(
      widget.text,
      overflow: TextOverflow.ellipsis,
      maxLines: isExpanded ? widget.maxLines : widget.minLines,
      textAlign: TextAlign.justify,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          // AnimatedCrossFade uses crossFadeState to determine the tansition between first and second child
          child: AnimatedExpandingContainer(
            isExpanded: _isExpanded,
            // use  true and false below instead of using _isExpanded
            // using _isExpanded will affect the animation tranisition
            expandedWidget: expandableText(true),
            unexpandedWidget: expandableText(false),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  !_isExpanded ? "Ver Mas" : "Ver Menos",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                Icon(
                  !_isExpanded ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.red,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
