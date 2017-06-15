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

@interface ViewController ()

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

- (void)fetchArticles {
    ArticleAPI *api = [[ArticleAPI alloc] init];
    [api getFeed:^(NSArray *articles, NSError *error) {
        [self displayArticles:articles];
    }];
}

- (void)displayArticles:(NSArray<Article *>*) articlesToLoad {
    NSMutableArray *mArticles = [articlesToLoad mutableCopy];
    //grab first article to show in header view
    Article *article = mArticles.firstObject;
    self.firstArticle = article;
    [mArticles removeObjectAtIndex:0];
    //send the rest of the articles to collection view cells
    self.articles = [mArticles copy];
    [collectionView reloadData];
}

- (void)viewArticle:(Article *) article {
    ArticleWebViewController *vc = [[ArticleWebViewController alloc] init];
    vc.article = article;
    [self.navigationController pushViewController:vc animated:true];
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
    //change for iPad
    return CGSizeMake(150, 150);
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
                                            350);
            headerView = [[UICollectionReusableView alloc] initWithFrame:headerFrame];
        }
        
        //add description label
        CGFloat const verticalMargin = 5.0f;
        CGRect descriptionFrame = CGRectMake(10,
                                       headerView.frame.size.height - 35,
                                       headerView.frame.size.width - 10,
                                       32);
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame: descriptionFrame];
        descriptionLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0];
        descriptionLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        descriptionLabel.numberOfLines = 2;
        descriptionLabel.text = self.firstArticle.descriptionNoHTML;
        [headerView addSubview: descriptionLabel];
        //add title label
        CGRect titleFrame = CGRectMake(10,
                                       headerView.frame.size.height
                                       - descriptionLabel.frame.size.height
                                       - 30,
                                       headerView.frame.size.width - 10,
                                       30);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame: titleFrame];
        titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:18.0];
        titleLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        titleLabel.numberOfLines = 1;
        titleLabel.text = self.firstArticle.title;
        [headerView addSubview: titleLabel];
        //add image view
        CGRect imageFrame = CGRectMake(0,
                                       0,
                                       headerView.frame.size.width,
                                       headerView.frame.size.height
                                       - descriptionLabel.frame.size.height
                                       - titleLabel.frame.size.height
                                       - verticalMargin);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0] CGColor];
        [imageView downloadAndSetImage:self.firstArticle.imageUrl];
        [headerView addSubview:imageView];
    
        headerView.layer.borderWidth = 1.0;
        headerView.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0] CGColor];
        
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
    
    [self.view addSubview:self->collectionView];
}

@end
