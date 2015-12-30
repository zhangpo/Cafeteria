//
//  CSHistoryLogView.m
//  Cafeteria
//
//  Created by chensen on 15/3/3.
//  Copyright (c) 2015年 Choicesoft. All rights reserved.
//

#import "CSHistoryLogView.h"
#import "CSDataProvider.h"
#import "CSHistoryLogCell.h"

@implementation CSHistoryLogView
{
    NSDictionary        *_config;
    NSMutableArray      *_dataArray;
    UITableView         *_historyTableView;
    NSDictionary        *_dataInfo;
}
-(id)initWithData:(NSDictionary *)dataInfo
{
    self=[super init];
    if (self) {
        _config=[[CSDataProvider CSDataProviderShare].config objectForKey:@"HistoryOrde"];
        _dataArray=[[NSMutableArray alloc] init];
        CGRect rect=CGRectFromString([_config objectForKey:@"OrderViewFrame"]);
        self.view.frame=CGRectMake(0, 0, rect.size.width, rect.size.height);
        self.view.layer.borderColor = [UIColor blackColor].CGColor;
        self.view.layer.borderWidth = 4.0;
        self.view.layer.cornerRadius = 6;
        self.view.backgroundColor=[UIColor blackColor];
        //    [self.view addSubview:view];
        _dataArray=[dataInfo objectForKey:@"listFood"];
        _dataInfo=dataInfo;
        UILabel *foodCount=[[UILabel alloc] initWithFrame:CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"FoodCountFrame"])];
        foodCount.text=@"菜品数量:";
        foodCount.tag=4001;
        foodCount.textColor=[UIColor colorWithRed:240/255.0 green:150/255.0 blue:25/255.0 alpha:1];
        [self.view addSubview:foodCount];
        UILabel *FoodTotal=[[UILabel alloc] initWithFrame:CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"FoodTotalFrame"])];
        FoodTotal.text=@"合计金额:";
        FoodTotal.tag=4002;
        FoodTotal.textColor=[UIColor colorWithRed:240/255.0 green:150/255.0 blue:25/255.0 alpha:1];
        [self.view addSubview:FoodTotal];
        UILabel *SpecialOfferFrame=[[UILabel alloc] initWithFrame:CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"SpecialOfferFrame"])];
        SpecialOfferFrame.text=@"优惠活动:";
        SpecialOfferFrame.tag=4003;
        SpecialOfferFrame.textColor=[UIColor colorWithRed:240/255.0 green:150/255.0 blue:25/255.0 alpha:1];
        [self.view addSubview:SpecialOfferFrame];
        UILabel *ConsumptionFrame=[[UILabel alloc] initWithFrame:CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"ConsumptionFrame"])];
        ConsumptionFrame.text=@"消费金额:";
        ConsumptionFrame.tag=4004;
        ConsumptionFrame.textColor=[UIColor colorWithRed:240/255.0 green:150/255.0 blue:25/255.0 alpha:1];
        [self.view addSubview:ConsumptionFrame];
        rect=CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"TableViewFrame"]);
        _historyTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) style:UITableViewStylePlain];
        _historyTableView.tag=3001;
        _historyTableView.delegate=self;
        _historyTableView.dataSource=self;
        _historyTableView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_historyTableView];
        
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
        
//        [_historyTableView reloadData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
        
    }
    return self;
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
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.textLabel.text=@"111";
    return cell;
}

- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
}
#pragma mark - 获取数据
-(void)setDataInfo:(NSDictionary *)dataInfo
{
    
    
}
#pragma mark - 改变frame
-(void)ChangeFrame
{
    _config=[[CSDataProvider CSDataProviderShare].config objectForKey:@"HistoryOrde"];
    self.view.frame=CGRectFromString([_config objectForKey:@"OrderViewFrame"]);
     NSLog(@"%@",self.view);
    
//    UIView *view=[self.view viewWithTag:3000];
//    view.frame=CGRectFromString([_config objectForKey:@"OrderViewFrame"]);
    UIView *view1=[self.view viewWithTag:4001];
    view1.frame=CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"FoodCountFrame"]);
    view1=[self.view viewWithTag:4002];
    view1.frame=CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"FoodTotalFrame"]);
    view1=[self.view viewWithTag:4003];
    view1.frame=CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"SpecialOfferFrame"]);
    view1=[self.view viewWithTag:4004];
    view1.frame=CGRectFromString([[_config objectForKey:@"OrderView"] objectForKey:@"ConsumptionFrame"]);
    UITableView *table=(UITableView *)[self.view viewWithTag:3001];
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
