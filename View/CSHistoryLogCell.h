//
//  CSHistoryLogCell.h
//  Cafeteria
//
//  Created by chensen on 15/3/4.
//  Copyright (c) 2015年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSHistoryLogCell : UITableViewCell
@property(nonatomic,strong)UILabel *lblName;
@property(nonatomic,strong)UILabel *lblPrice;
@property(nonatomic,strong)UILabel *lblUnit;
@property(nonatomic,strong)UILabel *lblCNT;
@property(nonatomic,strong)UILabel *lblAMT;
@property(nonatomic,strong)UILabel *lblRES;

@property(nonatomic,strong)NSDictionary *dataInfo;

@end
