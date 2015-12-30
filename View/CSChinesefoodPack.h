//
//  CSChinesefoodPack.h
//  Cafeteria
//
//  Created by chensen on 14/11/24.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSOrderCell.h"


@interface CSChinesefoodPack : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

- (id)initWithFrame:(CGRect)frame withPackage:(NSDictionary *)dict;
@end
