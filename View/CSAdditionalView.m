//
//  CSAdditionalView.m
//  Cafeteria
//
//  Created by chensen on 14/11/28.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSAdditionalView.h"
#import "CSAdditionalCell.h"

@implementation CSAdditionalView
@synthesize additionArray=_additionArray;
- (id)initWithFrame:(CGRect)frame withItcode:(NSString *)itcode
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIScrollView *scroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 560, 240)];
        scroll.tag=104;
        [self addSubview:scroll];
        NSArray *array=[CSDataProvider getAdditional:itcode];
        for (int i=0;i<[array count];i++){
            int row = i/3;
            int column = i%3;
            NSDictionary *dic = [array objectAtIndex:i];
            CSAdditionalCell *AdditionalCell = [[CSAdditionalCell alloc] initWithFrame:CGRectMake(185*column, 65*row, 185, 44)];
            AdditionalCell.tag = i;
            AdditionalCell.delegate=self;
            AdditionalCell.addiyionalData=dic;
            if ([Mode isEqualToString:@"zc"]) {
                AdditionalCell.lblName.text=[dic objectForKey:@"DES"];
            }else
            {
                AdditionalCell.lblName.text=[dic objectForKey:@"FNAME"];
            }
            [scroll addSubview:AdditionalCell];
            [scroll setContentSize:CGSizeMake(185*column+185*(column-1), 65*row+65)];
        }
    }
    return self;
}
#pragma mark - CSAdditionalCellDelegate
-(void)CSAdditionalCellClicek:(NSDictionary *)info
{
    if (!_additionArray) {
        _additionArray =[[NSMutableArray alloc] init];
    }
    if ([_additionArray indexOfObject:info] != NSNotFound) {
        [_additionArray removeObject:info];
        if ([_additionArray count]==0) {
            _additionArray=nil;
        }
    }else
    {
        [_additionArray addObject:info];
    }
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
