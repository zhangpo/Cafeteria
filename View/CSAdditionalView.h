//
//  CSAdditionalView.h
//  Cafeteria
//
//  Created by chensen on 14/11/28.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSAdditionalCell.h"

@interface CSAdditionalView : UIView<CSAdditionalCellDelegete>
@property(nonatomic,strong)NSMutableArray *additionArray;
- (id)initWithFrame:(CGRect)frame withItcode:(NSString *)itcode;

@end
