//
//  CSOrderDetailCell.h
//  Cafeteria
//
//  Created by chensen on 14/11/6.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSAdditionalView.h"

@interface CSOrderDetailCell : UICollectionViewCell<CSAdditionalCellDelegete,UIAlertViewDelegate,UIActionSheetDelegate>
- (void)setDataForView:(NSDictionary *)info withIndexPath:(NSIndexPath *)indexPath;
@end
