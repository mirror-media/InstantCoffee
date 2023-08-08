// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'paragraph.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Paragraph _$ParagraphFromJson(Map<String, dynamic> json ) => Paragraph(
      id: json['id'] as String?,
      styles: json['styles'] as Map<String, dynamic>?,
      contents: (json['content'] as List<dynamic>)
          .map((e) => Content.fromJson(e,$enumDecodeNullable(_$ParagraphTypeEnumMap, json['type'])))
          .toList(),
      type: $enumDecodeNullable(_$ParagraphTypeEnumMap, json['type']),

    );

Map<String, dynamic> _$ParagraphToJson(Paragraph instance) => <String, dynamic>{
      'styles': instance.styles,
      'contents': instance.contents,
      'type': _$ParagraphTypeEnumMap[instance.type],
      'id': instance.id,
    };

const _$ParagraphTypeEnumMap = {
  ParagraphType.headerOne: 'header-one',
  ParagraphType.headerTwo: 'header-two',
  ParagraphType.codeBlock: 'code-block',
  ParagraphType.unStyled: 'unstyled',
  ParagraphType.blockQuote: 'blockquote',
  ParagraphType.orderedListItem: 'ordered-list-item',
  ParagraphType.unorderedListItem: 'unordered-list-item',
  ParagraphType.image: 'image',
  ParagraphType.slideShow: 'slideshow',
  ParagraphType.slideShowV2:'slideshow-v2',
  ParagraphType.youtube: 'youtube',
  ParagraphType.video: 'video',
  ParagraphType.audio: 'audio',
  ParagraphType.embeddedCode: 'embeddedcode',
  ParagraphType.infoBox: 'infobox',
  ParagraphType.annotation: 'annotation',
  ParagraphType.quoteBy: 'quoteBy',
  ParagraphType.unKnow: 'unKnow',
};
