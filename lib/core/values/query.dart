class QueryDB {
  static String fetchRelatedPostsByTopic = '''
  query {
  posts(
    take: %d, 
    skip: %d,
    orderBy:{publishedDate:desc},
    where: {
    isFeatured: {equals:false}, 
    topics: {slug: {in: ["%s"]}}}) 
    {
      slug
      title
      publishedDate
      style
      isMember
      heroImage{
          id
          resized{
              original
              w480
              w800
              w1200
              w1600
              w2400
          }
        }    
      }
  }
  ''';
}
