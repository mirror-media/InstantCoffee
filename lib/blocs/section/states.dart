import 'package:equatable/equatable.dart';
import 'package:readr_app/models/section.dart';

enum SectionStatus { initial, loading, loaded, error }

class SectionState extends Equatable {
  final SectionStatus status;
  final List<Section>? sectionList;
  final dynamic errorMessages;

  const SectionState({
    required this.status,
    this.sectionList,
    this.errorMessages,
  });

  factory SectionState.init() {
    return SectionState(
      status: SectionStatus.initial
    );
  }

  factory SectionState.loading() {
    return SectionState(
      status: SectionStatus.loading
    );
  }

  factory SectionState.loaded({
    required List<Section> sectionList,
  }) {
    return SectionState(
      status: SectionStatus.loaded,
      sectionList: sectionList,
    );
  }

  factory SectionState.error({
    dynamic errorMessages
  }) {
    return SectionState(
      status: SectionStatus.error,
      errorMessages: errorMessages,
    );
  }

  @override
  String toString() {
    return 'SectoinState { status: $status }';
  }

  @override
  List<Object?> get props => [
    status, 
    sectionList, 
    errorMessages
  ];
}
