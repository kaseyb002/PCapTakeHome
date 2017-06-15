//
//  ViewController.m
//  PCap
//
//  Created by Kasey Baughan on 6/14/17.
//  Copyright © 2017 Kasey Baughan. All rights reserved.
//

#import "ViewController.h"
#import "ArticleAPI.h"
#import "Article.h"
#import "ArticleCollectionViewCell.h"
#import "UIImageView+DownloadImage.h"
#import "ArticleWebViewController.h"
#import "MBProgressHUD.h"

@interface ViewController ()
/*!@brief The most recent article is displayed prominently.*/
@property (nonatomic, strong) Article *firstArticle;
@property (nonatomic, strong) NSArray<Article *> *articles;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Research & Insights"];
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(fetchArticles)];
    self.navigationItem.rightBarButtonItem = button;
    [self fetchArticles];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //ensures title doesn't disappear when coming back from web view
    self.navigationItem.title = self.title;
}

#pragma mark - Fetching and Displaying Articles

/*!@brief Fetches articles and loads collection view.*/
- (void)fetchArticles {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    ArticleAPI *api = [[ArticleAPI alloc] init];
    [api getFeed:^(NSArray *articles, NSString *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (articles) {
            [self displayArticles:articles];
        } else if (error) {
            NSLog(@"%@", error);
            [self downloadFailedAlert];
        }
    }];
}

/*!@brief Loads collection view with articles.*/
- (void)displayArticles:(NSArray<Article *>*) articlesToLoad {
    NSMutableArray *mArticles = [articlesToLoad mutableCopy];
    //grab first article to show in header view
    Article *article = mArticles.firstObject;
    self.firstArticle = article;
    [mArticles removeObjectAtIndex:0];//take it out from the rest
    //send the rest of the articles to collection view cells
    self.articles = [mArticles copy];
    [collectionView reloadData];
}
/*!@brief View article in WebView.*/
- (void)viewArticle:(Article *) article {
    ArticleWebViewController *vc = [[ArticleWebViewController alloc] init];
    vc.article = article;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)viewFirstArticle {
    [self viewArticle: self.firstArticle];
}

- (void)downloadFailedAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Can't Get Articles."
                                                                   message:@"Please check your internet connection."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self fetchArticles];
                                                          }];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                   
                                                          handler:nil];
    [alert addAction:tryAgainAction];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UICollection View Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.articles.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleCollectionViewCell *cell= [self->collectionView dequeueReusableCellWithReuseIdentifier:[ArticleCollectionViewCell reuseId]
                                                                                forIndexPath:indexPath];
    
    //I would like to find a way to use dependency injection with ArticleCollectionViewCell but didn't have time
    [cell updateCellWithArticle:[self.articles objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat heightAndWidth = screenSize.width / 2 - 15;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        heightAndWidth = screenSize.width / 3 - 15;
    }
    CGSize size = CGSizeMake(heightAndWidth, heightAndWidth);

    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [self->collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                        withReuseIdentifier:[ViewController headerReuseId]
                                                                                               forIndexPath:indexPath];
        
        if (headerView == nil) {
            CGRect headerFrame = CGRectMake(0,
                                            0,
                                            self->collectionView.frame.size.width,
                                            400);
            headerView = [[UICollectionReusableView alloc] initWithFrame:headerFrame];
            headerView.layer.borderWidth = 1.0;
            headerView.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0] CGColor];
            headerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                           | UIViewAutoresizingFlexibleHeight);
        }
        
        CGFloat const verticalMargin = 5.0f;
        //add previous label
        CGRect previousFrame = CGRectMake(10,
                                          headerView.frame.size.height
                                            - 25,
                                          headerView.frame.size.width - 10,
                                          25
                                            - verticalMargin);
        UILabel *previousLabel = [[UILabel alloc] initWithFrame: previousFrame];
        previousLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16.0];
        previousLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        previousLabel.text = @"Previous";
        previousLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        [headerView addSubview: previousLabel];
        
        //add description label
        CGRect descriptionFrame = CGRectMake(10,
                                       headerView.frame.size.height
                                             - previousLabel.frame.size.height
                                             - 40,
                                       headerView.frame.size.width - 10,
                                       37 - verticalMargin);
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame: descriptionFrame];
        descriptionLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0];
        descriptionLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        descriptionLabel.numberOfLines = 2;
        descriptionLabel.text = self.firstArticle.descriptionNoHTML;
        descriptionLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        [headerView addSubview: descriptionLabel];
        
        //add title label
        CGRect titleFrame = CGRectMake(10,
                                       headerView.frame.size.height
                                           - previousLabel.frame.size.height
                                           - descriptionLabel.frame.size.height
                                           - 40,
                                       headerView.frame.size.width - 10,
                                       40);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame: titleFrame];
        titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:18.0];
        titleLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        titleLabel.numberOfLines = 1;
        titleLabel.text = self.firstArticle.title;
        titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        [headerView addSubview: titleLabel];
        
        //add image view
        CGRect imageFrame = CGRectMake(0,
                                       0,
                                       headerView.frame.size.width,
                                       headerView.frame.size.height
                                           - previousLabel.frame.size.height
                                           - descriptionLabel.frame.size.height
                                           - titleLabel.frame.size.height
                                           - verticalMargin);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = TRUE;
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0] CGColor];
        imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                      | UIViewAutoresizingFlexibleHeight);
        [imageView downloadAndSetImage:self.firstArticle.imageUrl];
        [headerView addSubview:imageView];
        
        //add UITap
        UIView *tapView = [[UIView alloc] initWithFrame:headerView.frame];
        tapView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(viewFirstArticle)];
        [tapView addGestureRecognizer:tapGesture];
        [headerView addSubview:tapView];

        return headerView;
    }
    return nil;
}

+ (NSString *) headerReuseId {
    return @"headerView";
}

#pragma mark - UICollectionView Delegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Article *article = self.articles[indexPath.row];
    [self viewArticle:article];
}

#pragma mark - Setup View

- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setHeaderReferenceSize:CGSizeMake(rect.size.width, 200)];
    [layout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    self->collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame
                                            collectionViewLayout:layout];
    [self->collectionView setDataSource:self];
    [self->collectionView setDelegate:self];
    
    [self->collectionView registerClass:[ArticleCollectionViewCell class]
             forCellWithReuseIdentifier:[ArticleCollectionViewCell reuseId]];
    [self->collectionView registerClass:[UICollectionReusableView class]
             forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                    withReuseIdentifier:[ViewController headerReuseId]];
    [self->collectionView setBackgroundColor:[UIColor whiteColor]];
    
    self->collectionView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                             | UIViewAutoresizingFlexibleHeight);
    
    [self.view addSubview:self->collectionView];
}

@end
