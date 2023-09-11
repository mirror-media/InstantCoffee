class QueryDB {
  static String fetchRelatedImageByTopic = '''
    query{
      photos(
        where: {
          id:  {in: ["%d"]}}) 
          {
            id
            name
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

  static String fetchTopicList = '''
    query {
      topics (
         take:%d,
         skip:%d,
         orderBy:{sortOrder:asc})
         {
            id
            slug
            type
            name
            isFeatured
            tags{
              id
            }
            slideshow_imagesCount
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

  static String fetchArticleInfoBySlug = '''
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
              heroImage{
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
          apiData
          trimmedApiData
          apiDataBrief
          content
          trimmedContent
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
  static String fetchArticleListBySection = '''
    query {
      posts(
      take: 12, 
      skip: %d,
      orderBy:{publishedDate:desc},
      where: {
          isFeatured: {equals:false} 
          sections:{
              some:{
                  slug:{
                      equals:"%s"
                  },
              }
          }
      
    }) 
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
  static String fetchSectionList = '''
  query {
    sections(
        take:15
        orderBy:{order:asc},
        where:{
            isFeatured: {equals:true}, 
          }
      )
      {
            order
            name
            slug
            description
      }
    
  }
  ''';
  static const String fetchCategoriesList = '''
    query {
      categories(
          orderBy:{order:asc}
      ){
          name
          slug
      }
    }
  ''';

  static const String fetchArticleListByCategoryList = '''
    query {
      posts(
      take: 12, 
      skip: %d,
      orderBy:{publishedDate:desc},
      where: {
          categories:{
              some:{
                  slug:{
                      in:%s
                  }
              }
          }
      }) 
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
  static const String fetchArticleListByTags = '''
  query {
    posts(
      take: 12, 
      skip: %d,
      orderBy:{updatedAt:desc},
      where: {
          isAdult:{equals:false},
          isAdvertised:{equals:false},
      tags: {
          some:{
              id: {
                  in: ["%s"]
                  }
              }    
          }
      }) 
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
  static const String getExternalArticleBySlug = '''
  query {
    external(
      where: {
       slug: "%s"})
      {
          slug
          title
          content
          brief
          thumb
          extend_byline
          publishedDate
      }
  }
  ''';
  static const String getMagazinesList ='''
  query {
    magazines(
      take: 8, 
      skip: %d,
      orderBy:{publishedDate:desc},
    ) 
    {
        slug
        title
        publishedDate
        type
        urlOriginal
        coverPhoto
        {
            resized{
                original
                w480
                w800
                w1200
                w1600
                w2400
            }
        }
        pdfFile{
            url
        }
    }
  }
  ''';



}
