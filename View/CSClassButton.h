//
//  CSClassButton.h
//  Cafeteria
//
//  Created by chensen on 14/11/3.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSClassButton : UIButton
@property(nonatomic,strong)NSDictionary *classInfo;         //类别信息
@property(nonatomic,strong)UILabel      *lblClassName;      //类别名称
@property(nonatomic,strong)UILabel      *lblClassCount;     //改类别点菜数量
@property(nonatomic,strong)NSDictionary *config;            //配置
@property(nonatomic,strong)UIImageView  *classImage;        //类别图片
@property(nonatomic,strong)UIImageView  *classImageBG;      //类别的背景图片

@end
