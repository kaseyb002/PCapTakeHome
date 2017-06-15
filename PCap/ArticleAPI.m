//
//  ArticleAPI.m
//  PCap
//
//  Created by Kasey Baughan on 6/14/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleAPI.h"
#import "Article.h"

@implementation ArticleAPI

#pragma mark - Networks Calls
- (void) getFeed: (void (^)(NSArray<Article *> *articles, NSString *error))callback {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSURL *url = [[NSURL alloc] initWithString:[ArticleAPI rssUrl]];
        
        NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:url];//this is the network call
        
        if (xmlparser) {
            [xmlparser description];
            [xmlparser setDelegate: self];
            [xmlparser parse];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(NULL, @"RSS download failed");
            });
            return;
        }
        
        NSArray *articles = [self convertFrom:self.marrXMLData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(articles, NULL);
        });
        
    });
    
}


#pragma mark - XML Parsing

- (NSArray<Article *> *) convertFrom:(NSMutableArray<NSMutableDictionary *> *) xmlData {
    
    NSMutableArray<Article *> *articles = [[NSMutableArray<Article *> alloc] init];
    
    for(NSMutableDictionary *dict in self.marrXMLData) {
        Article *article = [[Article alloc] initWith:dict];
        [articles addObject:article];
    }
    
    return [articles copy];
}


#pragma mark - NXSML delegate

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"rss"]) {
        self.marrXMLData = [[NSMutableArray alloc] init];
    }
    if ([elementName isEqualToString:@"item"]) {
        self.mdictXMLPart = [[NSMutableDictionary alloc] init];
    }
    if ([elementName isEqualToString:[ArticleAPI mediaContentKey]]) {
        self.mdictXMLMediaPart = [[NSMutableDictionary alloc] init];
        NSString *imageUrl = [attributeDict objectForKey:[ArticleAPI urlKey]];
        [self.mdictXMLMediaPart setObject:imageUrl forKey:[ArticleAPI urlKey]];
    }
    
}

- (void) parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string {
    
    if (!self.mstrXMLString) {
        self.mstrXMLString = [[NSMutableString alloc] initWithString:string];
    }
    else {
        [self.mstrXMLString appendString:string];
    }
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        [self.marrXMLData addObject:self.mdictXMLPart];
    }
    
    if ([elementName isEqualToString:[ArticleAPI titleKey]]
        || [elementName isEqualToString:[ArticleAPI descriptionKey]]
        || [elementName isEqualToString:[ArticleAPI pubDateKey]]
        || [elementName isEqualToString:[ArticleAPI linkKey]]) {
        [self.mdictXMLPart setObject:self.mstrXMLString forKey:elementName];
    } else if ([elementName isEqualToString:[ArticleAPI mediaContentKey]]) {
        NSString *imageUrl = [self.mdictXMLMediaPart objectForKey:[ArticleAPI urlKey]];
        [self.mdictXMLPart setObject:imageUrl forKey:[ArticleAPI imageUrlKey]];
    }
    
    self.mstrXMLString = nil;
}


#pragma mark - Dictionary Keys for XML parsing

+ (NSString *)rssKey {
    return @"rss";
}
+ (NSString *)itemKey {
    return @"item";
}
+ (NSString *)titleKey {
    return @"title";
}
+ (NSString *)descriptionKey {
    return @"description";
}
+ (NSString *)pubDateKey {
    return @"pubDate";
}
+ (NSString *)linkKey {
    return @"link";
}
+ (NSString *)mediaContentKey {
    return @"media:content";
}
+ (NSString *)urlKey {
    return @"url";
}
+ (NSString *)imageUrlKey {
    return @"url";
}

+ (NSString *)rssUrl {
    return @"https://blog.personalcapital.com/feed/?cat=3,891,890,68,284";
}

@end
