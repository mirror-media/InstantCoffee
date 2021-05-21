import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/magazine/magazineListLabel.dart';
import 'package:url_launcher/url_launcher.dart';

class OnlineMagazineWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double imageWidth = (width - 48) / 3;
    double imageHeight = imageWidth / 3;

    return Column(
      children: [
        MagazineListLabel(label: '購買線上雜誌'),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(
            left: 24.0, right: 24.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _magazineButton(
                imageWidth,
                imageHeight,
                hamiPng,
                hamiMagazineURL
              ),
              _magazineButton(
                imageWidth,
                imageHeight,
                myBookPng,
                myBookMagazineURL
              ),
              _magazineButton(
                imageWidth,
                imageHeight,
                pubuPng,
                pubuMagazineURL,
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(
            left: 24.0, right: 24.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _magazineButton(
                imageWidth,
                imageHeight,
                readmooPng,
                readmooMagazineURL,
              ),
              _magazineButton(
                imageWidth,
                imageHeight,
                konoPng,
                konoMagazineAURL,
                label: 'A本',
              ),
              _magazineButton(
                imageWidth,
                imageHeight,
                konoPng,
                konoMagazineBURL,
                label: 'B本',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _magazineButton(
    double imageWidth,
    double imageHeight,
    String pngPath,
    String url,
    {
      String label
    }
  ) {
    return InkWell(
      child: label == null
      ? Ink(
          width: imageWidth,
          height: imageHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(pngPath),
              fit: BoxFit.contain,
            ),
          ),
        )
      : Column(
        children: [
          Ink(
            width: imageWidth,
            height: imageHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(pngPath),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: appColor,
            ),
          ),
        ],
      ),
      onTap: () async{
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
    );
  }
}