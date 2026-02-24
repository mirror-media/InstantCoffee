class MisoProduct {
  final String productId;
  final String title;
  final String url;
  final String? coverImage;
  final String? publishedAt;
  final String? snippet;
  final Map<String, dynamic> customAttributes;

  const MisoProduct({
    required this.productId,
    required this.title,
    required this.url,
    this.coverImage,
    this.publishedAt,
    this.snippet,
    required this.customAttributes,
  });

  String? get storySlug {
    const prefix = 'mirrormedia_story_';
    if (productId.startsWith(prefix)) {
      final s = productId.substring(prefix.length);
      return s.isEmpty ? null : s;
    }
    return productId.isEmpty ? null : productId;
  }
  factory MisoProduct.fromJson(Map<String, dynamic> json) {
    return MisoProduct(
      productId: json['product_id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      coverImage: json['cover_image'] as String?,
      publishedAt: json['published_at'] as String?,
      snippet: json['snippet'] as String?,
      customAttributes:
      (json['custom_attributes'] as Map<String, dynamic>? ?? const {}),
    );
  }
}

class MisoFacetBucket {
  final String name;
  final int count;

  const MisoFacetBucket({
    required this.name,
    required this.count,
  });
}

class MisoFacetCounts {
  final Map<String, List<MisoFacetBucket>> facetFields;

  const MisoFacetCounts({required this.facetFields});

  factory MisoFacetCounts.fromJson(Map<String, dynamic> json) {
    final ff = json['facet_fields'] as Map<String, dynamic>;
    final Map<String, List<MisoFacetBucket>> result = {};

    ff.forEach((key, value) {
      final list = value as List<dynamic>;
      result[key] = list
          .map((e) => MisoFacetBucket(
        name: e[0] as String,
        count: e[1] as int,
      ))
          .toList();
    });

    return MisoFacetCounts(facetFields: result);
  }
}