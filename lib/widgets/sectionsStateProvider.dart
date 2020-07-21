import 'package:flutter/material.dart';
import 'package:readr_app/models/sectionList.dart';

class SectionsStateProvider extends ChangeNotifier {
  SectionList _updatedSection = new SectionList();

  void sortSections(SectionList currentSections) {
    currentSections.sort((a, b) => a.order.compareTo(b.order));
    for (int i = 0; i < currentSections.length; i++) {
      currentSections[i].setOrder(i);
    }
    _updatedSection = currentSections;
    notifyListeners();
  }

  SectionList get updatedSection => _updatedSection;
}
