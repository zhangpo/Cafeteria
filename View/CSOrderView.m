//
//  CSOrderView.m
//  Cafeteria
//
//  Created by chensen on 14/11/4.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSOrderView.h"
#import "CSDataProvider.h"
#import "CSOrderReusableView.h"
#import "CSOrderDetailCell.h"

#import "HMDCollectionViewCell.h"

@implementation CSOrderView
{
    UICollectionView *_collectionV; //小图
    UICollectionView *_collectionD; //大图
    NSDictionary     *_config;      //配置文件
    NSArray          *_classArray;      //类别数据
    NSArray          *_allFood;         //菜品数据
    BOOL             _change;
    int              _HANDTAG;       //单机双击判断
    NSIndexPath      *LASTINDEXPATH;
    NSMutableDictionary     *_foodDic;     //当前点的菜品
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //类别列表
        _classArray=[CSDataProvider getFoodClass];
        //全部的菜品
        _allFood=[CSDataProvider selectAllFood];
        
        [self creatView];
        //点击类别
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classButtonClick:) name:@"classButtonClick" object:nil];
        //改变大图小图的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeModel:) name:@"changeModel" object:nil];
        //改变布局的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
        //更新数据的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfReloadData) name:@"reloadData" object:nil];
        
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  创建视图
 */
-(void)creatView
{
    _config=[CSDataProvider CSDataProviderShare].config;
    //小图设置
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    /**
     *  判断类别的位置，如果横向，菜品左右滑动；如果竖向，菜品上下滑动
     */
    if (![[[_config objectForKey:@"ClassView"] objectForKey:@"Anyway"] isEqualToString:@"across"]) {
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        flowLayout.headerReferenceSize=CGSizeMake(0.001, 0);
        flowLayout.footerReferenceSize=CGSizeMake(0.001, 0);
        flowLayout.itemSize = CGSizeFromString([[_config objectForKey:@"OrderView"] objectForKey:@"ItemSize"]);
        
    }else
    {
        flowLayout.itemSize = CGSizeFromString([[[_config objectForKey:@"OrderView"] objectForKey:@"Order"] objectForKey:@"OrderSize"]);
        flowLayout.headerReferenceSize=CGSizeMake(0.001,50);
        flowLayout.footerReferenceSize=CGSizeMake(0.001, 0);
    }
    //大图设置
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.itemSize = CGSizeFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"FoodDetailSize"]);
    flowLayout1.headerReferenceSize=CGSizeMake(0.1,0);
    flowLayout1.footerReferenceSize=CGSizeMake(0.1,0);
    flowLayout1.minimumLineSpacing =0;//列距
    flowLayout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横屏
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"CollectionViewFrame"])  collectionViewLayout:flowLayout];
    _collectionD = [[UICollectionView alloc] initWithFrame:CGRectFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"CollectionViewFrame"])   collectionViewLayout:flowLayout1];
    _collectionD.pagingEnabled=YES;   //翻页
    NSArray *array=[[NSArray alloc] initWithObjects:_collectionV,_collectionD, nil];
    for (int i=0;i<2;i++) {
        UICollectionView *collection=[array objectAtIndex:i];
        collection.backgroundColor=[UIColor clearColor];
        collection.bounces = NO;
        collection.tag=i;
        if (i==0) {
            if (![[[_config objectForKey:@"ClassView"] objectForKey:@"Anyway"] isEqualToString:@"across"])
            {
                collection.pagingEnabled=YES;//翻页
                //初始化横向的cell
                [collection registerClass:[HMDCollectionViewCell class] forCellWithReuseIdentifier:@"colletionCell2"];
            }
            else
                //初始化竖向的cell
                [collection registerClass:[CSOrderCell class] forCellWithReuseIdentifier:@"colletionCell"];
        }else
        {
            //初始化大图的cell
            [collection registerClass:[CSOrderDetailCell class] forCellWithReuseIdentifier:@"colletionCell1"];
        }
        
        [collection registerClass:[CSOrderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];//头视图
        [collection registerClass:[CSOrderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];//脚视图
        collection.showsHorizontalScrollIndicator = NO;//隐藏皮条
        collection.showsVerticalScrollIndicator = NO;//隐藏皮条
        //代理
        collection.dataSource = self;
        collection.delegate = self;
    }
    _collectionD.backgroundColor=[UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:0.1];
    [self addSubview:_collectionV];
    [_collectionV reloadData];
}

#pragma mark - 数据
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //大图的
    if (collectionView.tag==1) {
        NSString *reuseIdetify = @"colletionCell1";
        CSOrderDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
        [cell setDataForView:[[_allFood objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] withIndexPath:indexPath];
        return cell;
        
    }else
    {
        if (![[[_config objectForKey:@"ClassView"] objectForKey:@"Anyway"] isEqualToString:@"across"]) {
            NSString *reuseIdetify = @"colletionCell2";
            HMDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
            /**
             *  遍历出9个
             */
            NSMutableArray *array=[[NSMutableArray alloc] init];
            for (int i=0; i<[[_allFood objectAtIndex:indexPath.section]count]; i++) {
                if (i>=indexPath.row*9) {
                    [array addObject:[[_allFood objectAtIndex:indexPath.section] objectAtIndex:i]];
                    if ([array count]==9) {
                        break;
                    }
                }
            }
            [cell setDataArray:array withIndexPath:indexPath];
            cell.parentView=_collectionV;
            return cell;
        }else
        {
            NSString *reuseIdetify = @"colletionCell";
            CSOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
            [cell setDataForView:[[_allFood objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] withIndexPath:indexPath];
            cell.parentView=_collectionV;
            return cell;
        }
    }
}
//头标
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        CSOrderReusableView *headerView=nil;
        if ([[[_config objectForKey:@"ClassView"] objectForKey:@"Anyway"] isEqualToString:@"across"]){
            headerView= [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            NSString *title = [[NSString alloc] initWithFormat:@"    %@    ",[[_classArray objectAtIndex:indexPath.section] objectForKey:@"DES"]];
            
            headerView.label.text = title;
            CGSize size= [title sizeWithFont:headerView.label.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
            headerView.label.frame=CGRectMake(0, 10, size.width, 30);
            headerView.image.frame=headerView.label.frame;
            headerView.frame=CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y, size.width, 40);
            reusableview = headerView;
            if (!_change) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeClass" object:[NSString stringWithFormat:@"%d",(int)indexPath.section]];
            }
            
        }
        else
        {
            headerView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            if (!_change) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeClass" object:[NSString stringWithFormat:@"%d",(int)indexPath.section]];
            }
            reusableview = headerView;
        }
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *footerview =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        if (!_change) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeClass" object:[NSString stringWithFormat:@"%d",(int)indexPath.section]];
        }
        reusableview = footerview;
    }
    
    return reusableview;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _change=NO;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
