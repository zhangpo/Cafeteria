//
//  CSHistoryOrderViewCell.h
//  Cafeteria
//
//  Created by chensen on 15/3/5.
//  Copyright (c) 2015年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSHistoryOrderViewCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSDictionary *dataInfo;
@end
