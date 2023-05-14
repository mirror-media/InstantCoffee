import 'package:readr_app/models/record.dart';

class TopicItem {
  final Record record;
  final bool isFeatured;
  final String? tagId;
  final String? tagTitle;

  const TopicItem({
    required this.record,
    this.isFeatured = false,
    this.tagId,
    this.tagTitle,
  });
}
