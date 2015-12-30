//
//  SMTabBarV.h
//  SMSplitViewController
//
//  Created by Sergey Marchukov on 15.02.14.
//  Copyright (c) 2014 Sergey Marchukov. All rights reserved.
//
//  This content is released under the ( http://opensource.org/licenses/MIT ) MIT License.
//

#import <UIKit/UIKit.h>

@protocol SMTabBarVDelegate;

@interface SMTabBarV : UIView <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
#define iOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define tabBarWidth 50
#define tabItemHeight 60
#define tabsButtonsFrame CGRectMake(0, 10 + iOS_7 * 20, tabBarWidth, _tabsButtonsHeight)
#define actionButtonFrame CGRectMake(0, self.frame.size.height - _actionsButtonsHeight + iOS_7 * 20 - tabItemHeight / 2 * iOS_7 - 10 * !iOS_7, tabBarWidth, _actionsButtonsHeight)

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) NSArray *tabsButtons;
@property (nonatomic, strong) NSArray *actionsButtons;
@property (weak, nonatomic) id<SMTabBarVDelegate> delegate;
@property (nonatomic) NSUInteger selectedTabIndex;

@end

@protocol SMTabBarVDelegate <NSObject>

@required
-(void)tabBar:(int)tag;
- (void)tabBar:(SMTabBarV *)tabBar selectedViewController:(UIViewController *)vc;

@end