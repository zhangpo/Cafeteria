//
//  HMDOrder.m
//  Cafeteria
//
//  Created by chensen on 14/12/23.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "HMDOrder.h"
#import "HMDOrderTableViewCell.h"

@implementation HMDOrder
{
    UITableView *table;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *image=[[UIImageView alloc]initWithFrame:frame];
        [image setImage:[CSDataProvider imgWithContentsOfImageName:@"HMDOrder.png"]];
        [self addSubview:image];
//        BSDataProvider *dp = [BSDataProvider sharedInstance];
//        dataArray=[dp orderedFood];
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 340, 30)];
        float i=0.00;
        for (NSDictionary *dict in [CSDataProvider CSDataProviderShare].foodsArray) {
            i+=[[dict objectForKey:@"total"] intValue]*[[dict objectForKey:@"PRICE"]floatValue];
        }
        lb.text=[NSString stringWithFormat:@"账单金额:￥%.2f",i];
        table=[[UITableView alloc] initWithFrame:CGRectMake(310, 120, 340, 500) style:UITableViewStylePlain];
        table.delegate=self;
        table.dataSource=self;
        [table setTableHeaderView:lb];
        [self addSubview:table];
        for (int i=0; i<2; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(310+175*i, 655, 170, 45);
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor=[UIColor clearColor];
            button.tag=i;
            [self addSubview:button];
        }
        
    }
    return self;
}
-(void)btnClick:(UIButton *)btn
{
    [_delegate OrderButtonClick:btn];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[CSDataProvider CSDataProviderShare].foodsArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    HMDOrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[HMDOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.foodName.text=[NSString stringWithFormat:@"%d.%@",indexPath.row+1,[[[CSDataProvider CSDataProviderShare].foodsArray objectAtIndex:indexPath.row] objectForKey:@"DES"]];
    cell.foodPrice.text=[NSString stringWithFormat:@"%.2f",[[[[CSDataProvider CSDataProviderShare].foodsArray objectAtIndex:indexPath.row] objectForKey:@"PRICE"] floatValue]];
    cell.foodCount.text=[[[CSDataProvider CSDataProviderShare].foodsArray objectAtIndex:indexPath.row] objectForKey:@"total"];
    
    return cell;
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
