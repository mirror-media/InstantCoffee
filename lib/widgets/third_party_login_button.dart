import 'package:flutter/material.dart';

class ThirdPartyLoginButton extends StatelessWidget {
  const ThirdPartyLoginButton(
      {Key? key,
      this.onTapFunction,
      required this.contentText,
      required this.imageLocation})
      : super(key: key);
  final Function()? onTapFunction;
  final String contentText;
  final String imageLocation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      onTap: onTapFunction,
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(
            style: BorderStyle.solid,
            width: 1.0,
            color: Colors.grey
          ),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: contentText.contains('Apple')
                  ? const EdgeInsets.all(6.0)
                  : const EdgeInsets.all(0),
              child: Image.asset(
                imageLocation,
              ),
            ),
            Text(
              contentText,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
