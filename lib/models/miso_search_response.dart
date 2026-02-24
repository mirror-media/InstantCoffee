import 'miso_models.dart';

class MisoSearchResponse {
  final String misoId;
  final String questionId;
  final int took;
  final int total;
  final List<MisoProduct> products;
  final MisoFacetCounts? facetCounts;

  const MisoSearchResponse({
    required this.misoId,
    required this.questionId,
    required this.took,
    required this.total,
    required this.products,
    this.facetCounts,
  });

  factory MisoSearchResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return MisoSearchResponse(
      misoId: data['miso_id'] as String,
      questionId: data['question_id'] as String,
      took: data['took'] as int,
      total: data['total'] as int,
      products: (data['products'] as List<dynamic>)
          .map((e) => MisoProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      facetCounts: data['facet_counts'] != null
          ? MisoFacetCounts.fromJson(
          data['facet_counts'] as Map<String, dynamic>)
          : null,
    );
  }
}