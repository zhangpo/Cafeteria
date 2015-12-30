//
//  CSOrderView.h
//  Cafeteria
//
//  Created by chensen on 14/11/4.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSOrderCell.h"

@interface CSOrderView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>
- (id)initWithFrame:(CGRect)frame;
@end
