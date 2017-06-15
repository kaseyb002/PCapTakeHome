//
//  Article.h
//  PCap
//
//  Created by Kasey Baughan on 6/14/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class Article
 
 @brief Represents an article from the Personal Capital Research & Insights blog.
 
 */

@interface Article : NSObject

- (id) initWith: (NSDictionary *)xmlData;

/*! @brief Title of article. */
@property (nonatomic, strong)NSString *title;
/*! @brief Text description including HTML markup. */
@property (nonatomic, strong)NSString *htmlDescription;
/*! @brief Text description without HTML markup. */
@property (nonatomic, strong)NSString *descriptionNoHTML;
/*! @brief Date of article publication. */
@property (nonatomic, strong)NSDate *pubDate;
/*! @brief Link to web article. */
@property (nonatomic, strong)NSString *link;
/*! @brief Link to title image. */
@property (nonatomic, strong)NSString *imageUrl;

@end