//    if () {
        if (collectionView==_collectionV&&[[[_config objectForKey:@"ClassView"] objectForKey:@"Anyway"] isEqualToString:@"across"])
            return 15;
         else
            return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
        if (collectionView==_collectionV&&[[[_config objectForKey:@"ClassView"] objectForKey:@"Anyway"] isEqualToString:@"across"])
            return 20;
        else
            return 0;
}
#pragma mark - cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag==1) {
        return  CGSizeFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"FoodDetailSize"]);
    }else
    {
        if ([[[_config objectForKey:@"ClassView"] objectForKey:@"Anyway"] isEqualToString:@"across"]||collectionView==_collectionD)
        {
            return CGSizeFromString([[[_config objectForKey:@"OrderView"] objectForKey:@"Order"] objectForKey:@"OrderSize"]);
        }else
        {
            return CGSizeFromString([[_config objectForKey:@"OrderView"] objectForKey:@"ItemSize"]);
        }
    }
}
#pragma mark - cell组个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_allFood count];
}
#pragma mark - cell组里的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (collectionView.tag!=1&&![[[_config objectForKey:@"ClassView"] objectForKey:@"Anyway"] isEqualToString:@"across"]) {
        if ([[_allFood objectAtIndex:section] count]%9>0) {
            return [[_allFood objectAtIndex:section] count]/9+1;
        }else
        {
            return [[_allFood objectAtIndex:section] count]/9;
        }
        
    }
    return [[_allFood objectAtIndex:section] count];
}
#pragma mark - cell选择事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView== _collectionV) {
        //点击的次数
        if (_HANDTAG==0) {
            _HANDTAG+=1;
        }else if (LASTINDEXPATH==indexPath&&_HANDTAG==1){
            _HANDTAG+=1;
        }
        //声音播放
        [CSDataProvider playSound];
        CSOrderCell *cell=(CSOrderCell *)[collectionView cellForItemAtIndexPath:
                                          indexPath];
        /**
         *  上一个选择的cell的位置
         */
        LASTINDEXPATH=indexPath;
        //判断双击事件，如果0.3S内
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.3 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            /**
             *  判断单机双击
             */
            if (_HANDTAG!=2&&LASTINDEXPATH) {
                //判断是不是套餐
                _foodDic=[[NSMutableDictionary alloc] initWithDictionary:cell.dataInfo];
                if ([[_foodDic objectForKey:@"ISTC"] intValue]==1) {
                    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[CSDataProvider CSDataProviderShare].foodsArray];
                    [_foodDic setValue:@"1" forKey:@"total"];
                    [array addObject:_foodDic];
                    [CSDataProvider CSDataProviderShare].foodsArray=array;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"package" object:_foodDic];
                }else
                {
                    //判断中餐快餐
                    if ([Mode isEqualToString:@"zc"]) {
                        [self ZCchangeUnit:cell];
                    }else
                    {
                        [self KCchangeUnit:cell];
                    }
                }
                //将值初始化
                _HANDTAG=0;
                LASTINDEXPATH=nil;
            }else if(LASTINDEXPATH)
            {
                NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"tag",indexPath,@"indexPath", nil];
                _HANDTAG=0;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeModel" object:dict];
                LASTINDEXPATH=nil;
            }
            collectionView.userInteractionEnabled=YES;
        });
    }
}
#pragma mark - 中餐多规格
- (void)ZCchangeUnit:(CSOrderCell *)btn{
    if ([[_foodDic objectForKey:@"ISUNITS"] intValue]==1) {
        NSMutableArray *mutmut = [NSMutableArray array];
        for (int i=0;i<6;i++){
            NSString *unit = [_foodDic objectForKey:0==i?@"UNIT":[NSString stringWithFormat:@"UNIT%d",i+1]];
            NSString *price = [_foodDic objectForKey:0==i?@"PRICE":[NSString stringWithFormat:@"PRICE%d",i+1]];
            if (unit && [unit length]>0)
                [mutmut addObject:[NSDictionary dictionaryWithObjectsAndKeys:price,@"price",unit,@"unit", nil]];
        }
        if ([mutmut count]>1){
            NSMutableArray *mut = [NSMutableArray array];
            for (int j=0;j<[mutmut count];j++){
                NSString *title = [NSString stringWithFormat:@"%d元/%@",[[[mutmut objectAtIndex:j] objectForKey:@"price"] intValue],[[mutmut objectAtIndex:j] objectForKey:@"unit"]];
                [mut addObject:title];
            }
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择单位"   delegate:self
                                                      cancelButtonTitle:nil
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:nil];
            // 逐个添加按钮（比如可以是数组循环）
            for (NSString *str in mut) {
                [sheet addButtonWithTitle:str];
            }
            sheet.tag=10000;
            sheet.delegate=self;
            [sheet showFromRect:btn.frame inView:self animated:YES];
        }
    }else
    {
        //添加菜品
        [self addFoodToArray];
    }
}

