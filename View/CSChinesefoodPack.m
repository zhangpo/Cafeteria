//
//  CSOrderView.m
//  Cafeteria
//
//  Created by chensen on 14/11/4.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSChinesefoodPack.h"
#import "CSDataProvider.h"
#import "CSOrderReusableView.h"
#import "CSOrderDetailCell.h"
#import "CSOrderCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation CSChinesefoodPack
{
    UICollectionView *_collectionV; //小图
    UICollectionView *_collectionD; //大图
    NSDictionary     *_config;      //配置文件
    NSArray          *_allFood;         //菜品数据
    BOOL             _change;
    NSDictionary     *_titleInfo;
    int              _HANDTAG;
    NSIndexPath      *LASTINDEXPATH;
    int              currentPage;
}

- (id)initWithFrame:(CGRect)frame withPackage:(NSDictionary *)dict
{
    self = [super initWithFrame:frame];
    if (self) {
        //全部的菜品
        _titleInfo=dict;
        _allFood=[CSDataProvider selectChinesePackItem:[dict objectForKey:@"PACKID"]];
        [self creatView];
        //改变大图小图的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeModel:) name:@"PackageChangeModel" object:nil];
        //改变布局的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
        //更新数据的通知
    }
    return self;
}
#pragma mark - 创建视图
/**
 *  创建视图
 */
