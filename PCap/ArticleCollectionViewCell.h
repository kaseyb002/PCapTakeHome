//
//  ArticleCollectionViewCell.h
//  PCap
//
//  Created by Kasey Baughan on 6/15/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

/*!
 @class ArticleCollectionViewCell
 
 @brief Cell that displays an article title and image.
 
 */

@interface ArticleCollectionViewCell : UICollectionViewCell

/*!
 @brief Provide data for cell to display.
 
 @param article Article object that will be displayed.
 
 */
- (void)updateCellWithArticle: (Article *) article;

/*!@brief Reuse identifier to register with CollectionView.*/
+ (NSString *)reuseId;

@end