#pragma mark - 快餐多规格
- (void)KCchangeUnit:(CSOrderCell *)btn{
    if ([[_foodDic objectForKey:@"ISUNITS"] intValue]==1) {
        NSMutableArray *mutmut = [NSMutableArray array];
        for (int i=0;i<6;i++){
            NSString *unit = [_foodDic objectForKey:[NSString stringWithFormat:@"UNITS%d",i+1]];
            NSString *price = [_foodDic objectForKey:0==i?@"PRICE":[NSString stringWithFormat:@"PRICE%d",i+4]];
            if (unit && [unit length]>0)
                [mutmut addObject:[NSDictionary dictionaryWithObjectsAndKeys:price,@"price",unit,@"unit", nil]];
        }
        if ([mutmut count]>1){
            NSMutableArray *mut = [NSMutableArray array];
            for (int j=0;j<[mutmut count];j++){
                NSString *title = [NSString stringWithFormat:@"%d元/%@",[[[mutmut objectAtIndex:j] objectForKey:@"price"] intValue],[[mutmut objectAtIndex:j] objectForKey:@"unit"]];
                [mut addObject:title];
            }
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择单位"   delegate:self
                                                      cancelButtonTitle:nil
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:nil];
            // 逐个添加按钮（比如可以是数组循环）
            for (NSString *str in mut) {
                [sheet addButtonWithTitle:str];
            }
            sheet.delegate=self;
            sheet.tag=10001;
            [sheet showFromRect:btn.frame inView:self animated:YES];
        }
        
    }else
    {
        [self addFoodToArray];
    }
}
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex<0) {
        return;
    }
    if (actionSheet.tag==10001) {
        
        int j = 0;
        for (int i=0;i<6;i++){
            NSString *unit = [_foodDic objectForKey:[NSString stringWithFormat:@"UNITS%d",i+1]];
            if (unit && [unit length]>0){
                if (j==buttonIndex) {
                    [_foodDic setValue:unit forKey:@"UNIT"];
                    [_foodDic setValue:[NSNumber numberWithInt:i+1] forKey:@"UNITKAY"];
                    [_foodDic setValue:[_foodDic objectForKey:[NSString stringWithFormat:@"PRICE%d",i+1]] forKey:@"PRICE"];
                    break;
                }
                j++;
            }
            
        }
        [self addFoodToArray];
    }else if(actionSheet.tag==10000)
    {
        int j = 0;
        for (int i=0;i<5;i++){
            NSString *unit = [_foodDic objectForKey:i==0?@"UNIT":[NSString stringWithFormat:@"UNIT%d",i+1]];
            if (unit && [unit length]>0){
                if (j==buttonIndex) {
                    [_foodDic setValue:unit forKey:@"UNIT"];
                    [_foodDic setValue:[NSNumber numberWithInt:i+1] forKey:@"UNITKAY"];
                    [_foodDic setValue:[_foodDic objectForKey:i==0?@"PRICE":[NSString stringWithFormat:@"PRICE%d",i+1]] forKey:@"PRICE"];
                    break;
                }
                
            }
            j++;
        }
        [self addFoodToArray];
    }
}
#pragma mark - 点菜
-(void)addFoodToArray
{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[CSDataProvider CSDataProviderShare].foodsArray];
    int i=0;
    int j=0;
    /**
     *  当前点了多少份
     */
    for (NSDictionary *dict in array) {
        if ([[dict objectForKey:@"ITCODE"] isEqualToString:[_foodDic objectForKey:@"ITCODE"]]&&![dict objectForKey:@"addition"]&&[[dict objectForKey:@"ISTC"] intValue]!=1&&[[dict objectForKey:@"UNITKAY"] intValue] ==[[_foodDic objectForKey:@"UNITKAY"]intValue]) {
            i=[[dict objectForKey:@"total"] intValue];
            break;
        }
        j++;
    }
    [_foodDic setValue:[NSString stringWithFormat:@"%d",[[_foodDic objectForKey:@"count"]==nil?@"0":[_foodDic objectForKey:@"count"] intValue]+1]  forKey:@"count"];
    [_foodDic setValue:[NSString stringWithFormat:@"%d",i+1] forKey:@"total"];
    if (i>0) {
        [array removeObjectAtIndex:j];
        [array insertObject:_foodDic atIndex:j];
    }else
    {
        [array addObject:_foodDic];
    }
    [CSDataProvider CSDataProviderShare].foodsArray=array;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil userInfo:nil];
    
}


