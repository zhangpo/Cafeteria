//
//  CSLogView.h
//  Cafeteria
//
//  Created by chensen on 14/12/2.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSLogTableViewCell.h"

@interface CSLogView : UIView<UITableViewDataSource,UITableViewDelegate,TableViewCellDelegate>
- (id)initAdditionWithFrame:(CGRect)frame;
- (id)initPriceWithFrame:(CGRect)frame;

@end
