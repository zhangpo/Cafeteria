//
//  CSLogView.m
//  Cafeteria
//
//  Created by chensen on 14/12/2.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

/**
 *  view.tag         900 附加项TableView
                     901 价格TableView
                     1000 背景图片
 */



#import "CSDataProvider.h"
#import "CSLogView.h"

@implementation CSLogView

#pragma mark - 显示附加项
- (id)initAdditionWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"CheckOrdersView"];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"ViewFrame"])];
        [imageView setImage:[CSDataProvider imgWithContentsOfImageName:[dict objectForKey:@"BackgroundImage"]]];
        imageView.tag=1000;
        imageView.userInteractionEnabled=YES;
        [self addSubview:imageView];
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"TableViewFrame"]) style:UITableViewStylePlain];
        
        tableView.delegate=self;
        tableView.tag=900;
        tableView.dataSource=self;
        tableView.backgroundColor=[UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // etch是腐蚀的意思，这样设置会使分隔线为虚线，但这种风格只对table view style 为 UITableViewStyleGrouped  有效
        [self addSubview:tableView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfReloadData) name:@"reloadData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
    }
    return self;
}
#pragma mark - 显示价格
- (id)initPriceWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"CheckOrdersView"];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"ViewFrame"])];
        [imageView setImage:[CSDataProvider imgWithContentsOfImageName:[dict objectForKey:@"BackgroundImage"]]];
        imageView.tag=1000;
        [self addSubview:imageView];
        UITableView *_tableView=[[UITableView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"TableViewFrame"]) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.tag=901;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // etch是腐蚀的意思，这样设置会使分隔线为虚线，但这种风格只对table view style 为 UITableViewStyleGrouped  有效
        [self addSubview:_tableView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfReloadData) name:@"QueryReloadData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
    }
    return self;
}
#pragma mark - 改变位置
-(void)ChangeFrame{
     NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"CheckOrdersView"];
    UIImageView *image=(UIImageView *)[self viewWithTag:1000];
    image.frame=CGRectFromString([dict objectForKey:@"ViewFrame"]);
    [image setImage:[CSDataProvider imgWithContentsOfImageName:[dict objectForKey:@"BackgroundImage"]]];
    UIView *view=[self viewWithTag:901];
    if (view) {
        view.frame=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"Settlement"] objectForKey:@"TableViewFrame"]);
    }
    view=[self viewWithTag:900];
    if (view) {
        view.frame=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"CheckOrdersView"] objectForKey:@"TableViewFrame"]);
    }
    
}
#pragma mark - 移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 刷新资料
-(void)selfReloadData
{
    for (int i=0; i<2; i++) {
        UITableView *table=(UITableView *)[self viewWithTag:900+i];
        if ([table isKindOfClass:[UITableView class]]&&table!=nil) {
            [table reloadData];
        }
        //跳转到最后一行
        if (table) {
            NSUInteger sectionCount = [table numberOfSections];
            if (sectionCount) {
                NSUInteger rowCount = [table numberOfRowsInSection:0];
                if (rowCount) {
                    NSUInteger ii[2] = {0, rowCount - 1};
                    NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
                    [table scrollToRowAtIndexPath:indexPath
                                 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }  
            }
        }
        
    }
}
#pragma mark - tableViewDelegate&&tableViewdataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==901) {
        return [[CSDataProvider CSDataProviderShare].foodQueryArray count];
    }else
    {
    return [[CSDataProvider CSDataProviderShare].foodsArray count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cellName";
    CSLogTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[CSLogTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    if (tableView.tag==900) {
        [cell setLogDataAddition:[[CSDataProvider CSDataProviderShare].foodsArray objectAtIndex:indexPath.row] withIndex:indexPath withTag:indexPath.row];
        cell.delegate=self;
    }else{
        [cell setLogDataPrice:[[CSDataProvider CSDataProviderShare].foodQueryArray objectAtIndex:indexPath.row] withTag:indexPath.row];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize rect=CGSizeFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"CheckOrdersView"] objectForKey:@"OrderSize"]);
    return rect.height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  判断套餐，如果是套餐点击展开显示明细
     */
    if (tableView.tag==900) {
        NSMutableArray *array=[CSDataProvider CSDataProviderShare].foodsArray;
        NSDictionary *dict=[array objectAtIndex:indexPath.row];
        
        if (([dict objectForKey:@"PACKID"]&&![dict objectForKey:@"ITEM"]&&![[dict objectForKey:@"ISSHOW"]isEqualToString:@"Y"])||([[dict objectForKey:@"ISTC"] intValue]==1&&![[dict objectForKey:@"ISSHOW"]isEqualToString:@"Y"])) {
            NSIndexSet *set=[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange (indexPath.row+1, [[dict objectForKey:@"combo"] count])];
            [dict setValue:@"Y" forKey:@"ISSHOW"];
            NSArray *array1=[NSArray arrayWithArray:[dict objectForKey:@"combo"]];
            for (NSDictionary *dic in array1) {
                [dic setValue:@"" forKey:@"total"];
            }
            [array insertObjects:array1 atIndexes:set];
        }else if (([dict objectForKey:@"PACKID"]&&![dict objectForKey:@"ITEM"]&&![[dict objectForKey:@"ISSHOW"]isEqualToString:@"N"])||([[dict objectForKey:@"ISTC"] intValue]==1&&![[dict objectForKey:@"ISSHOW"]isEqualToString:@"N"]))
        {
            NSIndexSet *set=[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange (indexPath.row+1, [[dict objectForKey:@"combo"] count])];
            [dict setValue:@"N" forKey:@"ISSHOW"];
            [array removeObjectsAtIndexes:set];
            //            [array insertObjects:[dict objectForKey:@"combo"] atIndexes:set];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
        [CSDataProvider CSDataProviderShare].foodsArray=array;
        [tableView reloadData];
    }else
    {
        NSMutableArray *array=[CSDataProvider CSDataProviderShare].foodQueryArray;
        NSDictionary *dict=[array objectAtIndex:indexPath.row];
        if ([dict objectForKey:@"TAG"]&&[[dict objectForKey:@"TAG"] isEqualToString:@"PACKAGE"])
        {
        if (![[dict objectForKey:@"ISSHOW"]isEqualToString:@"Y"]) {
            NSIndexSet *set=[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange (indexPath.row+1, [[dict objectForKey:@"combo"] count])];
            [dict setValue:@"Y" forKey:@"ISSHOW"];
            NSArray *array1=[NSArray arrayWithArray:[dict objectForKey:@"combo"]];
            for (NSDictionary *dic in array1) {
                [dic setValue:@"" forKey:@"total"];
            }
            [array insertObjects:array1 atIndexes:set];
        }else if (![[dict objectForKey:@"ISSHOW"]isEqualToString:@"N"])
        {
            NSIndexSet *set=[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange (indexPath.row+1, [[dict objectForKey:@"combo"] count])];
            [dict setValue:@"N" forKey:@"ISSHOW"];
            [array removeObjectsAtIndexes:set];
            //            [array insertObjects:[dict objectForKey:@"combo"] atIndexes:set];
        }
                  }        
        [CSDataProvider CSDataProviderShare].foodQueryArray=array;
        [tableView reloadData];
    }
    
    //        i++;
    //    }
}
//是否可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==900) {
        if ([[[CSDataProvider CSDataProviderShare].foodsArray objectAtIndex:indexPath.row] objectForKey:@"CNT"]) {
            return NO;
        }else
        {
            return YES;
        }
    }else
    {
        return NO;
    }
}
//编辑按钮事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteFood:indexPath];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
-(void)deleteFood:(NSIndexPath *)indexPath
{
    NSMutableArray *array=[CSDataProvider CSDataProviderShare].foodsArray;
    NSDictionary *dict=[array objectAtIndex:indexPath.row];
    //判断套餐
    NSMutableArray *ary=[[NSMutableArray alloc] init];
    [ary addObject:indexPath];
    if (([[dict objectForKey:@"ISTC"] intValue]==1||[dict objectForKey:@"PACKID"])&&[[dict objectForKey:@"ISSHOW"] isEqualToString:@"Y"]) {
        for (int i=1;i<=[[dict objectForKey:@"combo"] count];i++) {
            
            NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:indexPath.row+i inSection:indexPath.section];
            [ary addObject:indexPath1];
        }
        NSIndexSet *set=[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange (indexPath.row+1, [[dict objectForKey:@"combo"] count])];
        [dict setValue:@"N" forKey:@"ISSHOW"];
        [array removeObjectsAtIndexes:set];
    }
    [CSDataProvider CSDataProviderShare].foodsArray=array;
    // Delete the row from the data source.
    [array removeObjectAtIndex:indexPath.row];
    //    [tableView deleteRowsAtIndexPaths:ary withRowAnimation:UITableViewRowAnimationFade];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
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
