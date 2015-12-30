//
//  CSVIPOperationButton.m
//  Cafeteria
//
//  Created by chensen on 14/12/28.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSVIPOperationButton.h"

@implementation CSVIPOperationButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSDictionary *dict=[[[CSDataProvider CSDataProviderShare].config objectForKey:@"VIPOperation"] objectForKey:@"VIPOperation"];
        CGSize size=CGSizeFromString([dict objectForKey:@"Size"]);
        _classImageBG=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [self addSubview:_classImageBG];
        _classImage=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"VIPOperationImageFrame"])];
        _classImage.layer.masksToBounds = YES;
        _classImage.layer.cornerRadius = _classImage.frame.size.height/2;
        CALayer * layer = [_classImage layer];
        layer.borderColor = [
                             [UIColor whiteColor] CGColor];
        layer.borderWidth = 2.0f;
        //        _classImage.borderColor = [[UIColor whiteColor] CGColor];
        //        _classImage.borderWidth = 5.0f;
        
        [self addSubview:_classImage];
        _lblClassName=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"VIPOperationNameFrame"])];
        _lblClassName.backgroundColor=[UIColor clearColor];
        _lblClassName.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:20];
        [self addSubview:_lblClassName];
        _lblClassName.textColor=[UIColor whiteColor];
        
        _lblClassCount=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"ClassCountFrame"])];
        _lblClassCount.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:20];
        _lblClassCount.backgroundColor = [UIColor clearColor];
        _lblClassCount.textColor=[UIColor whiteColor];
        _lblClassCount.layer.cornerRadius = _lblClassCount.frame.size.height/2;
        _lblClassCount.layer.backgroundColor=[UIColor redColor].CGColor;
        //            label.layer.cornerRadius = 10;
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
