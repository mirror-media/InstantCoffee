import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/widgets/messageClipper.dart';
import 'dart:math' as math;

class QuoteByWidget extends StatelessWidget {
  final String quote;
  final String quoteBy;
  final bool isMemberContent;
  QuoteByWidget({
    @required this.quote,
    this.quoteBy,
    this.isMemberContent = false,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var messageRoofHeight = height / 18;
    if(isMemberContent){
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: appColor,
                    thickness: 2,
                    height: 2,
                  ),
                ),
                SizedBox(
                  width: 24,
                ),
                Transform.rotate(
                  angle: 180 * math.pi / 180,
                  child: Icon(
                    Icons.format_quote,
                    size: 40,
                    color: Color.fromRGBO(5, 79, 119, 1),
                  ),
                ),
                SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: Divider(
                    color: appColor,
                    thickness: 2,
                    height: 2,
                  ),
                ),
              ],
            ),
            Text(
              quote,
              style: TextStyle(
                color: Color.fromRGBO(5, 79, 119, 1),
                fontSize: 17,
                height: 1.8,
              ),
            ),
            if (quoteBy != null && quoteBy != '') ...[
              const SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '⎯ $quoteBy',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.8,
                    color: Color.fromRGBO(5, 79, 119, 1),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

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
                        Text(
                          quote,
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 20,
                            height: 1.8,
                          ),
                        ),
                        if (quoteBy != null && quoteBy != '') ...[
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              Text(
                                '-- $quoteBy',
                                style: TextStyle(
                                  fontSize: 20,
                                  height: 1.8,
                                ),
                              ),
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
