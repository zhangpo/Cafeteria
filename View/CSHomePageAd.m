//
//  CSHomePageAd.m
//  Cafeteria
//
//  Created by chensen on 14/12/3.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSHomePageAd.h"
#import "CSDataProvider.h"


@implementation CSHomePageAd
{
    NSMutableArray *_viewsArray;
    NSMutableArray *_homeArray;
}
@synthesize mainScorllView=_mainScorllView,homeScorllView=_homeScorllView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _viewsArray = [@[] mutableCopy];
        NSArray *colorArray = @[[UIColor cyanColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor purpleColor]];
        for (int i = 0; i < 5; ++i) {
            UIImageView *image=[[UIImageView alloc] initWithFrame:self.frame];
            [image setImage:[CSDataProvider imgWithContentsOfImageName:[NSString stringWithFormat:@"PageAd%d.jpg",i]]];
//            UILabel *tempLabel = [[UILabel alloc] initWithFrame:self.frame];
//            tempLabel.backgroundColor = [(UIColor *)[colorArray objectAtIndex:i] colorWithAlphaComponent:0.5];
            [_viewsArray addObject:image];
        }
        
        _mainScorllView = [[CycleScrollView alloc] initWithFrame:self.frame animationDuration:4];
        _mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        
        _mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return _viewsArray[pageIndex];
        };
        _mainScorllView.totalPagesCount = ^NSInteger(void){
            return 5;
        };
        _mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"点击了第%d个",pageIndex);
        };
        [self addSubview:_mainScorllView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
    }
    return self;
}
- (id)initHomeAdWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _homeArray = [@[] mutableCopy];
        NSArray *colorArray = @[[UIColor cyanColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor purpleColor]];
        for (int i = 0; i < 5; ++i) {
            UIImageView *image=[[UIImageView alloc] initWithFrame:self.frame];
            UIImage *img=[CSDataProvider imgWithContentsOfImageName:[NSString stringWithFormat:@"PageAd%d.jpg",i]];
            [image setImage:img];
            //            UILabel *tempLabel = [[UILabel alloc] initWithFrame:self.frame];
            //            tempLabel.backgroundColor = [(UIColor *)[colorArray objectAtIndex:i] colorWithAlphaComponent:0.5];
            [_homeArray addObject:image];
        }
        
        _homeScorllView = [[CycleScrollView alloc] initWithFrame:self.frame animationDuration:4];
        _homeScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        
        _homeScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return _homeArray[pageIndex];
        };
        _homeScorllView.totalPagesCount = ^NSInteger(void){
            return 5;
        };
        _homeScorllView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"点击了第%d个",pageIndex);
        };
        [self addSubview:_homeScorllView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
    }
    return self;
}
-(void)ChangeFrame
{
    if (_mainScorllView) {
        CGRect frame=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"MainView"] objectForKey:@"DetailViewFrame"]);
        //    self.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        _mainScorllView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        _mainScorllView.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _mainScorllView.scrollView.contentOffset = CGPointMake(0, 0);
        for (UIImageView *view in _viewsArray) {
            view.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        }

    }
    if (_homeScorllView) {
        if ([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortrait||[[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortraitUpsideDown) {
            self.frame=CGRectMake(0, 0, 768, 1024);
            _homeScorllView.frame=self.frame;
            _homeScorllView.scrollView.contentSize = CGSizeMake(768,1024);
            _homeScorllView.scrollView.contentOffset = CGPointMake(0, 0);
            int i=0;
            for (UIImageView *view in _homeArray) {
                [view setImage:[CSDataProvider imgWithContentsOfImageName:[NSString stringWithFormat:@"PageAd%d_v.jpg",i]]];
                view.frame=CGRectMake(0, 0,768, 1024);
                i++;
            }
            
        }else
        {
            self.frame=CGRectMake(0, 0,1024, 768);
            _homeScorllView.frame=self.frame;
            _homeScorllView.scrollView.contentSize = CGSizeMake(1024,768);
            _homeScorllView.scrollView.contentOffset = CGPointMake(0,0);
            int i=0;
            for (UIImageView *view in _homeArray) {
                [view setImage:[CSDataProvider imgWithContentsOfImageName:[NSString stringWithFormat:@"PageAd%d.jpg",i]]];
                view.frame=CGRectMake(0, 0,1024, 768);
                i++;
            }
            
            //        [CSDataProvider CSDataProviderShare].config=[_pageConfig objectForKey:@"Vertical"];
        }
    }
   
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
