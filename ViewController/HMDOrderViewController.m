//
//  HMDOrderViewController.m
//  Cafeteria
//
//  Created by chensen on 14/12/2.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "HMDOrderViewController.h"
#import "CSOrderView.h"
#import "CSDataProvider.h"
#import "AFNetworking.h"
#import "CSLogView.h"
#import "CSClassView.h"
#import "CSPackageView.h"
#import "AFAppDotNetAPIClient.h"


@interface HMDOrderViewController ()

@end

@implementation HMDOrderViewController

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    //已点菜品的view
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,1024, 768)];
    [imageView setImage:[UIImage imageNamed:@"OrderBG.png"]];
    [self.view addSubview:imageView];
    CSLogView *log=[[CSLogView alloc] initAdditionWithFrame:CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"CheckOrdersView"] objectForKey:@"ViewFrame"])];
    [self.view addSubview:log];
    //确认取消按钮
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 690,260, 50);
    button.tag=1;
    button.backgroundColor=[UIColor clearColor];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //点菜
    CSOrderView *orderView=[[CSOrderView alloc] initWithFrame:CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"OrderView"] objectForKey:@"ViewFrame"])];
    orderView.tag=1001;
    [self.view addSubview:orderView];
    
    
    
    //横屏竖屏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"ChangeFrame" object:nil];
    //套餐通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(package:) name:@"package" object:nil];
    //关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissView) name:@"dismissView" object:nil];
    //大图小图通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeModel:) name:@"changeModel" object:nil];
    CSClassView *classView=[[CSClassView alloc] initWithFrame:CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"ClassView"] objectForKey:@"ViewFrame"])];
    [self.view addSubview:classView];
    
}
#pragma mark - 确认取消按钮事件
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==1) {
        HMDOrder *order=[[HMDOrder alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        order.tag=10000;
        order.delegate=self;
        [self.view addSubview:order];
    }else
    {
        [CSDataProvider CSDataProviderShare].foodsArray=nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - OrderDelegate 发送菜品，取消
-(void)OrderButtonClick:(UIButton *)btn{
    if (btn.tag==0) {
        UIView *view=[self.view viewWithTag:10000];
        [view removeFromSuperview];
        view=nil;
    }else
    {
        if ([[CSDataProvider CSDataProviderShare].foodsArray count]==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请选择完菜品后再下单" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        [SVProgressHUD showProgress:-1 status:@"菜品上传中" maskType:SVProgressHUDMaskTypeBlack];
        [self getOrderstableNum];
        
    }
}
-(void)getOrderstableNum
{
    NSString *pdaid = [NSString stringWithFormat:@"%@@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"POSID"]];
    NSString *weatherUrl1 =[NSString stringWithFormat:@"%@getOrdersBytabNum?deviceId=%@&userCode=&tableNum=",[[CSDataProvider CSDataProviderShare] HMDwebServiceIP],pdaid];
    NSURLRequest* request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:[weatherUrl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    AFHTTPRequestOperation* operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
    //设置下载完成调用的block
    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicInfo1 = [NSDictionary dictionaryWithXMLData:operation.responseData];
        if (dicInfo1) {
            NSString *str1=[dicInfo1 objectForKey:@"ns:return"];
            NSArray *array1=[str1 componentsSeparatedByString:@"@"];
            if ([[array1 objectAtIndex:0] intValue]==0) {
                [self sendFood:@""];
            }else{
                [SVProgressHUD showSuccessWithStatus:[array1 lastObject]];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接超时"];
    }];
    [operation1 start];
}
-(void)sendFood:(NSString *)orderId
{
    NSString *weatherUrl1 =[NSString stringWithFormat:@"%@sendc%@",[[CSDataProvider CSDataProviderShare] HMDwebServiceIP],[[CSDataProvider CSDataProviderShare] sendFoodString:orderId]];
    NSURLRequest* request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:[weatherUrl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    AFHTTPRequestOperation* operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
    //设置下载完成调用的block
    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicInfo1 = [NSDictionary dictionaryWithXMLData:operation.responseData];
        if (dicInfo1) {
            NSString *str1=[dicInfo1 objectForKey:@"ns:return"];
            NSArray *array1=[str1 componentsSeparatedByString:@"@"];
            if ([[array1 objectAtIndex:0] intValue]==0) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"本次点餐成功，欢迎你再次光临"];
                UIView *view=[self.view viewWithTag:1000];
                [view removeFromSuperview];
                view=nil;
                [CSDataProvider CSDataProviderShare].foodsArray=nil;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showSuccessWithStatus:[array1 lastObject]];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接超时"];
    }];
    [operation1 start];
}



#pragma mark - 套餐
/**
 *  套餐
 */
-(void)package:(NSNotification *)notification
{
    NSDictionary *dic = [notification object];
    if ([[dic objectForKey:@"ISTC"]intValue]==1) {
        CSPackageView *package=[[CSPackageView alloc] initWithFrame:CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"PackageView"] objectForKey:@"ViewFrame"]) withPackage:dic];
        package.tag=1002;
        [self.view addSubview:package];
        [package bringSubviewToFront:self.view];
    }
    
}
#pragma mark - 改变模式通知
-(void)changeModel:(NSNotification *)notification
{
    NSDictionary *dic = [notification object];
    
    
}
#pragma mark - 关闭套餐视图
-(void)dismissView
{
    UIView *view=[self.view viewWithTag:1002];
    [view removeFromSuperview];
    view=nil;
    
}
-(void)ChangeFrame
{
    CSOrderView *view=(CSOrderView *)[self.view viewWithTag:1001];
    NSDictionary *dict=[CSDataProvider CSDataProviderShare].config;
    view.frame=CGRectFromString([[dict objectForKey:@"OrderView"] objectForKey:@"ViewFrame"]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeViewFrame" object:nil];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
