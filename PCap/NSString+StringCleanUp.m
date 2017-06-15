//
//  NSString+StringCleanUp.m
//  PCap
//
//  Created by Kasey Baughan on 6/15/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import "NSString+StringCleanUp.h"

@implementation NSString (StringCleanUp)

- (NSString *)removeTabsAndNewLines {
    NSString *new = self;
    new = [new stringByRemovingPercentEncoding];
    new = [new stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    new = [new stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return new;
}

- (NSString *)stripHTML {
    NSRange r;
    NSString *s = self;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end
