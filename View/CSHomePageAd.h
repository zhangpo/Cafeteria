//
//  CSHomePageAd.h
//  Cafeteria
//
//  Created by chensen on 14/12/3.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"

@interface CSHomePageAd : UIView
@property(nonatomic,strong)CycleScrollView *mainScorllView;
@property(nonatomic,strong)CycleScrollView *homeScorllView;
- (id)initHomeAdWithFrame:(CGRect)frame;

@end
