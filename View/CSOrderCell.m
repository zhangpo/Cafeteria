//
//  SelectThemeCollectionViewCell.m
//  IMFiveApp
//
//  Created by chen on 14-8-30.
//  Copyright (c) 2014年 chen. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CSOrderCell.h"
#import "CSChinesefoodPack.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation CSOrderCell
{
    NSDictionary *_config;
    NSIndexPath     *_dataIndexPath;
}
@synthesize package=_package,parentView=_parentView,dataInfo=_dataInfo;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initView];
        
        //        self.backgroundColor=[UIColor blackColor];
    }
    return self;
}

- (void)initView
{
    //设置位置大小
    _config=[CSDataProvider CSDataProviderShare].config;
//    self.contentView.frame = CGRectFromString([[[_config objectForKey:@"OrderView"] objectForKey:@"Order"] objectForKey:@"OrderFrame"]);
    NSDictionary *dict=[[[_config objectForKey:@"OrderView"] objectForKey:@"Order"] objectForKey:@"Frame"];
    //设置图片大小
    UIImageView *imgPhoto=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"PhotoFrame"])];
    imgPhoto.tag=100;
    [self.contentView addSubview:imgPhoto];
    imgPhoto.userInteractionEnabled=YES;
    //添加长按手势
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableviewCellLongPressed:)];
    [imgPhoto addGestureRecognizer:longPress];
    //名称坐标
    CGRect _rect= CGRectFromString([dict objectForKey:@"NameFrame"]);
    //图片坐标
    CGRect _imagerect=CGRectFromString([dict objectForKey:@"PhotoFrame"]);
    //设置名称
    UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"NameFrame"])];
    lblName.textColor=[UIColor blackColor];
    lblName.textAlignment=NSTextAlignmentLeft;
    lblName.backgroundColor=[UIColor clearColor];
    lblName.numberOfLines=0;
    lblName.lineBreakMode=NSLineBreakByWordWrapping;
    lblName.font=[UIFont systemFontOfSize:18];
    lblName.tag=101;
    
    //设置价格
    UILabel *lblPrice=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"PriceFrame"])];
    lblPrice.textColor=[UIColor blackColor];
    lblPrice.backgroundColor=[UIColor clearColor];
    lblPrice.font=[UIFont systemFontOfSize:18];
    lblPrice.textAlignment=NSTextAlignmentRight;
    lblPrice.numberOfLines=0;
    lblPrice.lineBreakMode=NSLineBreakByWordWrapping;
    lblPrice.tag=102;
    //判断名称及价格是否在图片上，如果在加阴影
    if (_rect.origin.y+_rect.size.height<=_imagerect.origin.y+_imagerect.size.height) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, _rect.origin.y, _imagerect.size.width,_imagerect.size.height-_rect.origin.y)];
        view.backgroundColor=[UIColor colorWithRed:35/255.0 green:32/255.0 blue:28/255.0 alpha:0.7];
        [self.contentView addSubview:view];
        lblName.textColor=[UIColor whiteColor];
        lblPrice.textColor=[UIColor whiteColor];
    }
    [self.contentView addSubview:lblName];
    [self.contentView addSubview:lblPrice];
    
    //在菜品上显示已点了多少份该菜品
    UIImageView *imgCount=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"CountFrame"])];
    [imgCount setImage:[CSDataProvider imgWithContentsOfImageName:@"diancai.png"]];
    imgCount.tag=103;
    imgCount.hidden=YES;
    [self.contentView addSubview:imgCount];
    UILabel *lblCount=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"CountFrame"])];
    lblCount.tag=104;
    lblCount.backgroundColor=[UIColor clearColor];
    lblCount.textColor=[UIColor whiteColor];
    lblCount.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:lblCount];
        
}
#pragma mark - 长按手势
- (void)handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state)
    
    {
            
        case UIGestureRecognizerStateEnded:
            if([[_dataInfo objectForKey:@"count"] intValue]>0){
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[CSDataProvider localizedString:@"You confirm to delete items instead?"] message:nil delegate:self cancelButtonTitle:[CSDataProvider localizedString:@"Cancel"] otherButtonTitles:[CSDataProvider localizedString:@"OK"], nil];
                alert.tag=100;
                [alert show];
            }

            break;
            
        case UIGestureRecognizerStateCancelled:
            break;
            
        case UIGestureRecognizerStateFailed:
            break;
            
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
            break;
            
        default:
            
            break;
    }
    
    

}
#pragma mark - 数据
/**
 *  添加数据
 *
 *  @param info      数据
 *  @param indexPath 所在的位置
 */
