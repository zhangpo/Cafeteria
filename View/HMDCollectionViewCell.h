//
//  HMDCollectionViewCell.h
//  Cafeteria
//
//  Created by chensen on 15/1/12.
//  Copyright (c) 2015年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDCollectionViewCell : UICollectionViewCell<UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)NSArray *package;
@property(nonatomic,strong)UICollectionView *parentView;
- (id)initWithFrame:(CGRect)frame;
-(void)setDataArray:(NSArray *)array withIndexPath:(NSIndexPath *)indexPath;
@end
