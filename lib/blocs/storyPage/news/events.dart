abstract class StoryEvents{}

class FetchPublishedStoryBySlug extends StoryEvents {
  final String slug;
  final bool isMemberCheck;
  FetchPublishedStoryBySlug(
    this.slug,
    this.isMemberCheck
  );

  @override
  String toString() => 'FetchPublishedStoryBySlug { storySlug: $slug, isMemberCheck: $isMemberCheck }';

  String eventName() => 'FetchPublishedStoryBySlug';
  Map eventParameters() => { 
    "storySlug": slug, 
    "isMemberCheck": isMemberCheck 
  };
}