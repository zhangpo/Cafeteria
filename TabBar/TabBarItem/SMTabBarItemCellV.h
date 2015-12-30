//
//  SMTabBarItemCellV.h
//  SMSplitViewController
//
//  Created by Sergey Marchukov on 16.02.14.
//  Copyright (c) 2014 Sergey Marchukov. All rights reserved.
//
//  This content is released under the ( http://opensource.org/licenses/MIT ) MIT License.
//

#import <UIKit/UIKit.h>
#import "SMTabBarItem.h"

typedef enum {
    
    SMTabBarItemCellVTab,
    SMTabBarItemCellVAction
} SMTabBarItemCellVType;

@interface SMTabBarItemCellV : UITableViewCell
{
    UIView *_topSeparator;
    
    UIView *_separator;
    UIView *_viewBackground;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
//@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;
//@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, copy) ActionBlock actionBlock;
@property (nonatomic) SMTabBarItemCellVType cellType;
@property (nonatomic) BOOL isFirstCell;

@end