class QueryDB {
  static String fetchRelatedImageByTopic = '''
    query{
      photos(
        where: {
          id:  {in: ["%d"]}}) 
          {
            id
            name
            imageFile{
                url
          }
        }
    }
  ''';
  static String fetchRelatedPostsByTopic = '''
    query {
      posts(
        take: %d, 
        skip: %d,
        orderBy:{publishedDate:desc},
        where: {
        isFeatured: {equals:false}, 
        topics: {id: {in: ["%s"]}}}) 
      {
        slug
        title
        publishedDate
        style
        isMember
        heroImage
        {
            id
            resized
            {
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

  static String getTopicList = '''
    query {
      topics (
         take:%d,
         skip:%d,
         orderBy:{sortOrder:asc})
         {
            id
            type
            name
            isFeatured
            tags{
              id
            }
            sortOrder
            og_image{
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

  static String getArticleInfoBySlug ='''
  query {
    post(
      where: {
       slug: "%s"})
        {
          
          slug
          title
          publishedDate
          updatedAt
          heroVideo{
              urlOriginal
          }
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
          relateds{
              id
              slug
              title
              publishedDate
              style
              isMember
          }
          heroCaption
          extend_byline
          tags{
              id
              name
          }
          writers{
              id
              name
          }
          photographers{
              id
              name
          }
          camera_man{
              id
              name
          }
          designers{
              id
              name
          }
          engineers{
              id
              name
          }
          brief
          apiData
          categories{
              id
              name
              slug
              isMemberOnly
          }
          sections{
              name
              slug
              description
          }
          isMember
          isAdvertised
          
        }
}
  ''';

}
