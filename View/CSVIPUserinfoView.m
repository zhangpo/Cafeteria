//
//  CSVIPUserinfoView.m
//  Cafeteria
//
//  Created by chensen on 14/12/28.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSVIPUserinfoView.h"

@implementation CSVIPUserinfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.frame];
        [imageView setImage:[CSDataProvider imgWithContentsOfImageName:@"VipBG.png"]];
        imageView.tag=100;
        [self addSubview:imageView];
        NSArray *array=[[NSArray alloc] initWithObjects:[CSDataProvider localizedString:@"VIP name"],[CSDataProvider localizedString:@"Phone number"],[CSDataProvider localizedString:@"Birthday"],[CSDataProvider localizedString:@"Stored value balance"],[CSDataProvider localizedString:@"Integral"],[CSDataProvider localizedString:@"State"],[CSDataProvider localizedString:@"Type"],[CSDataProvider localizedString:@"The effective date"], nil];
        for (int i=0;i<[array count];i++) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 100+60*i,250, 50)];
            lb.text=[array objectAtIndex:i];
            lb.textAlignment=NSTextAlignmentRight;
            lb.font=[UIFont systemFontOfSize:20];
            [self addSubview:lb];
            lb.textColor=[UIColor blackColor];
        }
        
        for (int i=0;i<[array count];i++) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(280, 100+60*i,250, 50)];
            lb.tag=8000+i;
//            lb.textAlignment=NSTextAlignmentLeft;
            lb.font=[UIFont systemFontOfSize:25];
            [self addSubview:lb];
            lb.textColor=[UIColor blackColor];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrame) name:@"changeFrame" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showData:) name:@"changeView" object:nil];
        
    }
    return self;
}
-(void)showData:(NSNotification *)notification
{
    NSInteger i = [[notification object] intValue];
    if (i==5) {
        
        NSDictionary *dict=[CSDataProvider CSDataProviderShare].VIPINFO;
        NSArray *array1=[[NSArray alloc] initWithObjects:[dict objectForKey:@"name"],[dict objectForKey:@"tele"],@"",[CSDataProvider CSDataProviderShare].cardCash!=nil?[CSDataProvider CSDataProviderShare].cardCash:[dict objectForKey:@"zAmt"],[CSDataProvider CSDataProviderShare].cardIntegral!=nil?[CSDataProvider CSDataProviderShare].cardIntegral:[dict objectForKey:@"zfen"],[dict objectForKey:@"status"],[dict objectForKey:@"typDes"],[dict objectForKey:@"endDate"], nil];
        for (int i=0; i<8; i++) {
            UILabel *lb=(UILabel *)[self viewWithTag:8000+i];
            lb.text=[array1 objectAtIndex:i];
        }

    }
}
#pragma mark - 会员信息查询
-(void)ZCqueryVip
{
    [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeClear];
    [NSThread detachNewThreadSelector:@selector(ZCqueryVipRequest) toTarget:self withObject:nil];
}
#pragma mark -
-(void)ZCqueryVipRequest
{
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare] ZCqueryVip];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"state"] intValue]==1) {
        UILabel *lb=(UILabel *)[self viewWithTag:2003];
        lb.text=[[dict objectForKey:@"msg"] objectForKey:@"smoney"];
        UILabel *lb1=(UILabel *)[self viewWithTag:2004];
        lb1.text=[[dict objectForKey:@"msg"] objectForKey:@"sjifen"];
        
//        dataArray=[[CSDataProvider CSDataProviderShare] getCouponConsumption:[[dict objectForKey:@"msg"] objectForKey:@"tickets"]];
//        bs_dispatch_sync_on_main_thread(^{
//            [_collectionV reloadData];
//        });
        
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)changeFrame
{
    UIView *view=[self viewWithTag:100];
    CGRect rect=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"MainView"] objectForKey:@"DetailViewFrame"]);
    view.frame=CGRectMake(0, 0, rect.size.width, rect.size.height);
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
