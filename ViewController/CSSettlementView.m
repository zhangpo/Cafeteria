//
//  CSSettlementViewController.m
//  Cafeteria
//
//  Created by chensen on 14/12/24.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//
//
/*
 
 */

#import "CSSettlementView.h"
#import "CSLogView.h"
#import "SVProgressHUD.h"
#import "CSDataProvider.h"
#import "AFNetworking.h"
#import "XMLDictionary.h"


@interface CSSettlementView ()

@end

@implementation CSSettlementView
{
    float totalOrder;           //账单金额
    float couponConsumption;    //券消费
    float integralConsumption;  //积分消费
    float remainingAmount;      //剩余金额
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"Settlement"];
        CSLogView *log=[[CSLogView alloc] initPriceWithFrame:CGRectFromString([dict objectForKey:@"ViewFrame"])];
        [self addSubview:log];
        log.tag=100;
        [self settlementDataView];
        //刷新中餐结算信息通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfReloadData) name:@"ZCQueryOrder" object:nil];
        //改变屏幕方向
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrame) name:@"changeFrame" object:nil];
    }
    return self;
}
#pragma mark - 改变位置
-(void)changeFrame
{
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"Settlement"];
    UIView *view=[self viewWithTag:100];
    view.frame=CGRectFromString([dict objectForKey:@"ViewFrame"]);
    view=[self viewWithTag:998];
    view.frame=CGRectFromString([dict objectForKey:@"OrdersView"]);
//    view=[self viewWithTag:1000];
//    view.frame=
}
#pragma mark - 支付方式显示
-(void)settlementDataView
{
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"Settlement"];
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1];
    view.frame=CGRectFromString([dict objectForKey:@"OrdersView"]);
    view.tag=998;
    [self addSubview:view];
    NSArray *array=[[NSArray alloc] initWithObjects:@"账单金额",@"积分支付",@"券支付",@"储值需支付", nil];
    int i=0;
    for (NSString *str in array) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0+25*i, 100, 25)];
        label.text=str;
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont systemFontOfSize:20];
        [view addSubview:label];
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(110, 0+25*i, 140, 25)];
        label1.textAlignment=NSTextAlignmentRight;
        label1.backgroundColor=[UIColor clearColor];
        label1.textColor=[UIColor whiteColor];
        label1.font=[UIFont systemFontOfSize:20];
        label1.tag=2000+i;
        [view addSubview:label1];
        
        i++;
    }
    for (int i=1; i<3; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(10+120*(i-1), 105, 110, 50);
        //        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.tag=i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"settlement%d",i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
}

