//
//  CSHomePageAdViewController.m
//  Cafeteria
//
//  Created by chensen on 14/12/3.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSHomePageAdViewController.h"
#import "CSHomePageAd.h"
#import "CSLoginViewController.h"
#import "NSTimer+Addition.h"
#import "HMDLoginViewController.h"
#import "CSMainViewController.h"
#import "CSDataProvider.h"


@interface CSHomePageAdViewController ()

@end

@implementation CSHomePageAdViewController
{
    NSMutableArray *_homeArray;
    NHSlideShow *slideShow;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    _homeArray = [@[] mutableCopy];
    //    button.backgroundColor=[UIColor blackColor];
    //    jump.png
    button.tag=99;
    [button setImage:[CSDataProvider imgWithContentsOfImageName:@"jump.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        self.view.frame=CGRectMake(0, 0, 1024, 768);
        button.frame=CGRectMake(900,50 , 80, 80);
        for (int i = 0; i < 5; ++i) {
            UIImage *img=[CSDataProvider imgWithContentsOfImageName:[NSString stringWithFormat:@"PageAd%d.jpg",i]];
            [_homeArray addObject:img];
        }
    }else
    {
        self.view.frame=CGRectMake(0, 0, 768, 1024);
        button.frame=CGRectMake(600,50 , 80, 80);
        for (int i = 0; i < 5; ++i) {
            UIImage *img=[CSDataProvider imgWithContentsOfImageName:[NSString stringWithFormat:@"PageAd%d_v.jpg",i]];
            [_homeArray addObject:img];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrame) name:@"changeFrame" object:nil];
    slideShow = [[NHSlideShow alloc] initWithFrame:self.view.frame];
    [slideShow setDelayInTransition:3.0f];
    slideShow.delegate=self;
    [slideShow setSlideShowMode:NHSlideShowModeRandom];
    [slideShow slidesWithImages:_homeArray];
    [self.view addSubview:slideShow];
    [self.view sendSubviewToBack:slideShow];
    [self.view addSubview:button];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [slideShow doneLayout];
    [slideShow start];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [slideShow start];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFrame" object:nil];
}
-(void)btnClick:(UIButton *)btn
{
//    HMDLoginViewController *login=[[HMDLoginViewController alloc] init];
    CSLoginViewController *login=[[CSLoginViewController alloc] init];
    [slideShow stop];
//    CSHomePageAd *home=(CSHomePageAd *)[self.view viewWithTag:100];
//    [home.homeScorllView.animationTimer pauseTimer];
    [self.navigationController pushViewController:login animated:YES];
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFrame" object:nil];
    
}
-(void)changeFrame
{
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        self.view.frame=CGRectMake(0, 0, 1024, 768);
        UIView *view=[self.view viewWithTag:99];
        view.frame=CGRectMake(900,50 , 80, 80);
        view=[self.view viewWithTag:100];
        view.frame=CGRectMake(0, 0, 1024, 768);
        
        [_homeArray removeAllObjects];
        for (int i = 0; i < 5; ++i) {
            UIImage *img=[CSDataProvider imgWithContentsOfImageName:[NSString stringWithFormat:@"PageAd%d.jpg",i]];
            [_homeArray addObject:img];
        }
        slideShow.frame=self.view.frame;
        [slideShow slidesWithImages:_homeArray];
        
    }else
    {
        self.view.frame=CGRectMake(0, 0, 768, 1024);
        UIView *view=[self.view viewWithTag:99];
        view.frame=CGRectMake(600,50 , 80, 80);
        view=[self.view viewWithTag:100];
        view.frame=CGRectMake(0, 0, 768, 1024);
        [_homeArray removeAllObjects];
        for (int i = 0; i < 5; ++i) {
            UIImage *img=[CSDataProvider imgWithContentsOfImageName:[NSString stringWithFormat:@"PageAd%d_v.jpg",i]];
            [_homeArray addObject:img];
        }
        slideShow.frame=self.view.frame;
        [slideShow slidesWithImages:_homeArray];
    }

}

@end
