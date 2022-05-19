import 'package:readr_app/models/record.dart';

class TopicImageItem {
  Record? record;
  final String description;
  final String imageUrl;

  TopicImageItem({
    this.record,
    required this.description,
    required this.imageUrl,
  });
}
