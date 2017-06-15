//
//  ArticleCollectionViewCell.h
//  PCap
//
//  Created by Kasey Baughan on 6/15/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ArticleCollectionViewCell : UICollectionViewCell

- (void)updateCellWithArticle: (Article *) article;

+ (NSString *)reuseId;

@end
