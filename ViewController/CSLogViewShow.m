//
//  CSLogViewController.m
//  Cafeteria
//
//  Created by chensen on 14/11/13.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSLogViewShow.h"
#import "CSLogView.h"
#import "CSNetWork.h"
#import "SVProgressHUD.h"
#import "CSDataProvider.h"

@interface CSLogViewShow ()

@end

@implementation CSLogViewShow
{
    UITableView *_tableView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"CheckOrdersView"];
        CSLogView *log=[[CSLogView alloc] initAdditionWithFrame:CGRectFromString([dict objectForKey:@"ViewFrame"])];
        log.tag=100;
        [self addSubview:log];
        UIImageView *priceImage=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"OrdersPriceFrame"])];
        priceImage.tag=102;
        [priceImage setImage:[UIImage imageNamed:@"ydcpPrice.png"]];
        [self addSubview:priceImage];
        UILabel *lblPrice=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"OrdersPriceFrame"])];
        lblPrice.textAlignment=NSTextAlignmentLeft;
        //    lblPrice.backgroundColor=[UIColor redColor];
        lblPrice.tag=103;
        lblPrice.backgroundColor=[UIColor clearColor];
        lblPrice.textColor=[UIColor whiteColor];
        [self addSubview:lblPrice];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=lblPrice.frame;
        button.backgroundColor=[UIColor clearColor];
        [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfReloadData) name:@"reloadData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
    }
    return self;
}
-(void)btnClick
{
//    [[CSNetWork shareCSNetWork] ChineseFoodSendOrder];
    [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(ZCsendFood) toTarget:self withObject:nil];
    
    
}
/**
 *  发送菜品
 */
-(void)ZCsendFood
{
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare] ZCSend];
    [SVProgressHUD dismiss];
    if (!dict) {
        [SVProgressHUD showErrorWithStatus:[CSDataProvider localizedString:@"ConnectionTimeout"]];
        return;
    }
    if (dict) {
        if ([[dict objectForKey:@"state"] intValue]==1) {
            [CSDataProvider CSDataProviderShare].foodsArray=nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectRow" object:@"2"];
        }else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
        }
    }
}
-(void)ChangeFrame
{
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"CheckOrdersView"];
    UIView *view=[self viewWithTag:100];
    view.frame=CGRectFromString([dict objectForKey:@"ViewFrame"]);
    view=[self viewWithTag:103];
    view.frame=CGRectFromString([dict objectForKey:@"OrdersPriceFrame"]);
    UIImageView *imageView=(UIImageView *)[self viewWithTag:102];
    imageView.frame=CGRectFromString([dict objectForKey:@"OrdersPriceFrame"]);
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    //改变详情的通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:@"1"];
//}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)selfReloadData
{
    float i=0.00;
    for (NSDictionary *dict in [CSDataProvider CSDataProviderShare].foodsArray) {
        i+=[[dict objectForKey:@"total"] intValue]*[[dict objectForKey:@"PRICE"]floatValue];
    }
    UILabel *lb=(UILabel *)[self viewWithTag:103];
    lb.text=[NSString stringWithFormat:@"    ￥%.2f",i];
}

@end
