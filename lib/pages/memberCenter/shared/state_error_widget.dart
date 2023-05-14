import 'package:flutter/material.dart';
import 'package:readr_app/helpers/data_constants.dart';

class StateErrorWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const StateErrorWidget(this.onPressed);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
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
            style: ElevatedButton.styleFrom(backgroundColor: appColor),
            onPressed: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Center(
                child: Text(
                  '重新載入',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
