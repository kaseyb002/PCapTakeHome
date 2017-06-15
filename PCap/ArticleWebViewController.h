//
//  ArticleWebViewController.h
//  PCap
//
//  Created by Kasey Baughan on 6/15/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Article.h"

/*!
 @class ArticleWebViewController
 
 @brief Simple WebView of article from blog.
 
 */

@interface ArticleWebViewController : UIViewController <WKNavigationDelegate>

/*! @brief Article to display. */
@property(nonatomic, strong)Article *article;

@end
