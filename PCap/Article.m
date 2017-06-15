//
//  Article.m
//  PCap
//
//  Created by Kasey Baughan on 6/14/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//


#import "Article.h"
#import "ArticleAPI.h"
#import "NSString+StringCleanUp.h"

@implementation Article

- (id) initWith: (NSDictionary *)xmlData {
    
    self = [super init];
    if( !self ) return nil;
    
    NSString *titleString = [xmlData objectForKey:[ArticleAPI titleKey]];
    //cleaning out new lines and tabs
    titleString = [titleString removeTabsAndNewLines];
    self.title = titleString;
    NSString *htmlDescription = [xmlData objectForKey:[ArticleAPI descriptionKey]];
    self.htmlDescription = htmlDescription;
    htmlDescription = [htmlDescription removeTabsAndNewLines];
    htmlDescription = [htmlDescription stripHTML];
    self.descriptionNoHTML = htmlDescription;
    NSString *dateString = [xmlData objectForKey:[ArticleAPI pubDateKey]];
    dateString = [dateString removeTabsAndNewLines];
    //format date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    NSDate *date  = [dateFormatter dateFromString:dateString];
    self.pubDate = date;
    //cleaning out new lines and tabs
    NSString *linkString = [xmlData objectForKey:[ArticleAPI linkKey]];
    linkString = [linkString removeTabsAndNewLines];
    self.link = linkString;
    self.imageUrl = [xmlData objectForKey:[ArticleAPI imageUrlKey]];
    
    return self;
}

@end
