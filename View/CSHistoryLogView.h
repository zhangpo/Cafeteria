//
//  CSHistoryLogView.h
//  Cafeteria
//
//  Created by chensen on 15/3/3.
//  Copyright (c) 2015年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSHistoryOrderView.h"



@interface CSHistoryLogView : UIViewController<UITableViewDataSource,UITableViewDelegate>
-(id)initWithData:(NSDictionary *)dataInfo;
- (void)viewDidCurrentView;
@end
