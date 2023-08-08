import 'package:flutter/cupertino.dart';
import 'package:readr_app/models/article_info/children_model/paragraph_model/paragraph.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/audio_player_widget/audio_player_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/block_quote_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/embedded_code_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/html_text_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/image_block_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/info_box_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/ordered_list_item_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/quote_by_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/slide_show_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/unordered_list_item_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/unstyled_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/video_player_widget/video_player_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/widget/youtube_widget/youtube_widget.dart';

import '../../data/enum/paragraph/paragraph_type.dart';

class ParagraphWidgetFactory {
  final Paragraph paragraph;

  const ParagraphWidgetFactory(this.paragraph, {Key? key});

  static Widget create(Paragraph paragraph) {

    final type = paragraph.type;
    switch (type) {
      case ParagraphType.headerOne:
        if (paragraph.contents != null && paragraph.contents!.isNotEmpty) {
          return HtmlTextWidget.h1(paragraph);
        }
        break;
      case ParagraphType.headerTwo:
        if (paragraph.contents != null && paragraph.contents!.isNotEmpty) {
          return HtmlTextWidget.h2(paragraph);
        }
        break;
      case ParagraphType.codeBlock:
      case ParagraphType.unStyled:
        if (paragraph.contents != null && paragraph.contents!.isNotEmpty) {
          return UnStyledWidget(paragraph);
        }
        break;
      case ParagraphType.blockQuote:
        if (paragraph.contents != null && paragraph.contents!.isNotEmpty) {
          return BlockQuoteWidget(paragraph);
        }
        break;
      case ParagraphType.orderedListItem:
        return OrderedListItemWidget(paragraph);
      case ParagraphType.unorderedListItem:
        return UnorderedListItemWidget(paragraph);
      case ParagraphType.image:
        if (paragraph.contents != null && paragraph.contents!.isNotEmpty) {
          return ImageBlockWidget(paragraph);
        }
        break;
      case ParagraphType.slideShowV2:
      case ParagraphType.slideShow:
        if (paragraph.contents != null && paragraph.contents!.isNotEmpty) {
          return SlideShowWidget(paragraph);
        }
        break;
      case ParagraphType.youtube:
        if (paragraph.contents != null && paragraph.contents!.isNotEmpty) {
          return YoutubeWidget(paragraph);
        }
        break;
      case ParagraphType.video:
        if (paragraph.contents != null && paragraph.contents!.isNotEmpty) {
          return VideoPlayerWidget(paragraph);
        }
        break;
      case ParagraphType.audio:
        if (paragraph.contents != null && paragraph.contents!.isNotEmpty) {
          return AudioPlayerWidget(paragraph);
        }
        break;
      case ParagraphType.embeddedCode:
        if (paragraph.contents != null && paragraph.contents!.isNotEmpty) {
          return EmbeddedCodeWidget(paragraph);
        }
        break;
      case ParagraphType.infoBox:
        if (paragraph.contents != null && paragraph.contents!.isNotEmpty) {
          return InfoBoxWidget(paragraph: paragraph);
        }
        break;
      case ParagraphType.annotation:
        // TODO: Handle this case.
        break;
      case ParagraphType.quoteBy:
        if (paragraph.contents != null && paragraph.contents!.isNotEmpty) {
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
