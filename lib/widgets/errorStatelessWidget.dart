import 'package:flutter/material.dart';

class ErrorStatelessWidget extends StatelessWidget {
  final String errorMessage;
  final Function onRetryPressed;

  const ErrorStatelessWidget({Key? key, required this.errorMessage, required this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
    // return Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(
    //         errorMessage,
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //           color: Colors.lightGreen,
    //           fontSize: 18,
    //         ),
    //       ),
    //       SizedBox(height: 8),
    //       RaisedButton(
    //         color: Colors.lightGreen,
    //         child: Text('Retry', style: TextStyle(color: Colors.white)),
    //         onPressed: onRetryPressed,
    //       )
    //     ],
    //   ),
    // );
  }
}