-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==1) {
        if ([[CSDataProvider CSDataProviderShare].SAVETIME intValue]+60>[[NSDate date] timeIntervalSince1970]) {
            [CSDataProvider CSDataProviderShare].SAVETIME=[NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
            [self cardOutAmt];
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:[CSDataProvider localizedString:@"OK"], nil];
            alert.alertViewStyle=UIAlertViewStyleSecureTextInput;
            alert.tag=100;
            [alert show];
        }
    }else if (btn.tag==2){
        if ([[CSDataProvider CSDataProviderShare].SAVETIME intValue]+60>[[NSDate date] timeIntervalSince1970]) {
            [CSDataProvider CSDataProviderShare].SAVETIME=[NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
            [self cancelPayment];
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:[CSDataProvider localizedString:@"OK"], nil];
            alert.alertViewStyle=UIAlertViewStyleSecureTextInput;
            alert.tag=101;
            [alert show];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            UITextField *tf1=[alertView textFieldAtIndex:0];
            [CSDataProvider CSDataProviderShare].cardWord=tf1.text;
            [self cardOutAmt];
        }
    }
    if (alertView.tag==101) {
        if (buttonIndex==1) {
            UITextField *tf1=[alertView textFieldAtIndex:0];
            [CSDataProvider CSDataProviderShare].cardWord=tf1.text;
            [self cancelPayment];
        }
    }
}
#pragma mark - 取消支付
-(void)cancelPayment
{
    [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(cancelPaymentRequest) toTarget:self withObject:nil];
}
-(void)cancelPaymentRequest
{
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare] ZCcancelPayment];
    [SVProgressHUD dismiss];
    if (!dict) {
        [SVProgressHUD showErrorWithStatus:[CSDataProvider localizedString:@"ConnectionTimeout"]];
        return;
    }
    if ([[dict objectForKey:@"state"] intValue] ==1) {
//        [CSDataProvider CSDataProviderShare].VIPINFO=[dict objectForKey:@"msg"];
        [CSDataProvider CSDataProviderShare].SAVETIME=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        [self selfReloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCVipCard" object:nil];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"取消支付失败" message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
}
#pragma mark - 储值支付支付
-(void)cardOutAmt
{
    [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(cardOutAmtRequest) toTarget:self withObject:nil];
}
-(void)cardOutAmtRequest
{
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare] ZCcardOutAmt];
    [SVProgressHUD dismiss];
    if (!dict) {
        [SVProgressHUD showErrorWithStatus:[CSDataProvider localizedString:@"ConnectionTimeout"]];
        return;
    }
    if ([[dict objectForKey:@"state"] intValue] ==1) {
//        [CSDataProvider CSDataProviderShare].VIPINFO=[dict objectForKey:@"msg"];
        [CSDataProvider CSDataProviderShare].SAVETIME=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCVipCard" object:nil];
        //跳转到账单
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectRow" object:@"3"];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"支付失败" message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
}
//#pragma mark - 储值支付
//-(void)cardOutAmt
//{
//    [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeBlack];
//    
//    NSString *pwd=[CSDataProvider CSDataProviderShare].cardWord;
//    NSString *weatherUrl1=[NSString stringWithFormat:@"%@cardOutAmt?padid=%@&cardno=%@&pwd=%@&amt=%.2f&payment=1&nbzero=0&conacct=%@&billno=%@",[CSDataProvider ZCCafeteriaWebServiceIP],[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],[CSDataProvider CSDataProviderShare].cardNum,pwd,remainingAmount,[[NSUserDefaults standardUserDefaults] objectForKey:@"POSID"],[CSDataProvider CSDataProviderShare].billNo];
//    NSURLRequest* request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:[weatherUrl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    NSLog(@"%@",weatherUrl1);
//    AFHTTPRequestOperation* operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
//    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
////        NSDictionary *dicInfo1 = [NSDictionary dictionaryWithXMLData:operation.responseData];
//        [SVProgressHUD dismiss];
//        NSData *jsonData = [[[NSDictionary dictionaryWithXMLData:operation.responseData] objectForKey:@"ns:return"] dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *err;
//        NSDictionary *dic = [[NSJSONSerialization JSONObjectWithData:jsonData
//                                                             options:NSJSONReadingMutableContainers
//                                                               error:&err] objectForKey:@"result"];
//        if(err) {
//            NSLog(@"json解析失败：%@",err);
//        }else
//        {
//            if ([[dic objectForKey:@"state"] intValue] ==1) {
//                [CSDataProvider CSDataProviderShare].VIPINFO=[dic objectForKey:@"msg"];
//                [CSDataProvider CSDataProviderShare].cardWord=pwd;
//                [CSDataProvider CSDataProviderShare].SAVETIME=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
//            }else
//            {
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"支付失败" message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
//                [alert show];
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络连接超时"];
//    }];
//    [operation1 start];
//}
#pragma mark - 获取数据
-(void)selfReloadData
{
    [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeClear];
    [self queryArray];
}
#pragma mark - 显示菜品及计算余额
-(void)queryArray
{
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare] ChineseFoodQueryOrder:@"1"];
    [SVProgressHUD dismiss];
    if (!dict) {
        [SVProgressHUD showErrorWithStatus:[CSDataProvider localizedString:@"ConnectionTimeout"]];
        return;
    }
    [CSDataProvider CSDataProviderShare].foodQueryArray=nil;
    if ([[dict objectForKey:@"state"] intValue]==1) {
        if ([[dict objectForKey:@"foodList"] count]>0) {
            [CSDataProvider CSDataProviderShare].foodQueryArray=[dict objectForKey:@"foodList"];
        }
    }
    totalOrder=0.00;
    for (NSDictionary *dict in [CSDataProvider CSDataProviderShare].foodQueryArray) {
        totalOrder+=[[dict objectForKey:@"AMT"] floatValue];
    }
    integralConsumption=[[[dict objectForKey:@"payment"] objectForKey:@"PAYAMT"] floatValue];
    couponConsumption=[[[dict objectForKey:@"payment"] objectForKey:@"AMT"] floatValue];
    remainingAmount=totalOrder-couponConsumption-integralConsumption;
    //判断如果结算完成跳到账单界面
    if (remainingAmount==0) {
        [CSDataProvider CSDataProviderShare].foodQueryArray=nil;
        
    }

    [CSDataProvider CSDataProviderShare].remainingAmount=remainingAmount;
    UILabel *label=(UILabel *)[[self viewWithTag:998] viewWithTag:2000];
    label.text=[NSString stringWithFormat:@"%.2f",totalOrder];
    label=(UILabel *)[[self viewWithTag:998] viewWithTag:2001];
    label.text=[NSString stringWithFormat:@"%.2f",integralConsumption];
    label=(UILabel *)[[self viewWithTag:998] viewWithTag:2002];
    label.text=[NSString stringWithFormat:@"%.2f",couponConsumption];
    label=(UILabel *)[[self viewWithTag:998] viewWithTag:2003];
    label.text=[NSString stringWithFormat:@"%.2f",remainingAmount];
    UITableView *table=(UITableView *)[[self viewWithTag:100] viewWithTag:901];
    [table reloadData];
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
