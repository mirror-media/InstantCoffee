import 'package:flutter/material.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/firebase_analytics_helper.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/widgets/popupRoute/easy_popup.dart';

class SectionDropDownMenu extends StatefulWidget with EasyPopupChild {
  final double topPadding;
  final double tabBarHeight;
  final TabController tabController;
  final List<Section> sectionList;

  SectionDropDownMenu({
    this.topPadding = 0.0,
    required this.tabBarHeight,
    required this.tabController,
    required this.sectionList,
  });

  final _PopController controller = _PopController();

  @override
  _SectionDropDownMenuState createState() => _SectionDropDownMenuState();

  @override
  dismiss() {
    controller.dismiss();
  }
}

class _SectionDropDownMenuState extends State<SectionDropDownMenu>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    widget.controller._bindState(this);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(_controller);
    _controller.forward();
  }

  dismiss() {
    _controller.reverse();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + widget.topPadding),
        child: ClipRect(
          child: SlideTransition(
            position: _animation,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: widget.tabBarHeight,
                  color: Colors.white,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                          child: Text(
                            '類別',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.black12,
                        thickness: 1,
                        indent: 12,
                        endIndent: 12,
                        width: 8,
                      ),
                      InkWell(
                          child: SizedBox(
                            height: widget.tabBarHeight,
                            width: widget.tabBarHeight - 8,
                            child: const Icon(
                              Icons.keyboard_arrow_up,
                              size: 24,
                              color: Colors.black54,
                            ),
                          ),
                          onTap: () => EasyPopup.pop(context)),
                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Colors.black12,
                          width: 1,
                        ),
                      ),
                    ),
                    child: chipList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  chipList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          for (Section section in widget.sectionList) _buildChip(section)
        ],
      ),
    );
  }

  Widget _buildChip(
    Section section, {
    Color labelColor = const Color(0xffA3A3A3),
    Color backgroundColor = Colors.white,
  }) {
    String title = section.title ?? StringDefault.valueNullDefault;
    if (section.name == 'member') {
      title = 'Premium文章';
      labelColor = Colors.black87;
    }

    int targetIndex = widget.sectionList.indexOf(section);
    if (widget.tabController.index == targetIndex) {
      labelColor = Colors.white;
      backgroundColor = appColor;
    }

    return ActionChip(
      side: BorderSide(
        color: labelColor,
      ),
      label: Text(
        title,
        style: TextStyle(
          color: labelColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: backgroundColor,
      labelPadding: EdgeInsets.zero,
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      onPressed: () {
        if (targetIndex >= 5) {
          FirebaseAnalyticsHelper.logTabBarAfterTheSixthClick(
              sectiontitle: section.title ?? StringDefault.valueNullDefault);
        }

        widget.tabController.animateTo(targetIndex);
        EasyPopup.pop(context);
      },
    );
  }
}

class _PopController {
  _SectionDropDownMenuState? state;

  _bindState(_SectionDropDownMenuState state) {
    this.state = state;
  }

  dismiss() {
    state?.dismiss();
  }
}
