import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class StateErrorWidget extends StatelessWidget {
  final VoidCallback onPressed;
  StateErrorWidget(this.onPressed);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '載入失敗',
          style: TextStyle(
            color: Colors.black26,
            fontSize: 17,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: appColor),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  '重新載入',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }

}