//
//  CSOrderView.m
//  Cafeteria
//
//  Created by chensen on 14/11/4.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSPackageView.h"
#import "CSDataProvider.h"
#import "CSOrderReusableView.h"
#import "CSOrderDetailCell.h"
#import "CSOrderCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation CSPackageView
{
    UICollectionView *_collectionV; //小图
    UICollectionView *_collectionD; //大图
    NSDictionary     *_config;      //配置文件
    NSArray          *_allFood;         //菜品数据
    BOOL             _change;
    NSDictionary     *_titleInfo;
    int              _HANDTAG;
}

- (id)initWithFrame:(CGRect)frame withPackage:(NSDictionary *)dict
{
    self = [super initWithFrame:frame];
    if (self) {
        //全部的菜品
        _titleInfo=dict;
        _allFood=[[CSDataProvider CSDataProviderShare] getPackageList:[dict objectForKey:@"ITCODE"]];
        [self creatView];
        //点击类别
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classButtonClick:) name:@"classButtonClick" object:nil];
        //改变大图小图的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeModel:) name:@"PackageChangeModel" object:nil];
        //改变布局的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
        //更新数据的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfReloadData) name:@"PackagereloadData" object:nil];
        
    }
    return self;
}
/**
 *  创建视图
 */
-(void)creatView
{
    self.backgroundColor=[UIColor whiteColor];
    _config=[CSDataProvider CSDataProviderShare].config;
    NSDictionary *dict=[_config objectForKey:@"PackageView"];
    //    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"TitleFrame"])];
    //    [imageView setImage:[CSDataProvider imgWithContentsOfImageName:@"bt.png"]];
    //    [self addSubview:imageView];
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"TitleFrame"])];
    lb.layer.cornerRadius = 12;
    lb.textColor=[UIColor whiteColor];
    lb.tag=100;
    lb.backgroundColor=[UIColor clearColor];
    lb.layer.backgroundColor=[UIColor colorWithRed:252/255.0 green:160/255.0 blue:25/255.0 alpha:1].CGColor;
    lb.text=[NSString stringWithFormat:@"  %@  ",[_titleInfo objectForKey:@"DES"]];
    CGSize size= [lb.text sizeWithFont:lb.font constrainedToSize:CGSizeMake(MAXFLOAT, lb.frame.size.height)];
    lb.frame=CGRectMake(lb.frame.origin.x, lb.frame.origin.y, size.width,30);
    lb.textAlignment=NSTextAlignmentCenter;
    lb.textColor=[UIColor whiteColor];
    [self addSubview:lb];
    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        if (i==0) {
            btn.frame=CGRectFromString([dict objectForKey:@"OKFrame"]);
            [btn setBackgroundImage:[CSDataProvider imgWithContentsOfImageName:@"OKButton.png"] forState:UIControlStateNormal];
            
        }else
        {
            btn.frame=CGRectFromString([dict objectForKey:@"CancelFrame"]);
            //            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setBackgroundImage:[CSDataProvider imgWithContentsOfImageName:@"CancelButton.png"] forState:UIControlStateNormal];
        }
        btn.tag=i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
    //小图设置
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeFromString([[dict objectForKey:@"Order"] objectForKey:@"OrderSize"]);
    flowLayout.headerReferenceSize=CGSizeMake(320, 50);
    flowLayout.footerReferenceSize=CGSizeMake(320, 2);
    flowLayout.minimumInteritemSpacing =5;//列距
    //大图设置
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.itemSize = CGSizeFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"FoodDetailSize"]);
    flowLayout1.headerReferenceSize=CGSizeMake(1,0);
    flowLayout1.footerReferenceSize=CGSizeMake(1,0);
    flowLayout1.minimumLineSpacing =0;//列距
    flowLayout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横屏
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"CollectionVFrame"])   collectionViewLayout:flowLayout];
    _collectionD = [[UICollectionView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"CollectionDFrame"])   collectionViewLayout:flowLayout1];
    _collectionD.pagingEnabled=YES;
    NSArray *array=[[NSArray alloc] initWithObjects:_collectionV,_collectionD, nil];
    for (int i=0;i<2;i++) {
        UICollectionView *collection=[array objectAtIndex:i];
        collection.backgroundColor=[UIColor whiteColor];
        collection.bounces = NO;
        collection.tag=i;
        if (i==0) {
            [collection registerClass:[CSOrderCell class] forCellWithReuseIdentifier:@"colletionCell"];
        }else
        {
            [collection registerClass:[CSOrderDetailCell class] forCellWithReuseIdentifier:@"colletionCell1"];
        }
        
        [collection registerClass:[CSOrderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [collection registerClass:[CSOrderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        collection.showsHorizontalScrollIndicator = NO;
        collection.showsVerticalScrollIndicator = NO;
        collection.dataSource = self;
        collection.delegate = self;
    }
    
    [self addSubview:_collectionV];
    [_collectionV reloadData];
}
-(void)ChangeFrame
{
    //    _collectionV.frame=CGRectMake(0, 0,self.frame.size.width, self.frame.size.height);
    _config=[CSDataProvider CSDataProviderShare].config;
    NSDictionary *dict=[_config objectForKey:@"PackageView"];
    UICollectionViewFlowLayout *flowLayout = _collectionV.collectionViewLayout;
    UICollectionViewFlowLayout *flowLayout1 = _collectionD.collectionViewLayout;
    _collectionV.frame=CGRectFromString([dict objectForKey:@"CollectionVFrame"]);
    _collectionD.frame=CGRectFromString([dict objectForKey:@"CollectionDFrame"]);
    flowLayout1.itemSize= CGSizeFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"FoodDetailSize"]);
    flowLayout.itemSize = CGSizeFromString([[[_config objectForKey:@"OrderView"] objectForKey:@"Order"] objectForKey:@"OrderSize"]);
    UIView *view=[self viewWithTag:0];
    view.frame=CGRectFromString([dict objectForKey:@"OKFrame"]);
    view=[self viewWithTag:1];
    view.frame=CGRectFromString([dict objectForKey:@"CancelFrame"]);
    
    [_collectionV reloadData];
    
}
/**
 *  套餐确定取消按钮
 *
 *  @param btn
 */
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==0) {
        int j=1;
        for (NSArray *array in _allFood) {
            int i=0;
            for (NSDictionary *dict in [CSDataProvider CSDataProviderShare].PackageItem) {
                if ([[dict objectForKey:@"PRODUCTTC_ORDER"] isEqualToString:[[array lastObject] objectForKey:@"PRODUCTTC_ORDER"]]) {
                    i++;
                }
            }
            if (i<[[[array lastObject] objectForKey:@"TYPMINCNT"] intValue]) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:[CSDataProvider localizedString:@"The current package 1 layer did not choose to complete"],j] message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
                [alert show];
                return;
            }
            j++;
        }
        /**
         *  计算套餐的价格
         */
        [self CalculationPackagePrice];
        [[[CSDataProvider CSDataProviderShare].foodsArray lastObject] setObject:[NSArray arrayWithArray:[CSDataProvider CSDataProviderShare].PackageItem] forKey:@"combo"];
        [CSDataProvider CSDataProviderShare].PackageItem=nil;
        
    }else
    {
        [CSDataProvider CSDataProviderShare].PackageItem=nil;
        NSMutableArray *array=[CSDataProvider CSDataProviderShare].foodsArray;
        [array removeLastObject];
        [CSDataProvider CSDataProviderShare].foodsArray=array;
        
    }
    /**
     *  取消通知订阅
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PackageChangeModel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeViewFrame" object:nil];
    /**
     *  更新菜品
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
    /**
     *  更新类别
     */
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"updataFood" object:nil];
    /**
     *  关闭视图
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissView" object:nil];
}
-(void)CalculationPackagePrice
{
    float mrMoney = 0.0;
    float tcMoney=[[[[CSDataProvider CSDataProviderShare].foodsArray lastObject] objectForKey:@"PRICE"] floatValue];
    for (NSDictionary *dict in [CSDataProvider CSDataProviderShare].PackageItem) {
        if ([[dict objectForKey:@"NADJUSTPRICE"] floatValue]>0) {
            tcMoney+=[[dict objectForKey:@"NADJUSTPRICE"] floatValue]*[[dict objectForKey:@"total"] floatValue];
        }
    }
    [[[CSDataProvider CSDataProviderShare].foodsArray lastObject] setObject:[NSNumber numberWithFloat:tcMoney] forKey:@"PRICE"];
    //        float tcMoney=[[[[CSDataProvider CSDataProviderShare].foodsArray lastObject] objectForKey:@"PRICE"] floatValue];
    
    for (int i=0; i<[[CSDataProvider CSDataProviderShare].PackageItem count]; i++) {
        
        NSDictionary *dict=[[CSDataProvider CSDataProviderShare].PackageItem objectAtIndex:i];
        if ([[dict objectForKey:@"Weightflg"] intValue]==2) {
            mrMoney+=[[dict objectForKey:@"Weight"] floatValue]*[[dict objectForKey:@"PRICE1"] floatValue];
        }
        if ([dict objectForKey:@"total"]==nil) {
            [dict setValue:@"1" forKey:@"total"];
        }
        [dict setValue:[NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"PRICE1"] floatValue]*[[dict objectForKey:@"total"] floatValue]] forKey:@"PRICE"];
        mrMoney+=[[dict objectForKey:@"PRICE"] floatValue];
    }
    
    for (int i=0; i<[[CSDataProvider CSDataProviderShare].PackageItem count]; i++) {
        NSDictionary *dict=[[CSDataProvider CSDataProviderShare].PackageItem objectAtIndex:i];
        float m_price1=[[dict objectForKey:@"PRICE1"] floatValue];
        int TC_m_State=[[dict objectForKey:@"TCMONEYMODE"] floatValue];
        if(TC_m_State == 1)   //计价方式一
        {
            
            //                float youhuijia =mrMoney-tcMoney;     //优惠的价钱    合计 - 套餐价额
            float tempMoney1=m_price1*tcMoney/mrMoney;
            //                    float tempMoney1=m_price1-(youhuijia*(m_price1/mrMoney));
            [dict setValue:[NSString stringWithFormat:@"%.2f",tempMoney1] forKey:@"PRICE"];
        }
        else if(TC_m_State==2)
        {
            NSDictionary *dict1=[[CSDataProvider CSDataProviderShare].foodsArray lastObject];
            [dict1 setValue:[NSString stringWithFormat:@"%.2f",mrMoney] forKey:@"PRICE"];
        }else if (TC_m_State==3) {
            if (mrMoney<tcMoney) {
                //                    float youhuijia =mrMoney-tcMoney;     //优惠的价钱    合计 - 套餐价额
                float tempMoney1=m_price1*tcMoney/mrMoney;
                //                        float tempMoney1=m_price1-(youhuijia*(m_price1/mrMoney));
                [dict setValue:[NSString stringWithFormat:@"%.2f",tempMoney1] forKey:@"PRICE"];
            }
            else
            {
                NSDictionary *dict1=[[CSDataProvider CSDataProviderShare].foodsArray lastObject];
                [dict1 setValue:[NSString stringWithFormat:@"%.2f",mrMoney] forKey:@"PRICE"];
            }
        }
        if (i==[[CSDataProvider CSDataProviderShare].PackageItem count]-1) {
            float mrMoney1 = 0.0;
            //                    float tcMoney=[[[[CSDataProvider CSDataProviderShare].foodsArray objectAtIndex:[[CSDataProvider CSDataProviderShare].foodsArray count]-[arry count]+[_Combo count]-x-1] objectForKey:@"PRICE"] floatValue];
            
            for (int i=0; i<[[CSDataProvider CSDataProviderShare].PackageItem count]; i++) {
                
                NSDictionary *dict=[[CSDataProvider CSDataProviderShare].PackageItem objectAtIndex:i];
                if ([[dict objectForKey:@"Weightflg"] intValue]==2) {
                    mrMoney1+=[[dict objectForKey:@"Weight"] floatValue]*[[dict objectForKey:@"PRICE"] floatValue];
                }else{
                    mrMoney1+=[[dict objectForKey:@"PRICE"] floatValue];
                }
            }
            
            if (mrMoney1!=tcMoney) {
                for (int i=0; i<[[CSDataProvider CSDataProviderShare].PackageItem count]; i++) {
                    NSDictionary *dict=[[CSDataProvider CSDataProviderShare].PackageItem objectAtIndex:i];
                    
                    if ([[dict objectForKey:@"PRICE"] floatValue]>0) {
                        if ([[dict objectForKey:@"Weightflg"] intValue]!=2) {
                            float x=[[dict objectForKey:@"PRICE"] floatValue]+tcMoney-mrMoney1;
                            [dict setValue:[NSString stringWithFormat:@"%.2f",x] forKey:@"PRICE"];
                            break;
                        }
                        
                    }
                }
            }
            
        }
        
    }
    [[[CSDataProvider CSDataProviderShare].foodsArray lastObject] setObject:[NSArray arrayWithArray:[CSDataProvider CSDataProviderShare].PackageItem] forKey:@"combo"];
}
//数据
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag==1) {
        NSString *reuseIdetify = @"colletionCell1";
        CSOrderDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
        [cell setDataForView:[[_allFood objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] withIndexPath:indexPath];
        return cell;
    }else
    {
        NSString *reuseIdetify = @"colletionCell";
        CSOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
        cell.package=_allFood;
        [cell setDataForView:[[_allFood objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] withIndexPath:indexPath];
        return cell;
    }
}
//头标
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        CSOrderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        NSString *title = [[NSString alloc] initWithFormat:@"    %d、%@-%@  %@     ",indexPath.section+1,[[[_allFood objectAtIndex:indexPath.section] lastObject] objectForKey:@"TYPMINCNT"],[[[_allFood objectAtIndex:indexPath.section] lastObject] objectForKey:@"TYPMAXCNT"],[[[_allFood objectAtIndex:indexPath.section] lastObject] objectForKey:@"GROUPTITLE"]];
        
        headerView.label.text = title;
        CGSize size= [title sizeWithFont:headerView.label.font constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
        //
        //        headerView.label.frame=CGRectMake(headerView.label.frame.origin.x, headerView.label.frame.origin.y, size.width, 30);
        //        headerView.label.text = title;
        //        CGSize size= [title sizeWithFont:headerView.label.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
        headerView.label.frame=CGRectMake(0, 10, size.width, 30);
        headerView.image.frame=headerView.label.frame;
        headerView.frame=CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y, size.width, 40);
        reusableview = headerView;
        //        headerView.image.frame=headerView.label.frame;
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *footerview =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        if (!_change) {
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeClass" object:[NSString stringWithFormat:@"%d",indexPath.section]];
        }
        reusableview = footerview;
        
    }
    
    return reusableview;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _change=NO;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag==1) {
        CGSize size=CGSizeFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"FoodDetailSize"]);
        return size;
    }else
    {
        CGSize size=CGSizeFromString([[[_config objectForKey:@"OrderView"] objectForKey:@"Order"] objectForKey:@"OrderSize"]);
        return size;
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_allFood count];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[_allFood objectAtIndex:section] count];
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag!=1) {
        _HANDTAG+=1;
        CSOrderCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
        NSMutableDictionary *dataInfo=[[_allFood objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        //按键声音
        [CSDataProvider playSound];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            if (_HANDTAG==2)
            {
                NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"tag",indexPath,@"indexPath", nil];
                _HANDTAG=0;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PackageChangeModel" object:dict];
            }else if(_HANDTAG==1){
                NSMutableArray *array=[CSDataProvider CSDataProviderShare].PackageItem;
                if (!array) {
                    array=[[NSMutableArray alloc] init];
                }
                int i=0;
                int j=0;
                for (NSDictionary *dict in array) {
                    if ([[dict objectForKey:@"PRODUCTTC_ORDER"] isEqualToString:[dataInfo objectForKey:@"PRODUCTTC_ORDER"]]) {
                        i++;
                        if ([[dict objectForKey:@"ITCODE"] isEqualToString:[dict objectForKey:@"ITCODE"]]) {
                            j++;
                        }
                    }
                    if (i+1>[[dataInfo objectForKey:@"TYPMAXCNT"] integerValue]) {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[CSDataProvider localizedString:@"It can choose in other food has finished, please long press cancel after dishes, then choose new dishes"] message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
                        [alert show];
                        return;
                    }
                }
                if (j+1>[[dataInfo objectForKey:@"MAXCNT"] intValue]) {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"已经是该菜品的最大数量" message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
                    
                    [alert show];
                    return;
                }
                [dataInfo setObject:[NSString stringWithFormat:@"%d",j+1] forKey:@"total"];
                //        [dataInfo setObject:[NSString stringWithFormat:@"%d",j+1] forKey:@"count"];
                
                [array addObject:dataInfo];
                [CSDataProvider CSDataProviderShare].PackageItem=array;
                UIView *view=[cell viewWithTag:103];
                view.hidden=NO;
                UILabel *count =(UILabel *)[cell viewWithTag:104];
                count.text=[NSString stringWithFormat:@"%.1f",[[dataInfo objectForKey:@"total"] floatValue]*[[dataInfo objectForKey:@"CNT"] floatValue]];
                _HANDTAG=0;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
            }else
            {
                _HANDTAG=0;
            }
        });
    }
    
}
#pragma mark - 改变模式通知
-(void)changeModel:(NSNotification *)notification
{
    NSDictionary *dic = [notification object];
    if ([[dic objectForKey:@"tag"] intValue]==2) {
        for (UIView *view in self.subviews) {
            if (view ==_collectionD) {
                return;
            }
        }
        [self addSubview:_collectionD];
        [_collectionD reloadData];
        bs_dispatch_sync_on_main_thread(^{
            [_collectionD scrollToItemAtIndexPath:(NSIndexPath *)[dic objectForKey:@"indexPath"] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        });
    }else
    {
        [_collectionD removeFromSuperview];
        [_collectionV reloadData];
        bs_dispatch_sync_on_main_thread(^{
            [_collectionV scrollToItemAtIndexPath:(NSIndexPath *)[dic objectForKey:@"indexPath"] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        });
    }
    
}
-(void)selfReloadData
{
    [_collectionV reloadData];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
