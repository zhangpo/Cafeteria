//
//  HMDFoodView.m
//  Cafeteria
//
//  Created by chensen on 15/1/12.
//  Copyright (c) 2015年 Choicesoft. All rights reserved.
//

#import "HMDFoodView.h"

@implementation HMDFoodView
{
    NSDictionary *_config;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _config=[CSDataProvider CSDataProviderShare].config;
        NSDictionary *dict=[[[_config objectForKey:@"OrderView"] objectForKey:@"Order"] objectForKey:@"Frame"];
        //设置图片大小
        UIImageView *imgPhoto=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"PhotoFrame"])];
        imgPhoto.tag=100;
        [self addSubview:imgPhoto];
        imgPhoto.userInteractionEnabled=YES;
        //单击事件
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        [imgPhoto addGestureRecognizer:singleTapGestureRecognizer];
        //双击事件
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [imgPhoto addGestureRecognizer:doubleTapGestureRecognizer];
        //这行很关键，意思是只有当没有检测到doubleTapGestureRecognizer 或者 检测doubleTapGestureRecognizer失败，singleTapGestureRecognizer才有效
        [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableviewCellLongPressed:)];
        //将长按手势添加到需要实现长按操作的视图里
        [imgPhoto addGestureRecognizer:longPress];
        
        
        
        CGRect _rect= CGRectFromString([dict objectForKey:@"NameFrame"]);
        CGRect _imagerect=CGRectFromString([dict objectForKey:@"PhotoFrame"]);
        //设置名称
        UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"NameFrame"])];
        lblName.textColor=[UIColor blackColor];
        lblName.font=[UIFont systemFontOfSize:20];
        lblName.tag=101;
        [self addSubview:lblName];
        //设置价格
        UILabel *lblPrice=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"PriceFrame"])];
        lblPrice.textColor=[UIColor blackColor];
        lblPrice.font=[UIFont systemFontOfSize:20];
        lblPrice.tag=102;
        [self addSubview:lblPrice];
        if (_rect.origin.y+_rect.size.height<=_imagerect.origin.y+_imagerect.size.height) {
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, _rect.origin.y, self.frame.size.width, self.frame.size.height-_rect.origin.y)];
            view.backgroundColor=[UIColor colorWithRed:35/255.0 green:32/255.0 blue:28/255.0 alpha:0.7];
            [self addSubview:view];
            lblName.textColor=[UIColor whiteColor];
            lblPrice.textColor=[UIColor whiteColor];
        }
        
        
        //设置数量
        //    diancai.png
        UIImageView *imgCount=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"CountFrame"])];
        [imgCount setImage:[CSDataProvider imgWithContentsOfImageName:@"diancai.png"]];
        imgCount.tag=103;
        imgCount.hidden=YES;
        [self addSubview:imgCount];
        UILabel *lblCount=[[UILabel alloc] initWithFrame:CGRectFromString([dict objectForKey:@"CountFrame"])];
        lblCount.tag=104;
        lblCount.textColor=[UIColor whiteColor];
        lblCount.textAlignment=NSTextAlignmentCenter;
        [self addSubview:lblCount];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
