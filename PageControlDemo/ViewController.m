//
//  ViewController.m
//  PageControlDemo
//
//  Created by wisdom on 17/1/12.
//  Copyright © 2017年 wisdom. All rights reserved.
//

#import "ViewController.h"
#import "LWDPageControl.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) LWDPageControl * pageControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageControl = [[LWDPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-40, CGRectGetWidth(self.view.frame), 40) indicatorMargin:5.f indicatorWidth:10.f currentIndicatorWidth:20.f indicatorHeight:10];
    _pageControl.numberOfPages = 6;
    _pageControl.scrollView = self.collectionView;
    
    [_pageControl addTarget:self action:@selector(currentPageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle Click
- (void)currentPageChanged:(LWDPageControl *)pageControl{
    [self.collectionView scrollRectToVisible:CGRectMake(pageControl.currentPage*self.collectionView.frame.size.width, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height) animated:YES];
}

#pragma UICollectionViewDelegate && Datasource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width - 20, 400);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = currentPage;
}

@end