- (void)setDataForView:(NSDictionary *)info withIndexPath:(NSIndexPath *)indexPath
{
    _dataInfo=info;
    _dataIndexPath=indexPath;
    //图片
    UIImageView *titleIV = (UIImageView *)[self.contentView viewWithTag:100];
    [titleIV setImage:[UIImage imageWithContentsOfFile:[[info objectForKey:@"picSmall"]!=nil?[info objectForKey:@"picSmall"]:[info objectForKey:@"PICSMALL"] documentPath]]];
    //名称
    UILabel *titleL = (UILabel *)[self.contentView viewWithTag:101];
    titleL.text = [info objectForKey:@"DES"];
    //价格
    titleL=(UILabel *)[self.contentView viewWithTag:102];
    titleL.text = [info objectForKey:@"PRICE"];
    titleL.text=[NSString stringWithFormat:@"%@/%@",[info objectForKey:@"PRICE"],[info objectForKey:@"UNIT"]];
    
    float i=0.0;
    
    /**
     *  中餐套餐明细
     */
    if ([info objectForKey:@"CNT"]) {
        for (NSDictionary *dict in [CSDataProvider CSDataProviderShare].PackageItem ) {
            if ([[dict objectForKey:@"ITCODE"] isEqualToString:[info objectForKey:@"ITCODE"]]&&[[dict objectForKey:@"PRODUCTTC_ORDER"] isEqualToString:[info objectForKey:@"PRODUCTTC_ORDER"]]) {
                i=[[dict objectForKey:@"total"] floatValue]*[[dict objectForKey:@"CNT"] floatValue];
            }
        }
    }else
    {
        /**
         *  计算点了多少菜
         */
        for (NSDictionary *dict  in [CSDataProvider CSDataProviderShare].foodsArray) {
            if ([[dict objectForKey:@"ITCODE"] isEqualToString:[info objectForKey:@"ITCODE"]]) {
                i+=[[dict objectForKey:@"total"] intValue];
            }
            if ([[dict objectForKey:@"PACKID"] isEqualToString:[info objectForKey:@"PACKID"]]&&![_dataInfo objectForKey:@"ITEM"]) {
                i+=[[dict objectForKey:@"total"] intValue];
            }
        }
    }
    [_dataInfo setObject:[NSString stringWithFormat:@"%.1f",i] forKey:@"count"];
    if ([[_dataInfo objectForKey:@"count"] intValue]>0) {
        UIImageView *image=(UIImageView *)[self.contentView viewWithTag:103];
        image.hidden=NO;
        titleL=(UILabel *)[self.contentView viewWithTag:104];
        titleL.text=[_dataInfo objectForKey:@"count"];
    }else
    {
        UIImageView *image=(UIImageView *)[self.contentView viewWithTag:103];
        image.hidden=YES;
        titleL=(UILabel *)[self.contentView viewWithTag:104];
        titleL.text=@"";
    }
}
#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            /**
             *  判断是否套餐
             */
            if ([_dataInfo objectForKey:@"PRODUCTTC_ORDER"]) {
            A:
                for (NSDictionary *dic in [CSDataProvider CSDataProviderShare].PackageItem) {
                    if ([[dic objectForKey:@"ITCODE"] isEqualToString:[_dataInfo objectForKey:@"ITCODE"]]&&[[dic objectForKey:@"PRODUCTTC_ORDER"] isEqualToString:[_dataInfo objectForKey:@"PRODUCTTC_ORDER"]]) {
                        UIImageView *image=(UIImageView *)[self.contentView viewWithTag:103];
                        image.hidden=YES;
                        UILabel *titleL=(UILabel *)[self.contentView viewWithTag:104];
                        titleL.text=@"";
                        NSMutableArray *package=[CSDataProvider CSDataProviderShare].PackageItem;
                        [package removeObject:dic];
                        [CSDataProvider CSDataProviderShare].PackageItem=package;
                        goto A;
                        break;
                    }
                    
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PackagereloadData" object:nil];
            }
            else
            {
                B:
                for (NSDictionary *dic in [CSDataProvider CSDataProviderShare].foodsArray) {
                
                    if ([[dic objectForKey:@"ITCODE"] isEqualToString:[_dataInfo objectForKey:@"ITCODE"]]) {
                        NSMutableArray *food=[CSDataProvider CSDataProviderShare].foodsArray;
                        [food removeObject:dic];
                        [CSDataProvider CSDataProviderShare].foodsArray=food;
                        goto B;
                        break;
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
            }

        }
    }
    
}

@end
