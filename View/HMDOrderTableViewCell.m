//
//  HMDOrderTableViewCell.m
//  Cafeteria
//
//  Created by chensen on 14/12/23.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "HMDOrderTableViewCell.h"

@implementation HMDOrderTableViewCell
@synthesize foodName=_foodName,foodPrice=_foodPrice,foodCount=_foodCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _foodName=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [self.contentView addSubview:_foodName];
        _foodPrice=[[UILabel alloc] initWithFrame:CGRectMake(200, 0, 80, 40)];
        _foodPrice.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_foodPrice];
        _foodCount=[[UILabel alloc] initWithFrame:CGRectMake(280, 0, 40, 40)];
        _foodCount.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_foodCount];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
