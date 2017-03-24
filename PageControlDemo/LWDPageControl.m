//
//  LWDPageControl.m
//
//
//  Created by wisdom on 17/1/12.
//  Copyright © 2017年 . All rights reserved.
//

#import "LWDPageControl.h"

@interface LWDPageControl ()

@property (nonatomic, strong) NSMutableArray * indicatorViews;
@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, assign) CGFloat indicatorMargin;
@property (nonatomic, assign) CGFloat indicatorWidth;
@property (nonatomic, assign) CGFloat currentIndicatorWidth;
@property (nonatomic, assign) CGFloat indicatorHeight;

@end

@implementation LWDPageControl

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    
    _indicatorViews = [NSMutableArray array];
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_contentView];
    _numberOfPages = 0;
    _currentPage = 0;
    _pageIndicatorColor = [UIColor lightGrayColor];
    _currentPageIndicatorColor = [UIColor colorWithRed:31/255.f green:136/255.f blue:229/255.f alpha:1.f];
    _indicatorWidth = 3; //普通宽度
    _indicatorMargin = 5.f; //间距
    _currentIndicatorWidth = 12.f;// 当前 宽度
    _indicatorHeight = 3;
}

- (instancetype)initWithFrame:(CGRect)frame indicatorMargin:(CGFloat)margin indicatorWidth:(CGFloat)indicatorWidth currentIndicatorWidth:(CGFloat)currentIndicatorWidth indicatorHeight:(CGFloat)indicatorHeight{
    if (self = [super initWithFrame:frame]) {
        _indicatorViews = [NSMutableArray array];
        _contentView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:_contentView];
        _numberOfPages = 0;
        _currentPage = 0;
        _pageIndicatorColor = [UIColor lightGrayColor];
        _currentPageIndicatorColor = [UIColor colorWithRed:31/255.f green:136/255.f blue:229/255.f alpha:1.f];
        _indicatorWidth = indicatorWidth; //普通宽度
        _indicatorMargin = margin; //间距
        _currentIndicatorWidth = currentIndicatorWidth;// 当前 宽度
        _indicatorHeight = indicatorHeight;
    }
    return self;
}

- (void)setCurrentPage:(NSInteger)currentPage{
    [self setCurrentPage:currentPage sendEvent:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage sendEvent:(BOOL)sendEvent{
    if (_currentPage == currentPage) {
        return;
    }
    _currentPage = MIN(currentPage, _numberOfPages - 1);
    CGFloat viewX = 0;
    for (NSInteger i = 0; i < _numberOfPages; i++) {
        UIView * view = self.indicatorViews[i];
        if (i == _currentPage) {
            view.frame = CGRectMake(viewX, 0, _currentIndicatorWidth, _indicatorHeight);
            viewX += _currentIndicatorWidth + _indicatorMargin;
            view.backgroundColor = _currentPageIndicatorColor;
        }else{
            view.frame = CGRectMake(viewX, 0, _indicatorWidth, _indicatorHeight);
            viewX += _indicatorWidth + _indicatorMargin;
            view.backgroundColor = _pageIndicatorColor;
        }
    }
    if (sendEvent) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages{
    numberOfPages = MAX(0, numberOfPages);
    if (_numberOfPages != numberOfPages) {
        
        _numberOfPages = numberOfPages;
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:self];
        [self.indicatorViews removeAllObjects];
        //总宽度
        CGFloat contentViewWidth = _currentIndicatorWidth + (numberOfPages-1)*_indicatorWidth + (numberOfPages-1)*_indicatorMargin;
        self.contentView.frame = CGRectMake(0, 0, contentViewWidth, _indicatorHeight);
        self.contentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, _indicatorHeight);
        
        CGFloat viewX = 0;
        for (NSInteger i = 0; i < numberOfPages; i++) {
            if (i == _currentPage) {
                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(viewX, 0, _currentIndicatorWidth, _indicatorHeight)];
                view.backgroundColor = _currentPageIndicatorColor;
                view.layer.cornerRadius = _indicatorHeight/2;
                view.layer.masksToBounds = YES;
                viewX += _currentIndicatorWidth + _indicatorMargin;
                [self.contentView addSubview:view];
                [self.indicatorViews addObject:view];
            }else{
                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(viewX, 0, _indicatorWidth, _indicatorHeight)];
                view.backgroundColor = _pageIndicatorColor;
                view.layer.cornerRadius = _indicatorHeight/2;
                view.layer.masksToBounds = YES;
                viewX += _indicatorWidth + _indicatorMargin;
                [self.contentView addSubview:view];
                [self.indicatorViews addObject:view];
            }
        }
        
    }
}

- (void)setScrollView:(UIScrollView *)scrollView{
    if (_scrollView != scrollView) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
        _scrollView = scrollView;
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    
    NSValue * oldOffsetValue = change[NSKeyValueChangeOldKey];
    CGPoint oldOffset = [oldOffsetValue CGPointValue];
    
    NSValue * newOffsetValue = change[NSKeyValueChangeNewKey];
    CGPoint newOffset = [newOffsetValue CGPointValue];
    
    CGFloat scrollViewWidth = [(UIScrollView *)object bounds].size.width;
    CGFloat rate = newOffset.x / scrollViewWidth;
    
    if (rate >= 0.0f && rate <= _numberOfPages - 1) {
        
        NSInteger currentIndex = (NSInteger)ceilf(rate);
        
        NSInteger lastIndex = (NSInteger)floorf(rate);
        if (currentIndex == lastIndex && currentIndex >= 1) {
            lastIndex -= 1;
        }
        
        UIView * currentView = self.indicatorViews[currentIndex];
        UIView * oldView = self.indicatorViews[lastIndex];
        CGRect currentFrame = currentView.frame;
        CGRect oldFrame = oldView.frame;
        
        
        CGFloat offSetX = (newOffset.x - oldOffset.x)*((_indicatorMargin+_indicatorWidth)/scrollViewWidth);
        if (offSetX < 0) {
            //  oldView 新的 宽度增加，新的左侧不动,currentView 旧的 宽度逐渐减小 ,右侧不动 即可
            
            if (oldFrame.size.width-offSetX <= self.currentIndicatorWidth) {
                oldView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width-offSetX, oldFrame.size.height);
            }
            
            if (currentFrame.size.width+offSetX >= self.indicatorWidth) {
                
                currentView.frame = CGRectMake(currentFrame.origin.x-offSetX, currentFrame.origin.y, currentFrame.size.width+offSetX, currentFrame.size.height);
            }
            
        }else{
            //currentView  新 的 宽度 增加 保持右侧不动,oldFrame 旧的宽度变小,origin.x逐渐 变大 以保持旧的左侧不动
            if (currentFrame.size.width+offSetX <= self.currentIndicatorWidth) {
                currentView.frame = CGRectMake(currentFrame.origin.x-offSetX, currentFrame.origin.y, currentFrame.size.width+offSetX, currentFrame.size.height);
            }
            if (oldFrame.size.width-offSetX >= self.indicatorWidth) {
                oldView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width-offSetX, oldFrame.size.height);
            }
            
        }
    }
    
}

- (void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}
@end
