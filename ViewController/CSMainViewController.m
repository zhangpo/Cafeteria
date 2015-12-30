//
//  CSMainViewController.m
//  Cafeteria
//
//  Created by chensen on 14/12/30.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSMainViewController.h"
#import "CSClassView.h"
#import "SMTabBarItem.h"
#import "CSClassView.h"
#import "CSLogViewShow.h"
#import "CSSettlementView.h"
#import "CSQueryView.h"
#import "CSVIPOperation.h"
#import "CSDetailView.h"

@interface CSMainViewController ()

@end

@implementation CSMainViewController
{
    NSArray *_viewArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDictionary * _pageConfig=[CSDataProvider loadData];
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            [CSDataProvider CSDataProviderShare].config=[_pageConfig objectForKey:@"Horizontal"];
        }else
        {
            [CSDataProvider CSDataProviderShare].config=[_pageConfig objectForKey:@"Vertical"];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    /**
     *  导航条
     */
    //图片
    NSArray *arrayImage=[[NSArray alloc] initWithObjects:@"dc.png",@"ydcp.png",@"js.png",@"wdcd.png",@"hycx.png", nil];
    //选择图片
    NSArray *arraySelectedImage=[[NSArray alloc] initWithObjects:@"dc_d.png",@"ydcp_d.png",@"js_d.png",@"wdcd_d.png",@"hycx_d.png", nil];
    //标题
    NSArray *arrayTitle=[[NSArray alloc] initWithObjects:@"类别",@"已点",@"结算",@"菜单",@"会员", nil];
    NSMutableArray *tabArray=[[NSMutableArray alloc] init];
    for (int i=0;i<5;i++) {
        SMTabBarItem *tab1=[[SMTabBarItem alloc] initWithImage:[UIImage imageNamed:[arrayImage objectAtIndex:i]] andTitle:[arrayTitle objectAtIndex:i]];
        tab1.selectedImage = [UIImage imageNamed:[arraySelectedImage objectAtIndex:i]];
        [tabArray addObject:tab1];
    }
    UIView *Master=[[UIView alloc]initWithFrame:CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"MainView"] objectForKey:@"MasterViewFrame"])];
    //类别
    CSClassView *class=[[CSClassView alloc] initWithFrame:CGRectMake(0, 0, Master.frame.size.width, Master.frame.size.height)];
    class.tag=1003;
    //显示账单
    CSLogViewShow *Log=[[CSLogViewShow alloc] initWithFrame:CGRectMake(0, 0, Master.frame.size.width, Master.frame.size.height)];
    class.tag=1004;
    //结算
    CSSettlementView *settlement=[[CSSettlementView alloc] initWithFrame:CGRectMake(0, 0, Master.frame.size.width, Master.frame.size.height)];
    class.tag=1005;
    //查账单
    CSQueryView *query=[[CSQueryView alloc] initWithFrame:CGRectMake(0, 0, Master.frame.size.width, Master.frame.size.height)];
    class.tag=1006;
    //会员操作
    CSVIPOperation *VIPOperation=[[CSVIPOperation alloc] initWithFrame:CGRectMake(0, 0, Master.frame.size.width, Master.frame.size.height)];
    class.tag=1007;
    _viewArray=[[NSArray alloc] initWithObjects:class,Log,settlement,query,VIPOperation, nil];
    Master.tag=1001;
    Master.userInteractionEnabled=YES;
    [self.view addSubview:Master];
    SMTabBarV *tabBar=[[SMTabBarV alloc] init];
    tabBar.delegate=self;
    tabBar.tabsButtons=tabArray;
    tabBar.tag=1000;
    SMTabBarItem *action2 = [[SMTabBarItem alloc] initWithActionBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出" message:@"你要退出程序吗?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        [alert show];
    } image:[UIImage imageNamed:@"tc.png"] andTitle:@"退出"];
    tabBar.actionsButtons=@[action2];
    tabBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:tabBar];
    [Master bringSubviewToFront:self.view];
    CSDetailView *DetailView=[[CSDetailView alloc] initWithFrame:CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"MainView"] objectForKey:@"DetailViewFrame"])];
    DetailView.tag=1002;
    [self.view addSubview:DetailView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFrame" object:nil];
}
#pragma mark - SMTabBarVDelegate
-(void)tabBar:(int)tag
{
    UIView *Master=[self.view viewWithTag:1001];
    UIView *view=[[Master subviews] lastObject];
    [view removeFromSuperview];
    view=nil;
    [Master addSubview:[_viewArray objectAtIndex:tag]];
    if (tag==0||tag==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:@"1"];
    }else if (tag==2){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:@"2"];
    }else if (tag==3){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:@"4"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChineseFoodQueryOrder" object:nil];
    }else if(tag==4){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:@"5"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OperationMove" object:nil];
        
    }
    [Master bringSubviewToFront:self.view];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [CSDataProvider CSDataProviderShare].foodsArray=nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    NSDictionary * _pageConfig=[CSDataProvider loadData];
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        [CSDataProvider CSDataProviderShare].config=[_pageConfig objectForKey:@"Horizontal"];
    }else
    {
        [CSDataProvider CSDataProviderShare].config=[_pageConfig objectForKey:@"Vertical"];
    }
    UIView *view=[self.view viewWithTag:1001];
    CGRect rect=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"MainView"] objectForKey:@"MasterViewFrame"]);
    view.frame=rect;
    view=[self.view viewWithTag:1002];
    view.frame=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"MainView"] objectForKey:@"DetailViewFrame"]);
    view=[self.view viewWithTag:1003];
    view.frame=CGRectMake(0, 0, rect.size.width, rect.size.height);
    view=[self.view viewWithTag:1004];
    view.frame=CGRectMake(0, 0, rect.size.width, rect.size.height);
    view=[self.view viewWithTag:1005];
    view.frame=CGRectMake(0, 0, rect.size.width, rect.size.height);
    view=[self.view viewWithTag:1006];
    view.frame=CGRectMake(0, 0, rect.size.width, rect.size.height);
    view=[self.view viewWithTag:1007];
    view.frame=CGRectMake(0, 0, rect.size.width, rect.size.height);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFrame" object:nil];
}

@end
