//
//  HMDOrder.h
//  Cafeteria
//
//  Created by chensen on 14/12/23.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OrderDelegate <NSObject>

-(void)OrderButtonClick:(UIButton *)btn;

@end

@interface HMDOrder : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)__weak id<OrderDelegate>delegate;

@end
