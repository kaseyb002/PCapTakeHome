//
//  NSString+StringCleanUp.h
//  PCap
//
//  Created by Kasey Baughan on 6/15/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringCleanUp)
/*!@brief Removes white space, \t, and \n.*/
- (NSString *)removeTabsAndNewLines;
/*!@brief Removes any HTML markup in the form of < >.*/
- (NSString *)stripHTML;
@end
