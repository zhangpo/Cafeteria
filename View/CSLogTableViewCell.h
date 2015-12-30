//
//  CSLogTableViewCell.h
//  Cafeteria
//
//  Created by chensen on 14/11/13.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableViewCellDelegate <NSObject>

-(void)deleteFood:(NSIndexPath *)indexPath;

@end

@interface TableViewCellBackgroundView : UIView

@end
@interface CSLogTableViewCell : UITableViewCell<UIAlertViewDelegate>
-(void)setLogDataAddition:(NSDictionary *)info withIndex:(NSIndexPath *)indexPath withTag:(int)tag;
-(void)setLogDataPrice:(NSDictionary *)info withTag:(int)tag;
-(void)setLogDataUrge:(NSDictionary *)info withTag:(int)tag;
@property(nonatomic,weak)__weak id<TableViewCellDelegate>delegate;

@end
