import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String msg;
  final bool isMe;
  final Key msgKey;
  const MessageBubble({
    super.key,
    required this.msg,
    required this.isMe,
    required this.msgKey,
  });

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    final pageHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).colorScheme.tertiaryContainer
                : Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(14),
              bottomLeft:
                  isMe ? const Radius.circular(14) : const Radius.circular(0),
            ),
          ),
          // width: pageWidth * 0.4,
          constraints: BoxConstraints(
            maxWidth: pageWidth * 0.7,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: pageWidth * 0.03,
            vertical: pageHeight * 0.01,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: pageWidth * 0.025,
            vertical: pageHeight * 0.01,
          ),
          child: Text(
            msg,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
