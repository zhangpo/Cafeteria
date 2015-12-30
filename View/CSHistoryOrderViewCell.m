//
//  CSHistoryOrderViewCell.m
//  Cafeteria
//
//  Created by chensen on 15/3/5.
//  Copyright (c) 2015年 Choicesoft. All rights reserved.
//

#import "CSHistoryOrderViewCell.h"
#import "CSHistoryLogCell.h"


@implementation CSHistoryOrderViewCell
{
    NSDictionary *_config;
    NSArray      *_dataArray;
    UITableView  *_historyTableView;
}
@synthesize dataInfo=_dataInfo;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initView];
    }
    return self;
}
- (void)initView
{
        _config=[[CSDataProvider CSDataProviderShare].config objectForKey:@"HistoryOrde"];
        _dataArray=[[NSMutableArray alloc] init];
        CGRect rect=CGRectFromString([_config objectForKey:@"OrderViewFrame"]);
        self.frame=CGRectMake(0, 0, rect.size.width, rect.size.height);
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 4.0;
        self.layer.cornerRadius = 6;
        self.backgroundColor=[UIColor blackColor];
        //    [self addSubview:view];
        UILabel *foodCount=[[UILabel alloc] initWithFrame:CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"FoodCountFrame"])];
        foodCount.text=@"菜品数量:";
        foodCount.tag=4001;
        foodCount.textColor=[UIColor colorWithRed:240/255.0 green:150/255.0 blue:25/255.0 alpha:1];
        [self addSubview:foodCount];
        UILabel *FoodTotal=[[UILabel alloc] initWithFrame:CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"FoodTotalFrame"])];
        FoodTotal.text=@"合计金额:";
        FoodTotal.tag=4002;
        FoodTotal.textColor=[UIColor colorWithRed:240/255.0 green:150/255.0 blue:25/255.0 alpha:1];
        [self addSubview:FoodTotal];
        UILabel *SpecialOfferFrame=[[UILabel alloc] initWithFrame:CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"SpecialOfferFrame"])];
        SpecialOfferFrame.text=@"优惠活动:";
        SpecialOfferFrame.tag=4003;
        SpecialOfferFrame.textColor=[UIColor colorWithRed:240/255.0 green:150/255.0 blue:25/255.0 alpha:1];
        [self addSubview:SpecialOfferFrame];
        UILabel *ConsumptionFrame=[[UILabel alloc] initWithFrame:CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"ConsumptionFrame"])];
        ConsumptionFrame.text=@"消费金额:";
        ConsumptionFrame.tag=4004;
        ConsumptionFrame.textColor=[UIColor colorWithRed:240/255.0 green:150/255.0 blue:25/255.0 alpha:1];
        [self addSubview:ConsumptionFrame];
        rect=CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"TableViewFrame"]);
        _historyTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) style:UITableViewStylePlain];
        _historyTableView.tag=3001;
        _historyTableView.delegate=self;
        _historyTableView.dataSource=self;
        _historyTableView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_historyTableView];
        
        UIView *HeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _historyTableView.frame.size.width, 40)];
        HeaderView.backgroundColor=[UIColor blackColor];
        _historyTableView.layer.cornerRadius = 6;
        NSArray *array=[[NSArray alloc] initWithObjects:[CSDataProvider localizedString:@"Food"],[CSDataProvider localizedString:@"Price"],[CSDataProvider localizedString:@"Unit"],[CSDataProvider localizedString:@"Count"],[CSDataProvider localizedString:@"Total"],[CSDataProvider localizedString:@"Additional"], nil];
        NSDictionary *dict=[[_config objectForKey:@"OrderView"] objectForKey:@"TableViewCell"];
        NSArray *array1=[[NSArray alloc] initWithObjects:[dict objectForKey:@"FoodNameFrame"],[dict objectForKey:@"FoodPriceFrame"],[dict objectForKey:@"FoodUnitFrame"],[dict objectForKey:@"FoodCountFrame"],[dict objectForKey:@"FoodTotPriceFrame"],[dict objectForKey:@"FoodAdditionFrame"], nil];
        for (int i=0; i<6; i++) {
            UILabel *lb=[[UILabel alloc] init];
            //        lb.backgroundColor=[UIColor redColor];
            lb.tag=5100+i;
            lb.textColor=[UIColor whiteColor];
            lb.text=[array objectAtIndex:i];
            lb.textAlignment=NSTextAlignmentCenter;
            lb.frame=CGRectFromString([array1 objectAtIndex:i]);
            [HeaderView addSubview:lb];
        }
        [_historyTableView setTableHeaderView:HeaderView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection=%d",[_dataArray count]);
    return [_dataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cellName1qw";
    CSHistoryLogCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[CSHistoryLogCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    NSDictionary *dataInfo=[_dataArray objectAtIndex:indexPath.row];
    cell.dataInfo=dataInfo;
//    cell.lblName.text=[dataInfo objectForKey:@"ITEMDES"];
//    cell.lblPrice.text=[dataInfo objectForKey:@"PRICE"];
//    cell.lblCNT.text=[dataInfo objectForKey:@"CNT"];
//    cell.lblAMT.text=[dataInfo objectForKey:@"AMT"];
//    cell.lblUnit.text=[dataInfo objectForKey:@"UNIT"];
//    cell.lblRES.text=[dataInfo objectForKey:@"RES1"];

    return cell;
}

#pragma mark - 获取数据
-(void)setDataInfo:(NSDictionary *)dataInfo
{
    _dataArray=[dataInfo objectForKey:@"listFood"];
    [_historyTableView reloadData];
    UILabel *view1=(UILabel *)[self viewWithTag:4001];
    NSString *text=[NSString stringWithFormat:@"菜品数量 :%d",[_dataArray count]];
    view1.text=text;
    view1=(UILabel *)[self viewWithTag:4002];
    NSDictionary *dict=[dataInfo objectForKey:@"payment"];
    text=[NSString stringWithFormat:@"合计金额: %.2f",[[dict objectForKey:@"AMT"] floatValue]+[[dict objectForKey:@"PAYAMT"] floatValue]+[[dict objectForKey:@"PMONEY"] floatValue]];
    view1.text=text;
    view1=(UILabel *)[self viewWithTag:4003];
    text=[NSString stringWithFormat:@"优惠活动: %@",[dict objectForKey:@"AMT"]];
    view1.text=text;
    view1=(UILabel *)[self viewWithTag:4004];
    text=[NSString stringWithFormat:@"消费金额:%@",[dict objectForKey:@"PMONEY"]];
    view1.text=text;
    
}
#pragma mark - 改变frame
-(void)ChangeFrame
{
    _config=[[CSDataProvider CSDataProviderShare].config objectForKey:@"HistoryOrde"];
    self.frame=CGRectFromString([_config objectForKey:@"OrderViewFrame"]);
    NSLog(@"%@",self);
    
    //    UIView *view=[self viewWithTag:3000];
    //    view.frame=CGRectFromString([_config objectForKey:@"OrderViewFrame"]);
    UIView *view1=[self viewWithTag:4001];
    view1.frame=CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"FoodCountFrame"]);
    view1=[self viewWithTag:4002];
    view1.frame=CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"FoodTotalFrame"]);
    view1=[self viewWithTag:4003];
    view1.frame=CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"SpecialOfferFrame"]);
    view1=[self viewWithTag:4004];
    view1.frame=CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"ConsumptionFrame"]);
    UITableView *table=(UITableView *)[self viewWithTag:3001];
    table.frame=CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"TableViewFrame"]);
    UIView *view=table.tableHeaderView;
    
    NSDictionary *dict=[[_config objectForKey:@"OrderView"] objectForKey:@"TableViewCell"];
    NSArray *array1=[[NSArray alloc] initWithObjects:[dict objectForKey:@"FoodNameFrame"],[dict objectForKey:@"FoodPriceFrame"],[dict objectForKey:@"FoodUnitFrame"],[dict objectForKey:@"FoodCountFrame"],[dict objectForKey:@"FoodTotPriceFrame"],[dict objectForKey:@"FoodAdditionFrame"], nil];
    view1=[view viewWithTag:5100];
    view1.frame=CGRectFromString([array1 objectAtIndex:0]);
    view1=[view viewWithTag:5101];
    view1.frame=CGRectFromString([array1 objectAtIndex:1]);
    view1=[view viewWithTag:5102];
    view1.frame=CGRectFromString([array1 objectAtIndex:2]);
    view1=[view viewWithTag:5103];
    view1.frame=CGRectFromString([array1 objectAtIndex:3]);
    view1=[view viewWithTag:5104];
    view1.frame=CGRectFromString([array1 objectAtIndex:4]);
    view1=[view viewWithTag:5105];
    view1.frame=CGRectFromString([array1 objectAtIndex:5]);
    
}

@end
