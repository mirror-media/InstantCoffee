import 'package:flutter/material.dart';
import 'package:readr_app/core/extensions/string_extension.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/core/values/image_path.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/pages/article_page/widgets/person_list.dart';

class ArticleInfoPanel extends StatelessWidget {
  const ArticleInfoPanel(
      {Key? key,
      required this.storySource,
      required this.isPremium,
      required this.isExternal})
      : super(key: key);
  final Story storySource;
  final bool isPremium;
  final bool isExternal;

  Widget renderDonateButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () {},
          child: Row(
            children: [
              Image.asset(
                ImagePath.donateIcon,
                width: 16,
                height: 16,
              ),
              const SizedBox(
                width: 4,
              ),
              const Text(
                '贊助本文',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: appColor),
          onPressed: () {},
          child: const Text('加入訂閱會員', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget renderPeopleInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        storySource.writers != null && storySource.writers!.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isPremium ? 72 : 0),
                    child: PersonList(
                      peopleList: storySource.writers!,
                      title: '文 |',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              )
            : const SizedBox.shrink(),
        storySource.cameraMen != null && storySource.cameraMen!.isNotEmpty
            ? Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isPremium ? 72 : 0),
                    child: PersonList(
                      peopleList: storySource.cameraMen!,
                      title: '攝影 |',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              )
            : const SizedBox.shrink(),
        storySource.photographers != null &&
                storySource.photographers!.isNotEmpty
            ? Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isPremium ? 72 : 0),
                    child: PersonList(
                      peopleList: storySource.photographers!,
                      title: '影音 |',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              )
            : const SizedBox.shrink(),
        storySource.designers != null && storySource.designers!.isNotEmpty
            ? Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isPremium ? 72 : 0),
                    child: PersonList(
                      peopleList: storySource.designers!,
                      title: '設計 |',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              )
            : const SizedBox.shrink(),
        storySource.engineers != null && storySource.engineers!.isNotEmpty
            ? Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isPremium ? 72 : 0),
                    child: PersonList(
                      peopleList: storySource.engineers!,
                      title: '工程 |',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              )
            : const SizedBox.shrink(),
        storySource.extendByline != null && storySource.extendByline!.length > 1
            ? Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isPremium ? 72 : 0),
                    child: PersonList(
                      isExternal: isExternal,
                      peopleList: [],
                      title: isExternal
                          ? '文 | ${storySource.extendByline!}'
                          : storySource.extendByline!,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget normalInfoPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        decoration: const BoxDecoration(
            border:
                Border(left: BorderSide(color: Color(0xFF054F77), width: 2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 24,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  renderPeopleInfo(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: appDeepBlue, width: 1),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(2.0),
                      ),
                    ),
                    child: const Text(
                      '鏡週刊',
                      style: TextStyle(
                          color: appDeepBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  storySource.publishedDate != null
                      ? Text(
                          '發布時間 ${storySource.publishedDate?.formattedTaipeiDateTime()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0x88000000)),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 4,
                  ),
                  storySource.updatedAt != null
                      ? Text(
                          '更新時間 ${storySource.updatedAt?.formattedTaipeiDateTime()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0x88000000)),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        ImagePath.faceShareIcon,
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Image.asset(
                        ImagePath.lineShareIcon,
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Image.asset(
                        ImagePath.linkShareIcon,
                        width: 40,
                        height: 40,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  renderDonateButtonGroup(),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: 300,
                    child: storySource.tags != null
                        ? Wrap(
                            children: storySource.tags!.map((e) {
                              return Wrap(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: appDeepBlue,
                                        border: Border.all(
                                            color: appDeepBlue, width: 1),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(2.0),
                                        ),
                                      ),
                                      child: Text(
                                        e.name,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              );
                            }).toList(),
                          )
                        : const SizedBox.shrink(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget premiumInfoPanel() {
    return Column(
      children: [
        renderPeopleInfo(),
        storySource.publishedDate != null
            ? Text(
                '發布時間 ${storySource.publishedDate?.formattedTaipeiDateTime()}',
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0x88000000)),
              )
            : const SizedBox.shrink(),
        storySource.updatedAt != null
            ? Text(
                '更新時間 ${storySource.updatedAt?.formattedTaipeiDateTime()}',
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0x88000000)),
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 20),
        renderDonateButtonGroup(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isPremium ? premiumInfoPanel() : normalInfoPanel();
  }
}
