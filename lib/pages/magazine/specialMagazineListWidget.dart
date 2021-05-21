import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/magazine/states.dart';
import 'package:readr_app/models/magazineList.dart';
import 'package:readr_app/pages/magazine/magazineItemWidget.dart';
import 'package:readr_app/pages/magazine/magazineListLabel.dart';

class SpecialMagazineListWidget extends StatefulWidget {
  final MagazineList magazineList;
  final MagazineState magazineState;
  final bool isLoadingMoreDone;
  SpecialMagazineListWidget({
    @required this.magazineList,
    @required this.magazineState,
    this.isLoadingMoreDone = false
  });
  
  @override
  _SpecialMagazineListWidgetState createState() => _SpecialMagazineListWidgetState();
}

class _SpecialMagazineListWidgetState extends State<SpecialMagazineListWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.only(
          left: 24.0, right: 24,
        ),
        child: Divider(),
      ),
      itemCount: widget.magazineList.length,
      itemBuilder: (context, index) {
        if(index == widget.magazineList.length - 1)
        {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0, right: 24,
                ),
                child: MagazineItemWidget(
                  magazine: widget.magazineList[index],
                ),
              ),
              if(widget.magazineState is MagazineLoadingMore)
              ...[
                SizedBox(height: 8),
                Center(child: CupertinoActivityIndicator(),),
                SizedBox(height: 8),
              ],
              if(widget.isLoadingMoreDone)
                Container(
                  width: width,
                  color: Color(0xffE5E5E5),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0, bottom: 12.0,
                    ),
                    child: Center(
                      child: Text(
                        '所有期數都在上面囉',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
            ]
          );
        }
        return Column(
          children: [
            if(index == 0)
              MagazineListLabel(label: '特刊'),
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0, right: 24,
              ),
              child: MagazineItemWidget(
                magazine: widget.magazineList[index],
              ),
            ),
          ],
        );
      }
    );
  }
}