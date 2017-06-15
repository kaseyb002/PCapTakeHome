//
//  ArticleWebViewController.m
//  PCap
//
//  Created by Kasey Baughan on 6/15/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import "ArticleWebViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"

@interface ArticleWebViewController ()

@property(nonatomic, weak)WKWebView *webView;

@end

@implementation ArticleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    self.title = self.article.title;
    NSString *mobileLink = [NSString stringWithFormat:@"%@%@",
                            self.article.link,
                            @"?displayMobileNavigation=0"];
    NSURL *url=[NSURL URLWithString:mobileLink];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self.view animated:true];
}

#pragma mark - Setup View

- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame
                                            configuration:webConfig];

    webView.navigationDelegate = self;
    webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                | UIViewAutoresizingFlexibleHeight);
    self.webView = webView;
    
    [self.view addSubview:webView];
}


@end
