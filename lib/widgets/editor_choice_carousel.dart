import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/widgets/carousel_display_widget.dart';

class EditorChoiceCarousel extends StatefulWidget {
  final List<Record> editorChoiceList;
  final double aspectRatio;
  const EditorChoiceCarousel({
    required this.editorChoiceList,
    this.aspectRatio = 16 / 9,
  });

  @override
  _EditorChoiceCarouselState createState() => _EditorChoiceCarouselState();
}

class _EditorChoiceCarouselState extends State<EditorChoiceCarousel> {
  final CarouselController _carouselController = CarouselController();
  late CarouselOptions _options;

  @override
  void initState() {
    _options = CarouselOptions(
      viewportFraction: 1.0,
      aspectRatio: widget.aspectRatio,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 8),
      enlargeCenterPage: true,
      onPageChanged: (index, reason) {},
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return widget.editorChoiceList.isEmpty
        ? Container()
        : Stack(
            children: [
              CarouselSlider(
                items: _imageSliders(width, widget.editorChoiceList),
                carouselController: _carouselController,
                options: _options,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  child: SizedBox(
                    width: width * 0.1,
                    height: width / widget.aspectRatio,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () {
                    _carouselController.previousPage();
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: SizedBox(
                    width: width * 0.1,
                    height: width / widget.aspectRatio,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    _carouselController.nextPage();
                  },
                ),
              ),
            ],
          );
  }

  List<Widget> _imageSliders(double width, List<Record> editorChoiceList) {
    return editorChoiceList
        .map(
          (item) => CarouselDisplayWidget(
            record: item,
            width: width,
            aspectRatio: widget.aspectRatio,
          ),
        )
        .toList();
  }
}
