//
//  CSVipCard.m
//  Cafeteria
//
//  Created by chensen on 14/12/25.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSVipCard.h"
#import "CSTicketsCell.h"
#import "CSDataProvider.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "CSNetWork.h"
#import "CSOrderReusableView.h"
//--SELECT * from ACTM a WHERE a.VVOUCHERDISC='Y' //券
//--SELECT VFENBACK,VNAME from ACTM a where a.VFENBACK='Y' //反积分
//--SELECT * FROM ACTM a WHERE a.VFENDISC='Y' 积分消费
/**
 *  积分   VNDERATENUM减免金额   VFENBACK反积分    VATWILL是否积分  IFENDISCNUM积分优惠
 */

@implementation CSVipCard
{
    UICollectionView *_collectionV;
    NSArray *dataArray;
    NSDictionary *selectDic;//选择的菜品
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //背景图片
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.frame];
        imageView.tag=2000;
        [imageView setImage:[CSDataProvider imgWithContentsOfImageName:@"VipBG.png"]];
        [self addSubview:imageView];
        //储值背景
        UIImageView *imgV=[[UIImageView alloc] initWithFrame:CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"VipCard"] objectForKey:@"Stored-valueImageFrame"])];
        [imgV setImage:[CSDataProvider imgWithContentsOfImageName:@"VipCard1.png"]];
        imgV.tag=2001;
        [self addSubview:imgV];
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(imgV.frame.origin.x+40, imgV.frame.origin.y+2,imgV.frame.size.width-40, imgV.frame.size.height)];
        lb.tag=2003;
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor=[UIColor whiteColor];
        lb.font=[UIFont systemFontOfSize:30];
        lb.textAlignment=NSTextAlignmentCenter;
        [self addSubview:lb];
        //积分背景
        UIImageView *imgV1=[[UIImageView alloc] initWithFrame:CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"VipCard"] objectForKey:@"IntegralImageFrame"])];
        [imgV1 setImage:[CSDataProvider imgWithContentsOfImageName:@"VipCard2.png"]];
        imgV1.tag=2002;
        [self addSubview:imgV1];
        UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(imgV1.frame.origin.x+40, imgV1.frame.origin.y+2,imgV1.frame.size.width-40, imgV1.frame.size.height)];
        lb1.tag=2004;
        lb1.textColor=[UIColor whiteColor];
        lb1.font=[UIFont systemFontOfSize:30];
        lb1.textAlignment=NSTextAlignmentCenter;
        lb1.backgroundColor=[UIColor clearColor];
        [self addSubview:lb1];
        //券积分显示
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"VipCard"] objectForKey:@"ItemSize"]);
        flowLayout.minimumInteritemSpacing = 0;//列距
        flowLayout.headerReferenceSize=CGSizeMake(0.001,60);
        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"VipCard"] objectForKey:@"CollectionViewFrame"]) collectionViewLayout:flowLayout];
        [_collectionV registerClass:[CSTicketsCell class] forCellWithReuseIdentifier:@"colletionCell"];
        [_collectionV registerClass:[CSOrderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];//头视图
        
        _collectionV.backgroundColor = [UIColor clearColor];
        _collectionV.dataSource = self;
        _collectionV.delegate = self;
        [self addSubview:_collectionV];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZCqueryVip) name:@"ZCVipCard" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrame) name:@"changeFrame" object:nil];
        
    }
    return self;
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [dataArray count];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[dataArray objectAtIndex:section] count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdetify = @"colletionCell";
    CSTicketsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
    if (indexPath.section==0) {
        [cell setIntegralData:[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    }else
    {
        [cell setDataDic:[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        CSOrderReusableView *headerView=nil;
        headerView= [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *title = nil;
        if (indexPath.section==0) {
            title=@"     积分消费     ";
        }else
        {
            title=@"     券消费     ";
        }
        headerView.label.text = title;
        CGSize size= [title sizeWithFont:headerView.label.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
        headerView.label.frame=CGRectMake(0, 10, size.width, 30);
        headerView.image.frame=headerView.label.frame;
        headerView.frame=CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y, size.width, 40);
        reusableview = headerView;
    }
    return reusableview;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSTicketsCell *cell=(CSTicketsCell *)[_collectionV cellForItemAtIndexPath:indexPath];
    selectDic=cell.dataDic;
    /**
     *  判断是否需要输入密码
     */
    if ([[CSDataProvider CSDataProviderShare].SAVETIME intValue]+60>[[NSDate date] timeIntervalSince1970]) {
        [CSDataProvider CSDataProviderShare].SAVETIME=[NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
        if (indexPath.section==1) {
            [self cardOutCouponByPre];
        }else
        {
            [self userCardOutPointByPre];
        }
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:[CSDataProvider localizedString:@"OK"], nil];
        alert.alertViewStyle=UIAlertViewStyleSecureTextInput;
        alert.tag=100;
        [alert show];
    }
}
-(void)userCardOutPointByPre
{
    if ([[selectDic objectForKey:@"IFENDISCNUM"] intValue]==0&&[[selectDic objectForKey:@"NDERATENUM"] intValue]==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请输入需积分支付金额" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        alert.tag=1000;
        [alert show];
    }else
    {
        [self cardOutPointByPre];
    }
}
#pragma mark - 会员信息查询
-(void)ZCqueryVip
{
    [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeClear];
    [NSThread detachNewThreadSelector:@selector(ZCqueryVipRequest) toTarget:self withObject:nil];
}
#pragma mark -
-(void)ZCqueryVipRequest
{
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare] ZCqueryVip];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"state"] intValue]==1) {
        UILabel *lb=(UILabel *)[self viewWithTag:2003];
        lb.text=[[dict objectForKey:@"msg"] objectForKey:@"smoney"];
        [CSDataProvider CSDataProviderShare].cardCash=lb.text;
        UILabel *lb1=(UILabel *)[self viewWithTag:2004];
        lb1.text=[[dict objectForKey:@"msg"] objectForKey:@"sjifen"];
        [CSDataProvider CSDataProviderShare].cardIntegral=lb1.text;
        dataArray=[[CSDataProvider CSDataProviderShare] getCouponConsumption:[[dict objectForKey:@"msg"] objectForKey:@"tickets"]];
        bs_dispatch_sync_on_main_thread(^{
            [_collectionV reloadData];
        });
        
    }
}
#pragma mark - 优惠券使用
-(void)cardOutCouponByPre
{
    
    [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeGradient];
    [NSThread detachNewThreadSelector:@selector(cardOutCouponByPreRequest) toTarget:self withObject:nil];
}
-(void)cardOutCouponByPreRequest
{
    NSDictionary *dic=[[CSDataProvider CSDataProviderShare] ZCcardOutCouponByPre:selectDic];
    [SVProgressHUD dismiss];
    if (!dic) {
        [SVProgressHUD showErrorWithStatus:[CSDataProvider localizedString:@"ConnectionTimeout"]];
        return;
    }
    if ([[dic objectForKey:@"state"] intValue] ==1) {
        //                [CSDataProvider CSDataProviderShare].cardWord=pwd;
        [CSDataProvider CSDataProviderShare].SAVETIME=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        //        NSString *flag=[[selectDic objectForKey:@"ticketmoney"] floatValue]>=[CSDataProvider CSDataProviderShare].remainingAmount?@"Y":@"N";
        if ([[selectDic objectForKey:@"ticketmoney"] floatValue]>=[CSDataProvider CSDataProviderShare].remainingAmount) {
            [CSDataProvider CSDataProviderShare].remainingAmount=0;
            //跳转账单
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectRow" object:@"3"];
        }else
        {
            //刷新券列表
            [self ZCqueryVip];
            //刷新账单的结算信息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCQueryOrder" object:nil];
        }
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dic objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - 积分使用
-(void)cardOutPointByPre
{
    [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeGradient];
    [NSThread detachNewThreadSelector:@selector(cardOutPointByPreRequest) toTarget:self withObject:nil];
}
#pragma mark - 积分使用请求
-(void)cardOutPointByPreRequest
{
    NSDictionary *dic=[[CSDataProvider CSDataProviderShare] ZCcardOutPointByPre:selectDic];
    [SVProgressHUD dismiss];
    if (!dic) {
        [SVProgressHUD showErrorWithStatus:[CSDataProvider localizedString:@"ConnectionTimeout"]];
        return;
    }
    if ([[dic objectForKey:@"state"] intValue] ==1) {
        //记录输入密码时间
        [CSDataProvider CSDataProviderShare].SAVETIME=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        //刷新券列表
        [self ZCqueryVip];
        //判断是否支付完成
        if ([[selectDic objectForKey:@"NDERATENUM"] floatValue]>=[CSDataProvider CSDataProviderShare].remainingAmount) {
            [CSDataProvider CSDataProviderShare].remainingAmount=0;
            //跳转账单
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectRow" object:@"3"];
        }else
        {
            //刷新账单的结算信息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCQueryOrder" object:nil];
        }
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dic objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            
            UITextField *tf1=[alertView textFieldAtIndex:0];
            [CSDataProvider CSDataProviderShare].cardWord=tf1.text;
            [CSDataProvider CSDataProviderShare].SAVETIME=[NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
            /**
             *  判断是否是积分优惠活动
             */
            if ([[selectDic objectForKey:@"VFENDISC"] isEqualToString:@"Y"]) {
//                if ([[selectDic objectForKey:@"IFENDISCNUM"]intValue]==0) {
//                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请输入消费金额" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                    [alert show];
//                }
                [self userCardOutPointByPre];
            }else
            {
                [self cardOutCouponByPre];
            }
        }
    }else if(alertView.tag==1000){
        if (buttonIndex==1) {
            
            UITextField *tf1=[alertView textFieldAtIndex:0];
            if ([tf1.text floatValue]>[CSDataProvider CSDataProviderShare].remainingAmount) {
                tf1.text=[NSString stringWithFormat:@"%.2f",[CSDataProvider CSDataProviderShare].remainingAmount];
            }
            [selectDic setValue:tf1.text forKey:@"IFENDISCNUM"];//扣分金额
            [selectDic setValue:tf1.text forKey:@"NDERATENUM"];//抵现金金额
            [self cardOutPointByPre];
        }
    }
}

#pragma mark - 改变位置
-(void)changeFrame
{
    UIImageView *image=(UIImageView *)[self viewWithTag:2000];
    CGRect rect= CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"MainView"] objectForKey:@"DetailViewFrame"]);
    image.frame=CGRectMake(0, 0, rect.size.width, rect.size.height);
    UIView *view=[self viewWithTag:2001];
    view.frame=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"VipCard"] objectForKey:@"Stored-valueImageFrame"]);
    UIView *view1=[self viewWithTag:2003];
    view1.frame= CGRectMake(view.frame.origin.x+40, view.frame.origin.y+10,view.frame.size.width-40, view.frame.size.height);
    view=[self viewWithTag:2002];
    view.frame=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"VipCard"] objectForKey:@"IntegralImageFrame"]);
    view1=[self viewWithTag:2004];
    view1.frame= CGRectMake(view.frame.origin.x+40, view.frame.origin.y+10,view.frame.size.width-40, view.frame.size.height);
    _collectionV.frame=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"VipCard"] objectForKey:@"CollectionViewFrame"]);
    
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
