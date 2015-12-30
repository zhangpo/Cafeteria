//
//  CSHistoryOrderView.h
//  Cafeteria
//
//  Created by chensen on 14/12/28.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"
#import "QCSlideSwitchView.h"
#import "CSHistoryLogView.h"




@interface CSHistoryOrderView : UIView<CKCalendarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,QCSlideSwitchViewDelegate>

@end
