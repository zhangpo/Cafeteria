//
//  CSHistoryLogCell.m
//  Cafeteria
//
//  Created by chensen on 15/3/4.
//  Copyright (c) 2015年 Choicesoft. All rights reserved.
//

#import "CSHistoryLogCell.h"
#import "CSDataProvider.h"

@implementation CSHistoryLogCell
@synthesize dataInfo=_dataInfo,lblName=_lblName,lblPrice=_lblPrice,lblCNT=_lblCNT,lblAMT=_lblAMT,lblUnit=_lblUnit,lblRES=_lblRES;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _lblName=[[UILabel alloc] initWithFrame:CGRectZero];
        _lblName.backgroundColor=[UIColor clearColor];
        _lblName.textColor=[UIColor blackColor];
        _lblName.tag=1800;
        [self.contentView addSubview:_lblName];
        _lblPrice=[[UILabel alloc] initWithFrame:CGRectZero];
        _lblPrice.backgroundColor=[UIColor clearColor];
        _lblPrice.textColor=[UIColor blackColor];
        _lblPrice.tag=1801;
        _lblPrice.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_lblPrice];
        _lblUnit=[[UILabel alloc] initWithFrame:CGRectZero];
        _lblUnit.backgroundColor=[UIColor clearColor];
        _lblUnit.textColor=[UIColor blackColor];
        _lblUnit.textAlignment=NSTextAlignmentCenter;
        _lblUnit.tag=1802;
        [self.contentView addSubview:_lblUnit];
        _lblCNT=[[UILabel alloc] initWithFrame:CGRectZero];
        _lblCNT.backgroundColor=[UIColor clearColor];
        _lblCNT.textColor=[UIColor blackColor];
        _lblCNT.textAlignment=NSTextAlignmentRight;
        _lblCNT.tag=1803;
        [self.contentView addSubview:_lblCNT];
        _lblAMT=[[UILabel alloc] initWithFrame:CGRectZero];
        _lblAMT.backgroundColor=[UIColor clearColor];
        _lblAMT.textColor=[UIColor blackColor];
        _lblAMT.tag=1804;
        _lblAMT.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_lblAMT];
        _lblRES=[[UILabel alloc] initWithFrame:CGRectZero];
        _lblRES.backgroundColor=[UIColor clearColor];
        _lblRES.textColor=[UIColor blackColor];
        _lblRES.tag=1805;
        [self.contentView addSubview:_lblRES];
        [self ChangeFrame];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
    }
    return self;
}
-(void)setDataInfo:(NSDictionary *)dataInfo
{
    UILabel *view1=(UILabel *)[self.contentView viewWithTag:1800];
    view1.text=[NSString stringWithFormat:@"   %@",[dataInfo objectForKey:@"ITEMDES"]];
    view1=(UILabel *)[self.contentView viewWithTag:1801];
    view1.text=[dataInfo objectForKey:@"PRICE"];
    view1=(UILabel *)[self.contentView viewWithTag:1802];
    view1.text=[dataInfo objectForKey:@"UNIT"];
    view1=(UILabel *)[self.contentView viewWithTag:1803];
    view1.text=[dataInfo objectForKey:@"CNT"];
    view1=(UILabel *)[self.contentView viewWithTag:1804];
    view1.text=[dataInfo objectForKey:@"AMT"];
    view1=(UILabel *)[self.contentView viewWithTag:1805];
    view1.text=[dataInfo objectForKey:@"RES1"];
}
#pragma mark - 改变frame
-(void)ChangeFrame
{
    NSDictionary *config=[[CSDataProvider CSDataProviderShare].config objectForKey:@"HistoryOrde"];
    NSDictionary *dict=[[config objectForKey:@"OrderView"] objectForKey:@"TableViewCell"];
    NSArray *array1=[[NSArray alloc] initWithObjects:[dict objectForKey:@"FoodNameFrame"],[dict objectForKey:@"FoodPriceFrame"],[dict objectForKey:@"FoodUnitFrame"],[dict objectForKey:@"FoodCountFrame"],[dict objectForKey:@"FoodTotPriceFrame"],[dict objectForKey:@"FoodAdditionFrame"], nil];
    UIView *view1=[self.contentView viewWithTag:1800];
    view1.frame=CGRectFromString([array1 objectAtIndex:0]);
    view1=[self.contentView viewWithTag:1801];
    view1.frame=CGRectFromString([array1 objectAtIndex:1]);
    view1=[self.contentView viewWithTag:1802];
    view1.frame=CGRectFromString([array1 objectAtIndex:2]);
    view1=[self.contentView viewWithTag:1803];
    view1.frame=CGRectFromString([array1 objectAtIndex:3]);
    view1=[self.contentView viewWithTag:1804];
    view1.frame=CGRectFromString([array1 objectAtIndex:4]);
    view1=[self.contentView viewWithTag:1805];
    view1.frame=CGRectFromString([array1 objectAtIndex:5]);
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
