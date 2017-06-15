//
//  ArticleAPI.h
//  PCap
//
//  Created by Kasey Baughan on 6/14/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

/*!
 @class ArticleAPI
 
 @brief Contains network calls to get articles from Personal Capital Blog.
 
 */

@interface ArticleAPI : NSObject <NSXMLParserDelegate>

/*!
 @brief Retrieves most recent 40 articles from Personal Capital blog.
 
 @param  callback A block that provides an array of articles or a network error message.

 */
- (void) getFeed: (void (^)(NSArray<Article *> *articles, NSString *error))callback;

#pragma mark - Dictionary Keys for XML parsing
@property (nonatomic, strong) NSMutableDictionary *dictData;
@property (nonatomic,strong) NSMutableArray *marrXMLData;
@property (nonatomic,strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *mdictXMLPart;
@property (nonatomic,strong) NSMutableDictionary *mdictXMLMediaPart;

#pragma mark - Dictionary Keys for XML parsing
+ (NSString *)rssKey;
+ (NSString *)itemKey;
+ (NSString *)titleKey;
+ (NSString *)descriptionKey;
+ (NSString *)pubDateKey;
+ (NSString *)linkKey;
+ (NSString *)mediaContentKey;
+ (NSString *)urlKey;
+ (NSString *)imageUrlKey;

@end
