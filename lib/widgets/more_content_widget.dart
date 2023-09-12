import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class MoreContentWidget extends StatelessWidget {
  const MoreContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        const TextSpan(
            text: '更多內容，歡迎訂閱',
            style: TextStyle(
              color: Colors.black54,
            )),
        TextSpan(
          text: '鏡週刊紙本雜誌',
          recognizer: TapGestureRecognizer()
            ..onTap = () => print('Tap Here onTap'),
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
        const TextSpan(
          text: '、',
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        TextSpan(
          text: '了解內容授權資訊',
          recognizer: TapGestureRecognizer()
            ..onTap = () => print('Tap Here onTap'),
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ]),
    );

    //   Text(
    //   '<p>更多內容，歡迎訂閱<a href="https://docs.google.com/forms/d/e/1FAIpQLSeqbPjhSZx63bDWFO298acE--otet1s4-BGOmTKyjG1E4t4yQ/viewform">鏡週刊紙本雜誌</a>、<a href="https://www.mirrormedia.mg/story/webauthorize/">了解內容授權資訊</a>。</p>',
    //   style: TextStyle(height: 1.8,color: Colors.black54, fontSize: 13),
    // );
  }
}
