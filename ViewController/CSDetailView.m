//
//  CSOrderViewController.m
//  Cafeteria
//
//  Created by chensen on 14/11/3.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSDetailView.h"
#import "CSDataProvider.h"
#import "CSClassView.h"
#import "CSOrderView.h"
#import "CSChinesefoodPack.h"
#import "CSPackageView.h"
#import "CSVipCard.h"
#import "CSHomePageAd.h"
#import "NSTimer+Addition.h"
#import "CSVIPUserinfoView.h"
#import "CSHistoryOrderView.h"

@interface CSDetailView ()

@end

@implementation CSDetailView
{
    NSDictionary *_pageConfig;
    CSOrderView *_orderView;
    CSVipCard   *_vipCard;
    CSHomePageAd *_ad;
    CSVIPUserinfoView *_userInfo;
    CSHistoryOrderView *_history;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        //点菜
        _orderView=[[CSOrderView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _orderView.tag=1001;
        [self addSubview:_orderView];
        //会员卡
        _vipCard=[[CSVipCard alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _vipCard.tag=1002;
        //广告
        _ad=[[CSHomePageAd alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _ad.tag=1003;
        [_ad.mainScorllView.animationTimer pauseTimer];
        //用户信息
        _userInfo=[[CSVIPUserinfoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _userInfo.tag=1005;
        //历史记录
        _history=[[CSHistoryOrderView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _history.tag=1006;
        //横屏竖屏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
        //套餐
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(package:) name:@"package" object:nil];
        //关闭视图
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissView) name:@"dismissView" object:nil];
        //大图小图转换
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeModel:) name:@"changeModel" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView:) name:@"changeView" object:nil];
       
    }
    return self;
}

#pragma mark - 改变视图
-(void)changeView:(NSNotification *)notification
{
    NSInteger i = [[notification object] intValue];
    if (i==1) {
        [self orderView];
    }else if (i==2)
    {
        [self VipCard];
        UIView *view=[[self subviews] lastObject];
        view.userInteractionEnabled=YES;
    }else if (i==4)
    {
        [self ShowAd];
    }else if (i==5)
    {
        [self userInfo];
    }else if (i==6)
    {
        [self HistoryOrder];
    }else if (i==27)
    {
        [self VipCard];
        UIView *view=[[self subviews] lastObject];
        view.userInteractionEnabled=NO;
    }
}

#pragma mark - 显示会员券
-(void)VipCard
{
    UIView *view=[[self subviews] lastObject];
    if (![view isKindOfClass:[CSVipCard class]]) {
        if ([view isKindOfClass:[CSHomePageAd class]]) {
            CSHomePageAd *home=(CSHomePageAd *)[self viewWithTag:1003];
            [home.mainScorllView.animationTimer pauseTimer];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCVipCard" object:nil];
        [view removeFromSuperview];
        [self addSubview:_vipCard];
    }
}
#pragma mark - 广告
-(void)ShowAd
{
    
    UIView *view=[[self subviews] lastObject];
    if (![view isKindOfClass:[CSHomePageAd class]]) {
        [view removeFromSuperview];
        [_ad.mainScorllView.animationTimer resumeTimer];
        [self addSubview:_ad];
    }
}
#pragma mark - 套餐
/**
 *  套餐
 */
-(void)package:(NSNotification *)notification
{
    NSDictionary *dic = [notification object];
    if (![dic objectForKey:@"PACKID"]) {
        
        CSPackageView *package=[[CSPackageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) withPackage:dic];
        package.tag=1004;
        [self addSubview:package];
        [package bringSubviewToFront:self];
    }else
    {
        CSChinesefoodPack *package=[[CSChinesefoodPack alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) withPackage:dic];
        package.tag=1004;
        [self addSubview:package];
        [package bringSubviewToFront:self];
    }
    
}
#pragma mark - 显示会员信息
-(void)userInfo
{
    UIView *view=[[self subviews] lastObject];
    if (![view isKindOfClass:[CSVIPUserinfoView class]]) {
        if ([view isKindOfClass:[CSHomePageAd class]]) {
            CSHomePageAd *home=(CSHomePageAd *)[self viewWithTag:1003];
            [home.mainScorllView.animationTimer pauseTimer];
        }
        [view removeFromSuperview];
        [self addSubview:_userInfo];
    }
}
#pragma mark - 显示会员历史账单
-(void)HistoryOrder
{
    UIView *view=[[self subviews] lastObject];
    if (![view isKindOfClass:[CSHistoryOrderView class]]) {
        if ([view isKindOfClass:[CSHomePageAd class]]) {
            CSHomePageAd *home=(CSHomePageAd *)[self viewWithTag:1003];
            [home.mainScorllView.animationTimer pauseTimer];
        }
        [view removeFromSuperview];
        [self addSubview:_history];
    }
}
#pragma mark - 显示点餐
-(void)orderView
{
    UIView *view=[[self subviews] lastObject];
    if (![view isKindOfClass:[CSOrderView class]]) {
        if ([view isKindOfClass:[CSHomePageAd class]]) {
            CSHomePageAd *home=(CSHomePageAd *)[self viewWithTag:1003];
            [home.mainScorllView.animationTimer pauseTimer];
        }
        [view removeFromSuperview];
        [self addSubview:_orderView];
    }
}


#pragma mark - 改变模式通知
-(void)changeModel:(NSNotification *)notification
{
    NSDictionary *dic = [notification object];
}
#pragma mark - 关闭视图的通知
-(void)dismissView
{
    UIView *view=[self.subviews lastObject];
    [view removeFromSuperview];
    view=nil;
    
}
#pragma mark - 改变位置的通知
/**
 *  改变大小的
 */
-(void)ChangeFrame
{
//    CSOrderView *view=(CSOrderView *)[self viewWithTag:1001];
    NSDictionary *dict=[CSDataProvider CSDataProviderShare].config;
    self.frame=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"MainView"] objectForKey:@"DetailViewFrame"]);
    UIView *view=[self.subviews lastObject];
    view.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

-(void)dealloc
{
    UIView *view=[[self subviews] lastObject];
    if ([view isKindOfClass:[CSHomePageAd class]]) {
        CSHomePageAd *home=(CSHomePageAd *)[self viewWithTag:1003];
        [home.mainScorllView.animationTimer pauseTimer];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//
//-(void)willAnimateRotationToInterfaceOrientation(UIInterfaceOrientation)interfaceOrientation
//duration:(NSTimeInterval)duration
//{
//    
//}

@end
