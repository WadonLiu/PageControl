//
//  LWDPageControl.h
//
//
//  Created by wisdom on 17/1/12.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWDPageControl : UIControl

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, strong) UIColor * pageIndicatorColor;
@property (nonatomic, strong) UIColor * currentPageIndicatorColor;
@property (nonatomic, assign) NSInteger currentPage;

- (instancetype)initWithFrame:(CGRect)frame indicatorMargin:(CGFloat)margin indicatorWidth:(CGFloat)indicatorWidth currentIndicatorWidth:(CGFloat)currentIndicatorWidth indicatorHeight:(CGFloat)indicatorHeight;

@end
