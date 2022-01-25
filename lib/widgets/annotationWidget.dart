import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/annotation.dart';

class AnnotationWidget extends StatefulWidget {
  final String data;
  final bool isMemberContent;
  AnnotationWidget({
    required this.data,
    this.isMemberContent = false,
  });

  @override
  _AnnotationWidgetState createState() => _AnnotationWidgetState();
}

class _AnnotationWidgetState extends State<AnnotationWidget> {
  List<String> displayStringList = [];

  @override
  void initState() {
    _parsingTheData();
    super.initState();
  }

  _parsingTheData() {
    String temp = widget.data.replaceAll(RegExp(r'<!--[^{",}]*-->'), '');
    temp = temp.replaceAll('<!--', '<-split->').replaceAll('-->', '<-split->');
    displayStringList = temp.split('<-split->');
    for (int i = displayStringList.length - 1; i >= 0; i--) {
      if (displayStringList[i] == "") {
        displayStringList.removeAt(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _renderWidgets(context),
    );
  }

  List<Widget> _renderWidgets(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    List<Widget> displayWidgets = [];
    RegExp annotationExp = RegExp(
      r'__ANNOTATION__=(.*)',
      caseSensitive: false,
    );

    for (int i = 0; i < displayStringList.length; i++) {
      if (annotationExp.hasMatch(displayStringList[i])) {
        String? body = annotationExp.firstMatch(displayStringList[i])!.group(1);
        Annotation annotation = Annotation.parseResponseBody(body)!;
        if (annotation.isExpanded) {
          displayWidgets.add(
            HtmlWidget(
              annotation.text,
              textStyle: TextStyle(
                fontSize: 20,
                height: 1.8,
              ),
              customStylesBuilder: (element) {
                if (element.localName == 'a') {
                  return {'color': 'blue'};
                }

                return null;
              },
            ),
          );
          displayWidgets.add(
            InkWell(
              child: widget.isMemberContent 
              ? Container(
                  child: Icon(
                    Icons.arrow_drop_up,
                    color: appColor,
                    size: 40,
                  ),
                )
              :Wrap(
                children: [
                  SizedBox(width: 8),
                  Text(
                    '(註)',
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.8,
                      color: appColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2.0, color: appColor),
                      ),
                      child: Icon(
                        Icons.arrow_drop_up,
                        color: appColor,
                        size: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              onTap: () {
                if (mounted) {
                  setState(() {
                    annotation.isExpanded = !annotation.isExpanded;
                    displayStringList[i] =
                        '__ANNOTATION__=' + json.encode(annotation.toJson());
                  });
                }
              },
            ),
          );
          displayWidgets.add(
            Padding(
              padding: EdgeInsets.only(top: widget.isMemberContent ? 8.0 : 16.0),
              child: widget.isMemberContent
              ? Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(248, 248, 249, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
                  child: HtmlWidget(
                    annotation.annotation,
                    textStyle: TextStyle(
                      fontSize: 15,
                      height: 1.8,
                    ),
                    customStylesBuilder: (element) {
                      if (element.localName == 'a') {
                        return {'color': 'blue'};
                      }

                      return null;
                    },
                  ),
                ),
              )
              :Container(
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: appColor,
                      width: 3.0,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HtmlWidget(
                    annotation.annotation,
                    textStyle: TextStyle(
                      fontSize: 20,
                      height: 1.8,
                    ),
                    customStylesBuilder: (element) {
                      if (element.localName == 'a') {
                        return {'color': 'blue'};
                      }

                      return null;
                    },
                  ),
                ),
              ),
            ),
          );
        }
        // if is not expanded
        else {
          displayWidgets.add(
            HtmlWidget(
              annotation.text,
              textStyle: TextStyle(
                fontSize: 20,
                height: 1.8,
              ),
              customStylesBuilder: (element) {
                if (element.localName == 'a') {
                  return {'color': 'blue'};
                }

                return null;
              },
            ),
          );
          displayWidgets.add(
            InkWell(
              child: widget.isMemberContent 
              ? Container(
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: appColor,
                    size: 40,
                  ),
              )
              :Wrap(
                children: [
                  SizedBox(width: 8),
                  Text(
                    '(註)',
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.8,
                      color: appColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2.0, color: appColor),
                      ),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: appColor,
                        size: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              onTap: () {
                if (mounted) {
                  setState(() {
                    annotation.isExpanded = !annotation.isExpanded;
                    displayStringList[i] =
                        '__ANNOTATION__=' + json.encode(annotation.toJson());
                  });
                }
              },
            ),
          );
        }
      } else {
        displayWidgets.add(
          HtmlWidget(
            displayStringList[i],
            textStyle: TextStyle(
              fontSize: 20,
              height: 1.8,
            ),
            customStylesBuilder: (element) {
              if (element.localName == 'a') {
                return {'color': 'blue'};
              }

              return null;
            },
          ),
        );
      }
    }
    return displayWidgets;
  }
}
