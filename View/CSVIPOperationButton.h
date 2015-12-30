//
//  CSVIPOperationButton.h
//  Cafeteria
//
//  Created by chensen on 14/12/28.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSVIPOperationButton : UIButton
@property(nonatomic,strong)NSDictionary *classInfo;         //类别信息
@property(nonatomic,strong)UILabel      *lblClassName;      //类别名称
@property(nonatomic,strong)UILabel      *lblClassCount;     //改类别点菜数量
@property(nonatomic,strong)NSDictionary *config;            //配置
@property(nonatomic,strong)UIImageView  *classImage;
@property(nonatomic,strong)UIImageView  *classImageBG;

@end
