import 'package:flutter/cupertino.dart';
import 'package:readr_app/data/enum/paragraph/paragraph_type.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/audio_player_widget/audio_player_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/block_quote_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/embedded_code_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/html_text_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/image_block_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/info_box_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/ordered_list_item_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/quote_by_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/unordered_list_item_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/unstyled_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/video_player_widget/video_player_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/youtube_widget/youtube_widget.dart';

class ParagraphWidgetFactory {
  final Paragraph paragraph;

  const ParagraphWidgetFactory(this.paragraph, {Key? key});

  static Widget create(Paragraph paragraph) {
    final type = paragraph.paragraphType;
    switch (type) {
      case ParagraphType.headerOne:
        if (paragraph.contents.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: HtmlTextWidget.h1(paragraph),
          );
        }
        break;
      case ParagraphType.headerTwo:
        if (paragraph.contents.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: HtmlTextWidget.h2(paragraph),
          );
        }
        break;
      case ParagraphType.headerThree:
        if (paragraph.contents.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: HtmlTextWidget.h3(paragraph),
          );
        }
        break;
      case ParagraphType.codeBlock:
      case ParagraphType.unStyled:
        if (paragraph.contents.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: UnStyledWidget(paragraph),
          );
        }
        break;
      case ParagraphType.blockQuote:
        if (paragraph.contents.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlockQuoteWidget(paragraph),
          );
        }
        break;
      case ParagraphType.orderedListItem:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: OrderedListItemWidget(paragraph),
        );
      case ParagraphType.unorderedListItem:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: UnorderedListItemWidget(paragraph),
        );
      case ParagraphType.image:
        if (paragraph.contents.isNotEmpty) {
          return ImageBlockWidget(paragraph);
        }
        break;
      case ParagraphType.slideShowV2:
      case ParagraphType.slideShow:
        // if (paragraph.contents != null && paragraph.contents!.isNotEmpty) {
        //   return SlideShowWidget(paragraph);
        // }
        return Text('slideShow');

      case ParagraphType.youtube:
        if (paragraph.contents.isNotEmpty) {
          return YoutubeWidget(paragraph);
        }
        break;
      case ParagraphType.video:
        if (paragraph.contents.isNotEmpty) {
          return VideoPlayerWidget(paragraph);
        }
        break;
      case ParagraphType.audio:
        if (paragraph.contents.isNotEmpty) {
          return AudioPlayerWidget(paragraph);
        }
        break;
      case ParagraphType.embeddedCode:
        if (paragraph.contents.isNotEmpty) {
          return EmbeddedCodeWidget(paragraph);
        }
        break;
      case ParagraphType.infoBox:
        if (paragraph.contents!.isNotEmpty) {
          return InfoBoxWidget(paragraph: paragraph);
        }
        break;
      case ParagraphType.annotation:
        // TODO: Handle this case.
        break;
      case ParagraphType.quoteBy:
        if (paragraph.contents!.isNotEmpty) {
          return QuoteByWidget(paragraph);
        }
        break;

      case ParagraphType.unKnow:
      default:
        return const ErrorWidget();
    }
    return const ErrorWidget();
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Error');
  }
}
