//
//  NSString+StringCleanUp.h
//  PCap
//
//  Created by Kasey Baughan on 6/15/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringCleanUp)
- (NSString *)removeTabsAndNewLines;
- (NSString *)stripHTML;
@end
