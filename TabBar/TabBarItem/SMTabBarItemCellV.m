//
//  SMTabBarItemCellV.m
//  SMSplitViewController
//
//  Created by Sergey Marchukov on 16.02.14.
//  Copyright (c) 2014 Sergey Marchukov. All rights reserved.
//
//  This content is released under the ( http://opensource.org/licenses/MIT ) MIT License.
//

#import "SMTabBarItemCellV.h"

@implementation SMTabBarItemCellV

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeLeft;
        [self addSubview:_iconView];
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:10];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
//        _selectedColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    NSLog(@"%f",self.bounds.size.width);
    _iconView.frame = CGRectMake(self.bounds.size.width / 2 - 50/ 2, -6, 50, 50);
    _titleLabel.frame = CGRectMake(0, self.bounds.size.height - 20, 40, 12);
    if (_separator)
        _separator.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
}

#pragma mark -
#pragma mark - Properties

- (void)setImage:(UIImage *)image {
    
    _image = image;
}

- (void)setIsFirstCell:(BOOL)isFirstCell {
    
    _isFirstCell = isFirstCell;
    
    if (isFirstCell) {
        
        _topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
        _topSeparator.backgroundColor = [UIColor blackColor];
        [self addSubview:_topSeparator];
    }
}

- (void)setCellType:(SMTabBarItemCellVType)cellType {
    
    _cellType = cellType;
    
    if (_cellType == SMTabBarItemCellVTab) {
        
        _separator = [[UIView alloc] init];
        _separator.backgroundColor = [UIColor blackColor];
        [self addSubview:_separator];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    _titleLabel.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:47/255.0 alpha:0.8];
    _titleLabel.textColor=[UIColor blackColor];
    if (_cellType == SMTabBarItemCellVTab) {
        
        _viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 1)];
        _viewBackground.backgroundColor = highlighted ? _selectedColor : [UIColor clearColor];
        self.backgroundView = _viewBackground;
        
        if (_isFirstCell) {
            
            _topSeparator.hidden = highlighted ? YES : NO;
        }
    }
    
    _iconView.image = highlighted ? _selectedImage : _image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    _titleLabel.textColor = [UIColor colorWithRed:254/255.0 green:181/255.0 blue:0 alpha:0.8];
    _titleLabel.textColor=[UIColor blackColor];
    if (_cellType == SMTabBarItemCellVTab) {
        
        _viewBackground.backgroundColor = selected ? _selectedColor : [UIColor clearColor];
    }
    
//    if (_isFirstCell) {
//        
//        _topSeparator.hidden = selected ? YES : NO;
//    }
    
    _iconView.image = selected ? _selectedImage : _image;
}


@end