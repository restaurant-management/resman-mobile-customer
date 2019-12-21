import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resman_mobile_customer/src/models/comment.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class ReviewComment extends StatefulWidget {
  final Comment reviewComment;
  final bool border;

  const ReviewComment({Key key, this.reviewComment, this.border})
      : super(key: key);
  @override
  _ReviewCommentState createState() => _ReviewCommentState();
}

class _ReviewCommentState extends State<ReviewComment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: colorScheme.onSurface),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                width: 50.0,
                height: 50.0,
                child: ClipOval(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Image.asset(
                      'assets/images/default-avatar.jpg',
                      fit: BoxFit.cover,
                    ),
                    fit: BoxFit.cover,
                    imageUrl: widget.reviewComment.createBy.avatar,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        (widget.reviewComment.createBy.fullName ??
                                widget.reviewComment.createBy.username) +
                            ' • ',
                        style: TextStyles.h5
                            .merge(TextStyle(color: colorScheme.onSurface)),
                      ),
                      Text(
                        timeAgo.format(widget.reviewComment.createAt,
                            locale: 'vi'),
                        style: TextStyles.h5
                            .merge(TextStyle(color: colorScheme.onSurface)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.reviewComment.content,
                    style: TextStyles.h4.merge(TextStyle(
                      color: colorScheme.onBackground,
                    )),
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
