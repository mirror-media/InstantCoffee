import 'package:flutter/material.dart';
import 'package:readr_app/widgets/newsMarquee/newsMarquee.dart';

class NewsMarqueePersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return NewsMarquee();
  }
  @override
  double get maxExtent => 48;
  
  @override
  double get minExtent => 48;
  
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}