//
//  CSAdditionalCell.h
//  Cafeteria
//
//  Created by chensen on 14/11/28.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSAdditionalCellDelegete <NSObject>

-(void)CSAdditionalCellClicek:(NSDictionary *)info;

@end

@interface CSAdditionalCell : UIView
@property(nonatomic,weak)__weak id<CSAdditionalCellDelegete>delegate;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UILabel  *lblName;
@property(nonatomic,strong)NSDictionary *addiyionalData;

@end
