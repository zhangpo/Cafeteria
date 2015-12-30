//
//  CSAdditionalCell.m
//  Cafeteria
//
//  Created by chensen on 14/11/28.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSAdditionalCell.h"

@implementation CSAdditionalCell
@synthesize button=_button,lblName=_lblName,addiyionalData=_addiyionalData,delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _button=[UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame=CGRectMake(0, 0, 44, 54);
        [_button setBackgroundImage:[CSDataProvider imgWithContentsOfImageName:@"Normal.png"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        _lblName=[[UILabel alloc] initWithFrame:CGRectMake(60, 0, 160, 44)];
        _lblName.textColor=[UIColor whiteColor];
        _lblName.font=[UIFont systemFontOfSize:20];
        [self addSubview:_lblName];
    }
    return self;
}
-(void)buttonClick:(UIButton *)btn
{
    if (btn.selected) {
        btn.selected=NO;
        [_delegate CSAdditionalCellClicek:_addiyionalData];
        [_button setBackgroundImage:[CSDataProvider imgWithContentsOfImageName:@"Normal.png"] forState:UIControlStateNormal];
    }else{
        btn.selected=YES;
        [_delegate CSAdditionalCellClicek:_addiyionalData];
        [_button setBackgroundImage:[CSDataProvider imgWithContentsOfImageName:@"Select.png"] forState:UIControlStateNormal];
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
