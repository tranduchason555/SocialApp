import 'package:appmangxahoi/message_detail/message_detail_screen.dart';
import 'package:appmangxahoi/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:appmangxahoi/models/colors.dart';

class MessageItem extends StatefulWidget {
    dynamic? message;
   MessageItem({
    this.message
  });

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessageDetailScreen(messagess: widget!.message!,),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: kWhite.withOpacity(0.60),
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1.0, color: kBlack),
              ),
              child: CircleAvatar(
                backgroundImage:  NetworkImage(widget!.message!.otherUserPhoto),
                radius: 35.0,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  widget!.message!.otherFullName!,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: kBlack),
                  ),
                  Text(
                    widget!.message!.otherFullName!,
                    style: Theme.of(context).textTheme.labelSmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}