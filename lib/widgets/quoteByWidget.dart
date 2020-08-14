import 'package:flutter/material.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/widgets/messageClipper.dart';

class QuoteByWidget extends StatelessWidget {
  final String quote;
  final String quoteBy;
  QuoteByWidget({
    @required this.quote,
    this.quoteBy,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var messageRoofHeight = height / 18;

    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: messageRoofHeight),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: appColor, width: 3.0),
                    ),
                    color: Colors.transparent),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(quote),
                        if (quoteBy != null) ...[
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              Text('-- $quoteBy'),
                            ],
                          ),
                        ],
                      ],
                    )),
              ),
            ),
            ClipPath(
              clipper: MessageClipper(),
              child: Container(
                height: messageRoofHeight,
                decoration: BoxDecoration(
                  color: appColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