#pragma mark - 点击类别的通知
-(void)classButtonClick:(NSNotification*)notification
{
    NSString *nameString = [notification name];
    NSString *objectString = [notification object];
    if ([self.subviews containsObject:_collectionD]) {
        if ([[_allFood objectAtIndex:[objectString intValue]] count]>0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[objectString intValue]];
            [_collectionD scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        
        //        CGPoint point= _collectionV.contentOffset;
        //        point.y-=40;
        //        _change=YES;
        //        _collectionV.contentOffset=point;
    }else
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[objectString intValue]];
        if ([[_allFood objectAtIndex:indexPath.section] count]==0) {
            return;
        }
        CGPoint point= _collectionV.contentOffset;
        point.y-=40;
        _change=YES;
        _collectionV.contentOffset=point;
        if ([[[_config objectForKey:@"ClassView"] objectForKey:@"Anyway"] isEqualToString:@"across"])
        {
            [_collectionV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            
        }else
        {
            
            [_collectionV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            
        }
    }
    //    [_collectionV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
#pragma mark - 改变模式通知
-(void)changeModel:(NSNotification *)notification
{
    NSDictionary *dic = [notification object];
    if ([[dic objectForKey:@"tag"] intValue]==2) {
        //        [_collectionV removeFromSuperview];
        for (UIView *view in self.subviews) {
            if (view ==_collectionD) {
                return;
            }
        }
        
        [self addSubview:_collectionD];
        [_collectionD reloadData];
        
        _collectionV.backgroundColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
        bs_dispatch_sync_on_main_thread(^{
            [_collectionD scrollToItemAtIndexPath:(NSIndexPath *)[dic objectForKey:@"indexPath"] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        });
        
    }else
    {
        [_collectionD removeFromSuperview];
        //        [self addSubview:_collectionV];
        
        bs_dispatch_sync_on_main_thread(^{
            if ([[[_config objectForKey:@"ClassView"] objectForKey:@"Anyway"] isEqualToString:@"across"])
                [_collectionV scrollToItemAtIndexPath:(NSIndexPath *)[dic objectForKey:@"indexPath"] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            else
            {
                NSIndexPath *index=(NSIndexPath *)[dic objectForKey:@"indexPath"];
                [_collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index.section] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            }
            
        });
        [_collectionV reloadData];
    }
    
}
-(void)ChangeFrame
{
    //    _collectionV.frame=CGRectMake(0, 0,self.frame.size.width, self.frame.size.height);
    NSIndexPath *indexpath=nil;
    if (_collectionD) {
        CGFloat pageWidth = _collectionD.frame.size.width;
        // 根据当前的x坐标和页宽度计算出当前页数
        int currentPage = floor((_collectionD.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        int i=0;
        int j=0;
        for (NSArray *array in _allFood) {
            if ([array count]>0) {
                if (j+[array count]<=currentPage) {
                    j+=[array count];
                }else
                {
                    indexpath=[NSIndexPath indexPathForItem:currentPage-j inSection:i];
                    break;
                }
            }
            i++;
            
        }
    }
    _config=[CSDataProvider CSDataProviderShare].config;
    UICollectionViewFlowLayout *flowLayout = _collectionV.collectionViewLayout;
    UICollectionViewFlowLayout *flowLayout1 = _collectionD.collectionViewLayout;
    _collectionV.frame=CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"CollectionViewFrame"]);
    self.frame=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"OrderView"] objectForKey:@"ViewFrame"]);
    _collectionD.frame=CGRectFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"CollectionViewFrame"]);
    if (_collectionD) {
        flowLayout1.itemSize= CGSizeFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"FoodDetailSize"]);
        [self selfReloadData];
        [_collectionD scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        
    }else
    {
        
        flowLayout.itemSize = CGSizeFromString([[[_config objectForKey:@"OrderView"] objectForKey:@"Order"] objectForKey:@"OrderSize"]);
    }
    //    CGSizeFromString([[_config objectForKey:@"FoodDetail"] objectForKey:@"FoodDetailSize"]);
    [_collectionV reloadData];
    
}
#pragma mark - 刷新列表
-(void)selfReloadData
{
    [_collectionV reloadData];
    [_collectionD reloadData];
}
- (void) scrollViewDidScroll:(UIScrollView *)sender {
    // 得到每页宽度
    
    
}

@end
