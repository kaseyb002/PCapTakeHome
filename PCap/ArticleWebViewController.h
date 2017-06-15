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

@interface ArticleWebViewController : UIViewController <WKNavigationDelegate>

@property(nonatomic, strong)Article *article;

@end
