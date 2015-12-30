//
//  CSClassButton.m
//  Cafeteria
//
//  Created by chensen on 14/11/3.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//
//  类别按钮

#import "CSClassButton.h"

@implementation CSClassButton
@synthesize classInfo=_classInfo,lblClassCount=_lblClassCount,lblClassName=_lblClassName,config=_config,classImage=_classImage,classImageBG=_classImageBG;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSDictionary *dict=[[[CSDataProvider CSDataProviderShare].config objectForKey:@"ClassView"] objectForKey:@"Class"];
        CGSize size=CGSizeFromString([dict objectForKey:@"Size"]);
        //类别的背景图片
        _classImageBG=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [self addSubview:_classImageBG];
        //类别图片
        _classImage=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"ClassImageFrame"])];
        _classImage.layer.masksToBounds = YES;
        _classImage.layer.cornerRadius = _classImage.frame.size.height/2;
        CALayer * layer = [_classImage layer];
        layer.borderColor = [[UIColor whiteColor] CGColor];
        layer.borderWidth = 2.0f;
        [self addSubview:_classImage];
        //类别名称
        _lblClassName=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"ClassNameFrame"])];
        _lblClassName.backgroundColor=[UIColor clearColor];
        _lblClassName.font=[UIFont systemFontOfSize:18];
        _lblClassName.textColor=[UIColor whiteColor];
        [self addSubview:_lblClassName];
        
        //类别数量
        _lblClassCount=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"ClassCountFrame"])];
        _lblClassCount.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:16];
        _lblClassCount.backgroundColor = [UIColor clearColor];
        _lblClassCount.textColor=[UIColor whiteColor];
        _lblClassCount.layer.cornerRadius = _lblClassCount.frame.size.height/2;
        _lblClassCount.layer.backgroundColor=[UIColor redColor].CGColor;
        _lblClassCount.textAlignment = UITextAlignmentCenter;
        [self addSubview:_lblClassCount];
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
