//
//  CSHistoryOrderView.m
//  Cafeteria
//
//  Created by chensen on 14/12/28.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSHistoryOrderView.h"
#import "CKCalendarView.h"
#import "CSDataProvider.h"
#import "SVProgressHUD.h"
#import "QCSlideSwitchView.h"
#import "CSHistoryLogView.h"
#import "CSOrderReusableView.h"
#import "CSHistoryOrderViewCell.h"

@implementation CSHistoryOrderView
{
    CKCalendarView *_calendarView;
    NSDictionary   *_config;
    NSMutableArray        *_orderArray;
    NSMutableArray      *_viewArray;
    UICollectionView *_collectionD;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _orderArray=[[NSMutableArray alloc] init];
        _config=[[CSDataProvider CSDataProviderShare].config objectForKey:@"HistoryOrde"];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.frame];
        [imageView setImage:[CSDataProvider imgWithContentsOfImageName:@"VipBG.png"]];
        imageView.tag=99;
        [self addSubview:imageView];
        UILabel *labelTitle=[[UILabel alloc] initWithFrame:CGRectFromString([_config objectForKey:@"TitleLabelFrame"])];
        labelTitle.text=@"消费信息查询";
        [self addSubview:labelTitle];
        UILabel *labelDate=[[UILabel alloc] initWithFrame:CGRectFromString([_config objectForKey:@"DateLabelFrame"])];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        labelDate.text=[dateFormat stringFromDate:[NSDate date]];
        labelDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
        labelDate.layer.borderWidth = 2.0;
        labelDate.tag=100;
        [self addSubview:labelDate];
        
        UIButton *dataButton=[UIButton buttonWithType:UIButtonTypeCustom];
        dataButton.frame=CGRectMake(labelDate.frame.origin.x+labelDate.frame.size.width-labelDate.frame.size.height, labelDate.frame.origin.y, labelDate.frame.size.height,labelDate.frame.size.height);
        [dataButton setBackgroundImage:[CSDataProvider imgWithContentsOfImageName:@"Calendar.png"] forState:UIControlStateNormal];
        NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"dd"];
        
        [dataButton setTitle:[dateFormat1 stringFromDate:[NSDate date]] forState:UIControlStateNormal];
        [dataButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [dataButton addTarget:self action:@selector(dataButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dataButton];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
        [self historyOrderListView];
    }
    return self;
}
-(void)historyOrderListView
{
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout1.headerReferenceSize=CGSizeMake(0.1,0);
    flowLayout1.footerReferenceSize=CGSizeMake(0.1,0);
    flowLayout1.minimumLineSpacing =0;//列距
    flowLayout1.minimumLineSpacing=0;
    flowLayout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横屏
    
    _collectionD = [[UICollectionView alloc] initWithFrame:CGRectFromString([_config objectForKey:@"OrderViewFrame"])
                                      collectionViewLayout:flowLayout1];
    flowLayout1.itemSize =_collectionD.frame.size;
    _collectionD.pagingEnabled=YES;   //翻页
    _collectionD.bounces = NO;
    //初始化大图的cell
    [_collectionD registerClass:[CSHistoryOrderViewCell class] forCellWithReuseIdentifier:@"colletionCell1"];
    [_collectionD registerClass:[CSOrderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];//头视图
    [_collectionD registerClass:[CSOrderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];//脚视图
    _collectionD.showsHorizontalScrollIndicator = NO;//隐藏皮条
    _collectionD.showsVerticalScrollIndicator = NO;//隐藏皮条
    //代理
    _collectionD.dataSource = self;
    _collectionD.delegate = self;
    _collectionD.backgroundColor=[UIColor clearColor];
    [self addSubview:_collectionD];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_orderArray  count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdetify = @"colletionCell1";
    CSHistoryOrderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
    [cell setDataInfo:[_orderArray objectAtIndex:indexPath.row]];
//    [cell setDataForView:[[_allFood objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] withIndexPath:indexPath];
    return cell;
}


#pragma mark - 日历的点击事件
-(void)dataButtonClick:(UIButton *)btn
{
    if (!_calendarView) {
        NSDictionary *dict=[[CSDataProvider CSDataProviderShare] ZCqueryDate];
        NSArray *dateArray=[[NSArray alloc] init];
        if (dict) {
            if ([[dict objectForKey:@"state"] intValue]==1) {
                
                dateArray=[[dict objectForKey:@"msg"] componentsSeparatedByString:@","];
            }else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alert show];
                return;
            }
        }else
        {
            
        }
        _calendarView = [[CKCalendarView alloc] initWithStartDay:startMonday withOtherButtonArray:dateArray];
        _calendarView.frame = CGRectFromString([_config objectForKey:@"DateViewFrame"]);
        _calendarView.delegate=self;
        [self addSubview:_calendarView];
    }else
    {
        [_calendarView removeFromSuperview];
        _calendarView =nil;
    }
    
    
}
#pragma mark -calendarDelegate   点击事件
-(void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    [_calendarView removeFromSuperview];
    _calendarView =nil;
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    UILabel *label=(UILabel *)[self viewWithTag:100];
    label.text=currentDateStr;
    [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeClear];
    [NSThread detachNewThreadSelector:@selector(ZCqueryOldOrder:) toTarget:self withObject:currentDateStr];
    //输出格式为：2010-10-27 10:22:13
}
#pragma mark - 获取历史账单
-(void)ZCqueryOldOrder:(NSString *)date
{
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare] ZCqueryOldOrder:date];
    [SVProgressHUD dismiss];
    if (!dict) {
        [SVProgressHUD showErrorWithStatus:[CSDataProvider localizedString:@"ConnectionTimeout"]];
        return;
    }
    [_orderArray removeAllObjects];
    if ([[dict objectForKey:@"state"]intValue]==1) {
        NSDictionary *orderDic=[dict objectForKey:@"msg"];
        for (int i=0; i<[[orderDic allKeys] count]; i++) {
            NSDictionary *dic=[orderDic objectForKey:[[orderDic allKeys] objectAtIndex:i]];
            [_orderArray addObject:dic];
        }
        [_collectionD reloadData];
        //初始化
        
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
        [_collectionD reloadData];
    }
    
    
}
#pragma mark - 改变frame
-(void)ChangeFrame
{
    _config=[[CSDataProvider CSDataProviderShare].config objectForKey:@"HistoryOrde"];
    _collectionD.frame=CGRectFromString([_config objectForKey:@"OrderViewFrame"]);
     UICollectionViewFlowLayout *flowLayout1 = _collectionD.collectionViewLayout;
    flowLayout1.itemSize =_collectionD.frame.size;
    UIView *view=[self viewWithTag:99];
    view.frame=self.frame;
    view=[self viewWithTag:98];
    view.frame=CGRectFromString([_config objectForKey:@"OrderViewFrame"]);
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
