import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:readr_app/data/enum/member_level.dart';
import 'package:readr_app/data/enum/paragraph/paragraph_type.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/data/providers/auth_provider.dart';
import 'package:readr_app/models/content.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/models/story_res.dart';

class ArticleController extends GetxController {
  final Rxn<StoryRes> rxStoryRes = Rxn();
  final ArticlesApiProvider articlesApiProvider = Get.find();
  final AuthProvider authProvider = Get.find();
  final RxBool rxIsPremium = false.obs;
  final RxList<Record> rxRelateRecordList = RxList();
  final Rxn<Story> rxnStory = Rxn();
  final RxBool rxIsExternal = false.obs;
  final Rx<MemberLevel> rxMemberLevel = MemberLevel.lv0.obs;
  final RxList<Paragraph> rxRenderParagraphList = RxList();
  final RxBool rxIsTrimmed =false.obs;
  dynamic arg;

  ArticleController(this.arg);

  @override
  void onInit() async {
    super.onInit();
    if (arg != null) {
      if (arg.containsKey('record')) {
        Record record = arg['record'];
        final slug = record.slug;
        rxIsExternal.value = record.isExternal;

        if (slug != null && record.isExternal) {
          final result =
              await articlesApiProvider.getExternalArticleBySlug(slug: slug);
          Story externalStory = Story(
              title: result.title,
              subtitle: result.subtitle,
              slug: result.slug,
              publishedDate: result.publishedDate,
              heroImage: result.publishedDate,
              extendByline: result.extendByLine,
              sections: [
                result.showOnIndex == false
                    ? Section(key: 'life', title: '生活')
                    : Section(key: 'news', title: '時事'),
              ],
              brief: [
                Paragraph(
                    paragraphType: ParagraphType.unStyled,
                    contents: [Content(data: result.brief)])
              ],
              apiData: [
                Paragraph(
                    paragraphType: ParagraphType.unStyled,
                    contents: [Content(data: result.content)])
              ]);
          setStory(externalStory);
        }
        if (slug != null && record.isExternal == false) {
          rxStoryRes.value =
              await articlesApiProvider.getArticleInfoBySlug(slug: slug);
          setStory(rxStoryRes.value!.story);
          rxRelateRecordList.value = rxnStory.value?.relatedStory ?? [];
        }
        rxIsPremium.value =
            authProvider.rxnMemberInfo.value?.isPremiumMember ?? false;
      }

      if (authProvider.rxnMemberInfo.value == null) {
        rxMemberLevel.value = MemberLevel.lv0;
      } else if (authProvider.rxnMemberInfo.value?.subscriptionType ==
          SubscriptionType.none) {
        rxMemberLevel.value = MemberLevel.lv1;
      } else if (authProvider.rxnMemberInfo.value?.subscriptionType ==
          SubscriptionType.subscribe_one_time) {
        rxMemberLevel.value = MemberLevel.lv2;
      } else if (authProvider.rxnMemberInfo.value?.isPremiumMember == true) {
        rxMemberLevel.value = MemberLevel.lv3;
      }
    }
  }

  void setStory(Story story) {
    rxnStory.value = story;
    if (story.apiData!.isEmpty) {
      rxRenderParagraphList.value = story.trimmedApiData ?? [];
      rxIsTrimmed.value =true;
    }
    else {
      rxRenderParagraphList.value = story.apiData ?? [];
      rxIsTrimmed.value =false;
    }
  }
}
