//
//  CSPackageView.h
//  Cafeteria
//
//  Created by chensen on 14/12/1.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSPackageView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
- (id)initWithFrame:(CGRect)frame withPackage:(NSDictionary *)dict;
@end
