import 'package:flutter/material.dart';

import '../../../helpers/data_constants.dart';
import '../../../widgets/more_content_widget.dart';

class SubscriptionWidget extends StatelessWidget {
  const SubscriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            '本新聞文字、照片、影片專供鏡週刊會員閱覽，未經鏡週刊授權，任何媒體、社群網站、論壇等均不得引用、改寫、轉貼，以免訟累。',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          const MoreContentWidget(),
          const SizedBox(height: 32),
          Card(
            elevation: 10,
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '月費、年費會員免費線上閱讀動態雜誌',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(0, 0, 0, 0.66),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColor,
                        ),

                        /// Todo 等 Account k6串接後補上Loading
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              '線上閱讀',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        ///Todo 等 Account k6串接後補上
                        onPressed: () => {}),
                  ]),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
