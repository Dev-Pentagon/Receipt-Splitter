import 'package:flutter/material.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/extension/string_extension.dart';
import 'package:receipt_splitter/model/participant.dart';

class ParticipantAvatar extends StatelessWidget {
  const ParticipantAvatar({
    super.key,
    required this.participant,
    this.width = 75,
    this.height = 75,
    this.radius = 24,
    this.textStyle,
    this.backgroundColor,
    this.border,
  });

  final Participant participant;
  final double width;
  final double height;
  final double radius;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.tertiary,
        child:
            participant.name == ALL
                ? Icon(
                  Icons.group,
                  color: Theme.of(context).colorScheme.onTertiary,
                  size: 24,
                )
                : Text(
                  participant.name.getInitials,
                  style:
                      textStyle ??
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
      ),
    );
  }
}
