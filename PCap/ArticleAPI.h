//
//  ArticleAPI.h
//  PCap
//
//  Created by Kasey Baughan on 6/14/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

@interface ArticleAPI : NSObject <NSXMLParserDelegate>

- (void) getFeed: (void (^)(NSArray<Article *> *articles, NSError *error))callback;

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
