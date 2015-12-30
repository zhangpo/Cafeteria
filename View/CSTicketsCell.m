//
//  CSTicketsCell.m
//  Cafeteria
//
//  Created by chensen on 15/2/10.
//  Copyright (c) 2015年 Choicesoft. All rights reserved.
//

#import "CSTicketsCell.h"
#import "CSDataProvider.h"

@implementation CSTicketsCell
@synthesize dataDic=_dataDic;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGSize size=CGSizeFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"VipCard"] objectForKey:@"ItemSize"]);
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        imageView.tag=6000;
        [self.contentView addSubview:imageView];
        UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-30)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.font=[UIFont systemFontOfSize:30];
        lblName.textColor=[UIColor whiteColor];
        lblName.textAlignment=NSTextAlignmentCenter;
        lblName.tag=6001;
        [self.contentView addSubview:lblName];
        UILabel *lblTime=[[UILabel alloc] initWithFrame:CGRectMake(0, size.height-30, size.width, 30)];
        lblTime.backgroundColor=[UIColor clearColor];
        lblTime.font=[UIFont systemFontOfSize:16];
        lblTime.textColor=[UIColor whiteColor];
        lblTime.textAlignment=NSTextAlignmentCenter;
        lblTime.tag=6002;
        [self.contentView addSubview:lblTime];
    }
    return self;
}
#pragma mark -  数据
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic=dataDic;
    UILabel *lbl=(UILabel *)[self.contentView viewWithTag:6001];
    lbl.text=[dataDic objectForKey:@"ticketname"];
    lbl=(UILabel *)[self.contentView viewWithTag:6002];
    lbl.text=[dataDic objectForKey:@"ticketval"];
    UIImageView *image=(UIImageView *)[self viewWithTag:6000];
    if ([[dataDic objectForKey:@"ticketmoney"] intValue]<=50) {
        
        [image setImage:[CSDataProvider imgWithContentsOfImageName:@"ticke50.png"]];
    }else if ([[dataDic objectForKey:@"ticketmoney"] intValue]<=100){
        [image setImage:[CSDataProvider imgWithContentsOfImageName:@"ticke100.png"]];
    }else if ([[dataDic objectForKey:@"ticketmoney"] intValue]<=200)
    {
        [image setImage:[CSDataProvider imgWithContentsOfImageName:@"ticke200.png"]];
    }else
    {
        [image setImage:[CSDataProvider imgWithContentsOfImageName:@"ticke200+.png"]];
    }
}
#pragma mark -  积分数据
-(void)setIntegralData:(NSDictionary *)dataDic
{
    _dataDic=dataDic;
    UILabel *lbl=(UILabel *)[self.contentView viewWithTag:6001];
    lbl.text=[dataDic objectForKey:@"VNAME"];
//    lbl=(UILabel *)[self.contentView viewWithTag:6002];
//    lbl.text=[dataDic objectForKey:@"ticketval"];
    UIImageView *image=(UIImageView *)[self viewWithTag:6000];
    [image setImage:[CSDataProvider imgWithContentsOfImageName:@"Integral.png"]];
//    if ([[dataDic objectForKey:@"ticketmoney"] intValue]<=50) {
//        
//        [image setImage:[CSDataProvider imgWithContentsOfImageName:@"ticke50.png"]];
//    }else if ([[dataDic objectForKey:@"ticketmoney"] intValue]<=100){
//        [image setImage:[CSDataProvider imgWithContentsOfImageName:@"ticke100.png"]];
//    }else if ([[dataDic objectForKey:@"ticketmoney"] intValue]<=200)
//    {
//        [image setImage:[CSDataProvider imgWithContentsOfImageName:@"ticke200.png"]];
//    }else
//    {
//        [image setImage:[CSDataProvider imgWithContentsOfImageName:@"ticke200+.png"]];
//    }
    
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
