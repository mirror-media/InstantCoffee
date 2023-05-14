import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/magazine/states.dart';
import 'package:readr_app/models/magazine_list.dart';
import 'package:readr_app/pages/magazine/magazine_item_widget.dart';
import 'package:readr_app/pages/magazine/magazine_list_label.dart';

class SpecialMagazineListWidget extends StatefulWidget {
  final MagazineList magazineList;
  final MagazineState magazineState;
  final bool isLoadingMoreDone;
  const SpecialMagazineListWidget(
      {required this.magazineList,
      required this.magazineState,
      this.isLoadingMoreDone = false});

  @override
  _SpecialMagazineListWidgetState createState() =>
      _SpecialMagazineListWidgetState();
}

class _SpecialMagazineListWidgetState extends State<SpecialMagazineListWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => Container(
              height: 4,
              color: const Color.fromRGBO(248, 248, 249, 1),
            ),
        itemCount: widget.magazineList.length,
        itemBuilder: (context, index) {
          if (index == widget.magazineList.length - 1) {
            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24,
                ),
                child: MagazineItemWidget(
                  magazine: widget.magazineList[index],
                ),
              ),
              if (widget.magazineState is MagazineLoadingMore) ...[
                const SizedBox(height: 8),
                const Center(
                  child: CupertinoActivityIndicator(),
                ),
                const SizedBox(height: 8),
              ],
              if (widget.isLoadingMoreDone)
                Container(
                  width: width,
                  color: const Color.fromRGBO(248, 248, 249, 1),
                  child: const Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 12.0,
                    ),
                    child: Center(
                      child: Text(
                        '所有期數都在上面囉',
                        style: TextStyle(fontSize: 13, color: Colors.black38),
                      ),
                    ),
                  ),
                ),
            ]);
          }
          return Column(
            children: [
              if (index == 0) const MagazineListLabel(label: '特刊'),
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24,
                ),
                child: MagazineItemWidget(
                  magazine: widget.magazineList[index],
                ),
              ),
            ],
          );
        });
  }
}
