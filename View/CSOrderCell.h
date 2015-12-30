//
//  SelectThemeCollectionViewCell.h
//  IMFiveApp
//
//  Created by chen on 14-8-30.
//  Copyright (c) 2014年 chen. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@interface CSOrderCell : UICollectionViewCell<UIAlertViewDelegate>
@property(nonatomic,strong)NSArray *package;
@property(nonatomic,strong)UICollectionView *parentView;
@property(nonatomic,strong)NSMutableDictionary     *dataInfo;
- (id)initWithFrame:(CGRect)frame;
- (void)setDataForView:(NSDictionary *)info withIndexPath:(NSIndexPath *)indexPath;
@end
