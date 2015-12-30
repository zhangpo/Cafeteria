//
//  CSOrderReusableView.m
//  Cafeteria
//
//  Created by chensen on 14/11/5.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//
//  点菜或套餐组名

#import "CSOrderReusableView.h"

@implementation CSOrderReusableView
@synthesize label=_label,image=_image;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,0, 0)];
        _label.font=[UIFont systemFontOfSize:20];
        _label.layer.cornerRadius = 12;
        _label.backgroundColor=[UIColor clearColor];
        _label.textColor=[UIColor whiteColor];
        _label.layer.backgroundColor=[UIColor colorWithRed:252/255.0 green:160/255.0 blue:25/255.0 alpha:1].CGColor;
        [self addSubview:_label];;
    }
    return self;
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
