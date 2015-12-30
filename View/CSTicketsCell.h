//
//  CSTicketsCell.h
//  Cafeteria
//
//  Created by chensen on 15/2/10.
//  Copyright (c) 2015年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSTicketsCell : UICollectionViewCell
@property(nonatomic,strong)NSDictionary *dataDic;
-(void)setIntegralData:(NSDictionary *)dataDic;

@end
