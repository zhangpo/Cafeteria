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

#import "HMDCollectionViewCell.h"
#import "CSChinesefoodPack.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation HMDCollectionViewCell
{
    UICollectionView *_collectionV;
    NSDictionary    *_config;
    NSArray         *_dataArray;
    int             _HANDTAG;
    NSIndexPath     *LASTINDEXPATH;
    NSIndexPath     *_INDEXPATH;
}
@synthesize package=_package,parentView=_parentView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void)initView
{
    
    //设置位置大小
    _config=[CSDataProvider CSDataProviderShare].config;
    //小图设置
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeFromString([[_config objectForKey:@"OrderView"] objectForKey:@"ItemSize"]);
    
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"CollectionViewFrame"])  collectionViewLayout:flowLayout];
    _collectionV.bounces = NO;
    
    [_collectionV registerClass:[CSOrderCell class] forCellWithReuseIdentifier:@"colletionCell3"];
    _collectionV.showsHorizontalScrollIndicator = NO;
    _collectionV.showsVerticalScrollIndicator = NO;
    _collectionV.dataSource = self;
    _collectionV.delegate = self;
    _collectionV.backgroundColor=[UIColor clearColor];
    [self addSubview:_collectionV];
    [_collectionV reloadData];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdetify = @"colletionCell3";
    CSOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
    NSLog(@"%d",indexPath.row);
    [cell setDataForView:[_dataArray objectAtIndex:indexPath.row] withIndexPath:indexPath];
    cell.parentView=_collectionV;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size=CGSizeFromString([[[_config objectForKey:@"OrderView"] objectForKey:@"Order"] objectForKey:@"OrderSize"]);
    return size;
}
#pragma mark - cell选择事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_HANDTAG==0) {
        _HANDTAG+=1;
    }else if (LASTINDEXPATH==indexPath&&_HANDTAG==1){
        _HANDTAG+=1;
    }
    LASTINDEXPATH=indexPath;
    //按键声音
    [CSDataProvider playSound];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.4 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        NSMutableDictionary *dataInfo=[_dataArray objectAtIndex:indexPath.row];
        if (_HANDTAG!=2&&LASTINDEXPATH) {
            NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[CSDataProvider CSDataProviderShare].foodsArray];
            int i=0;
            int j=0;
            /**
             *  当前点了多少份
             */
            for (NSDictionary *dict in array) {
                if ([[dict objectForKey:@"ITCODE"] isEqualToString:[dataInfo objectForKey:@"ITCODE"]]&&![dict objectForKey:@"addition"]&&[[dict objectForKey:@"ISTC"] intValue]!=1) {
                    i=[[dict objectForKey:@"total"] intValue];
                    break;
                }
                j++;
            }
            [dataInfo setObject:[NSString stringWithFormat:@"%d",[[dataInfo objectForKey:@"count"] intValue]+1]  forKey:@"count"];
            NSMutableDictionary *foodDict=[[NSMutableDictionary alloc] initWithDictionary:dataInfo];
            [foodDict setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"total"];
            
            UIView *view=[self viewWithTag:103];
            view.hidden=NO;
            
            if([dataInfo objectForKey:@"PACKID"]||[[dataInfo objectForKey:@"ISTC"] intValue]==1)//套餐
            {
                [array addObject:foodDict];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"package" object:dataInfo];
            }
            else
            {
                if (i>0) {
                    [array removeObjectAtIndex:j];
                    [array insertObject:foodDict atIndex:j];
                }else
                {
                    [array addObject:foodDict];
                }
            }
            [CSDataProvider CSDataProviderShare].foodsArray=array;
            UILabel *count =(UILabel *)[self viewWithTag:104];
            count.text=[dataInfo objectForKey:@"count"];
            _HANDTAG=0;
            LASTINDEXPATH=nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil userInfo:nil];
            
        }else if(LASTINDEXPATH)
        {
            
            NSIndexPath *index=[NSIndexPath indexPathForRow:_INDEXPATH.row*9+indexPath.row inSection:_INDEXPATH.section];
            NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"tag",index,@"indexPath", nil];
            _HANDTAG=0;
            if ([dataInfo objectForKey:@"PACKID"]&&[dataInfo objectForKey:@"ITEM"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PackageChangeModel" object:dict];
            }else
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeModel" object:dict];
            }
            LASTINDEXPATH=nil;
        }
        
        collectionView.userInteractionEnabled=YES;
        
    });
    
    
}
-(void)setDataArray:(NSArray *)array withIndexPath:(NSIndexPath *)indexPath
{
    _dataArray=array;
    _INDEXPATH=indexPath;
    [_collectionV reloadData];
}
@end