-(void)creatView
{
    self.backgroundColor=[UIColor whiteColor];
    _config=[CSDataProvider CSDataProviderShare].config;
    NSDictionary *dict=[_config objectForKey:@"PackageView"];
    //套餐名称
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"TitleFrame"])];
    lb.text=[_titleInfo objectForKey:@"DES"];
    lb.textColor=[UIColor whiteColor];
    lb.layer.backgroundColor=[UIColor colorWithRed:252/255.0 green:160/255.0 blue:25/255.0 alpha:1].CGColor;
    lb.font=[UIFont systemFontOfSize:20];
    lb.layer.cornerRadius = 15;
    CGSize size= [lb.text sizeWithFont:lb.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    lb.frame=CGRectMake(lb.frame.origin.x, lb.frame.origin.y, size.width, 30);
    [self addSubview:lb];
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
            [btn setBackgroundImage:[CSDataProvider imgWithContentsOfImageName:@"CancelButton.png"] forState:UIControlStateNormal];
        }
        btn.tag=870+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
    //小图设置
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeFromString([[dict objectForKey:@"Order"] objectForKey:@"OrderSize"]);
    flowLayout.headerReferenceSize=CGSizeMake(320, 40);
    flowLayout.footerReferenceSize=CGSizeMake(320, 2);
    //    flowLayout.minimumInteritemSpacing =5;//列距
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
#pragma mark - 按钮的事件
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==870) {
        if ([_allFood count]==[[CSDataProvider CSDataProviderShare].PackageItem count]) {
            [self CalculationPackagePrice];
//            [[[CSDataProvider CSDataProviderShare].foodsArray lastObject] setObject:[NSArray arrayWithArray:[CSDataProvider CSDataProviderShare].PackageItem] forKey:@"combo"];
//            [CSDataProvider CSDataProviderShare].PackageItem=nil;
        }else
        {
            return;
        }
    }else
    {
        [CSDataProvider CSDataProviderShare].PackageItem=nil;
        NSMutableArray *array=[CSDataProvider CSDataProviderShare].foodsArray;
        [array removeLastObject];
        [CSDataProvider CSDataProviderShare].foodsArray=array;
        
    }
    /**
     *  更新菜品
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
    /**
     *  关闭视图
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissView" object:nil];
}
#pragma mark - 计算套餐价格
-(void)CalculationPackagePrice
{
    NSMutableArray *array=[[CSDataProvider CSDataProviderShare] ZCcalculationPackagePrice:[NSMutableArray arrayWithArray:[CSDataProvider CSDataProviderShare].PackageItem] withPackage:[[CSDataProvider CSDataProviderShare].foodsArray lastObject]];
    [[[CSDataProvider CSDataProviderShare].foodsArray lastObject] setObject:[NSArray arrayWithArray:array] forKey:@"combo"];
    [CSDataProvider CSDataProviderShare].PackageItem=nil;
    NSLog(@"%@",[CSDataProvider CSDataProviderShare].foodsArray);
}
#pragma mark - UICollectionViewDelegate
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
        
        NSString *title = [[NSString alloc] initWithFormat:@"    %d    ",(int)indexPath.section+1];
        headerView.label.text = title;
        CGSize size= [title sizeWithFont:headerView.label.font constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
        headerView.label.frame=CGRectMake(0, 10, size.width, 30);
        headerView.image.frame=headerView.label.frame;
        headerView.frame=CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y, size.width, 40);
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *footerview =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
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
    if (collectionView== _collectionV) {
        if (_HANDTAG==0) {
            _HANDTAG+=1;
        }else if (LASTINDEXPATH==indexPath&&_HANDTAG==1){
            _HANDTAG+=1;
        }
        CSOrderCell *cell=(CSOrderCell *)[collectionView cellForItemAtIndexPath:
                                          indexPath];
        NSMutableDictionary *dataInfo=[[_allFood objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        //声音播放
        [CSDataProvider playSound];
        LASTINDEXPATH=indexPath;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.3 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            
            //在非ARC模式下，还需要释放 audioEffect
            if (_HANDTAG!=2&&LASTINDEXPATH) {
                NSMutableArray *array=[CSDataProvider CSDataProviderShare].PackageItem;
                if (!array) {
                    array=[[NSMutableArray alloc] init];
                }
                for (NSDictionary *dict in array) {
                    if ([[dict objectForKey:@"PRODUCTTC_ORDER"] isEqualToString:[dataInfo objectForKey:@"PRODUCTTC_ORDER"]]) {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"该可换菜已选择，请长按取消菜品后，再选择新的菜品" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [alert show];
                        return;
                    }
                }
                [dataInfo setObject:@"1" forKey:@"total"];
                [dataInfo setObject:@"1" forKey:@"count"];
                [array addObject:dataInfo];
                [CSDataProvider CSDataProviderShare].PackageItem=array;
                UIView *view=[cell viewWithTag:103];
                view.hidden=NO;
                UILabel *count =(UILabel *)[cell viewWithTag:104];
                count.text=[dataInfo objectForKey:@"CNT"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                _HANDTAG=0;
                LASTINDEXPATH=nil;
            }else if(LASTINDEXPATH)
                {
                    NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"tag",indexPath,@"indexPath", nil];
                    _HANDTAG=0;
                    if ([dataInfo objectForKey:@"PACKID"]&&[dataInfo objectForKey:@"ITEM"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PackageChangeModel" object:dict];
                    }else
                    {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeModel" object:dict];
                    }
                    _HANDTAG=0;
                    LASTINDEXPATH=nil;
                }
            
            collectionView.userInteractionEnabled=YES;
            
        });
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView==_collectionV) {
        return 15;
    }else
    {
        return 0;
    }
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView==_collectionV) {
        return 20;
    }else
    {
        return 0;
    }
}

-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 改变坐标
-(void)ChangeFrame
{
    //    _collectionV.frame=CGRectMake(0, 0,self.frame.size.width, self.frame.size.height);
    [self collectionCurrentPage];
    _config=[CSDataProvider CSDataProviderShare].config;
    UICollectionViewFlowLayout *flowLayout = _collectionV.collectionViewLayout;
    UICollectionViewFlowLayout *flowLayout1 = _collectionD.collectionViewLayout;
    
    NSDictionary *dict=[_config objectForKey:@"PackageView"];
    UIView *view=[self viewWithTag:870];
    view.frame=CGRectFromString([dict objectForKey:@"OKFrame"]);
    //    [self bringSubviewToFront:view];
    view=[self viewWithTag:871];
    view.frame=CGRectFromString([dict objectForKey:@"CancelFrame"]);
    _collectionV.frame=CGRectFromString([dict objectForKey:@"CollectionVFrame"]);
    _collectionD.frame=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"OrderView"] objectForKey:@"ViewFrame"]);
    if (_collectionD) {
        flowLayout1.itemSize= CGSizeFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"FoodDetailSize"]);
    }else
    {
        self.frame=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"OrderView"] objectForKey:@"ViewFrame"]);
        flowLayout.itemSize = CGSizeFromString([[[_config objectForKey:@"OrderView"] objectForKey:@"Order"] objectForKey:@"OrderSize"]);
    }
    [_collectionD reloadData];
  
//    [self bringSubviewToFront:view];
    NSLog(@"%@",self.subviews);
    bs_dispatch_sync_on_main_thread(^{
        [_collectionD scrollToItemAtIndexPath:[self currentPageToCalculate] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    });
    [_collectionV reloadData];
    
}
#pragma mark - 计算当前页的NSIndexPath
-(NSIndexPath *)currentPageToCalculate
{
//    [self scrollViewDidScroll:_collectionD];
    int i=1,j=0,count=0;
    if (currentPage>0) {
    for (i=0; i<[_allFood count]; i++) {
        if (i+1<[_allFood count]) {
            if (j+[[_allFood objectAtIndex:i] count]>=currentPage) {
                count=j-currentPage+1;
                break;
            }
        }
        j+=[[_allFood objectAtIndex:i] count];
    }
    }
    
    return [NSIndexPath indexPathForItem:count inSection:i];
}
#pragma mark - 当前的页数
-(void)collectionCurrentPage
{
    if (_collectionD) {
        CGFloat pageWidth = _collectionD.frame.size.width;
        //    // 根据当前的x坐标和页宽度计算出当前页数
        NSLog(@"%.f",pageWidth);
        currentPage = floor((_collectionD.contentOffset.x - pageWidth / 2) / pageWidth) + 2;
        NSLog(@"%d      %f",currentPage,floor((_collectionD.contentOffset.x - pageWidth / 2) / pageWidth));
    }
}

#pragma mark - 改变模式通知
-(void)changeModel:(NSNotification *)notification
{
    NSDictionary *dic = [notification object];
    NSDictionary *dict=[_config objectForKey:@"PackageView"];
    if ([[dic objectForKey:@"tag"] intValue]==2) {
        //        [_collectionV removeFromSuperview];
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
        //        [self addSubview:_collectionV];
        [_collectionV reloadData];
        bs_dispatch_sync_on_main_thread(^{
            [_collectionV scrollToItemAtIndexPath:(NSIndexPath *)[dic objectForKey:@"indexPath"] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        });
    }
    
}



@end
