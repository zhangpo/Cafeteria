//
//  CSClassView.m
//  Cafeteria
//
//  Created by chensen on 14/11/3.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//
//菜品类别界面

#import "CSClassView.h"
#import "CSDataProvider.h"

#import "CSOrderView.h"

@implementation CSClassView
//@synthesize config=_config;
#pragma mark - 初始化View
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //查询类别
        NSArray *array=[CSDataProvider getFoodClass];
        NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"ClassView"];
        //添加背景图片
        CGRect rect = CGRectFromString([dict objectForKey:@"ViewFrame"]);
        UIImageView *imageClassBG=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        //读取配置图片
        [imageClassBG setImage:[CSDataProvider imgWithContentsOfImageName:[dict objectForKey:@"BackgroundImage"]]];
        imageClassBG.tag=200;
        imageClassBG.userInteractionEnabled=YES;
        [self addSubview:imageClassBG];
        //初始化UIScrollView
        self.backgroundColor=[UIColor clearColor];
        UIScrollView *scvMenu = [[UIScrollView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"ScrollViewFrame"])];
        scvMenu.tag=201;
        [self addSubview:scvMenu];
        //设置隐藏皮条
        scvMenu.showsHorizontalScrollIndicator = NO;
        scvMenu.showsVerticalScrollIndicator = NO;
        scvMenu.bounces = NO;
        CGSize size=CGSizeFromString([[dict objectForKey:@"Class"] objectForKey:@"Size"]);
        int count = [array count];
        /**
         *  类别按钮的生成
         */
        for (int i=0;i<count;i++){
            CSClassButton *btn = [CSClassButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            NSDictionary*infoclass = [array objectAtIndex:i];
            btn.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:30];
            btn.tag = 700+i;
            btn.backgroundColor=[UIColor clearColor];
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn.classImage setImage:[UIImage imageWithContentsOfFile:[[infoclass objectForKey:@"image"] documentPath]]];
            btn.classInfo=infoclass;
            btn.lblClassName.text=[infoclass objectForKey:@"DES"];
            btn.lblClassCount.hidden=YES;
            if ([[dict objectForKey:@"Anyway"] isEqualToString:@"across"]) {
                btn.frame=CGRectMake(0, size.height*i, size.width, size.height);
                scvMenu.contentSize=CGSizeMake(size.width, size.height*count);
            }else
            {
                btn.backgroundColor=[UIColor redColor];
                btn.frame=CGRectMake(size.width*i,0, size.width, size.height);
                scvMenu.contentSize=CGSizeMake(size.width*count, size.height);
            }
            [scvMenu addSubview:btn];
        }
        if ([[scvMenu subviews] count]>0) {
            CSClassButton *btn = (CSClassButton *)[scvMenu viewWithTag:700];
            [self btnClicked:btn];
        }
        /**
         *  计算菜品数量
         */
        [self updateOrdered];
        //刷新数据的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrdered) name:@"reloadData" object:nil];
        //改变类别的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeClass:) name:@"ChangeClass" object:nil];
        //改变位置的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
        
    }
    return self;
}
#pragma mark - 移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  更新点菜数量
 */
#pragma mark - 计算点菜数量
-(void)updateOrdered
{
    UIScrollView *scroll=(UIScrollView *)[self viewWithTag:201];
        for (CSClassButton *button in [scroll subviews]) {
            button.lblClassCount.text=@"";
            button.lblClassCount.hidden=YES;
            for (NSDictionary *dict in [CSDataProvider CSDataProviderShare].foodsArray) {
            if([[dict objectForKey:@"CLASS"] isEqualToString:[button.classInfo objectForKey:@"GRP"]]){
                int i=[[dict objectForKey:@"total"] intValue]+[button.lblClassCount.text intValue];
                if (i>0) {
                    button.lblClassCount.text=[NSString stringWithFormat:@"%d",i];
                    button.lblClassCount.hidden=NO;
                }
                
            }
        }
    }
    
}
#pragma mark - 换类别的通知
-(void)ChangeClass:(NSNotification*)notification
{
    NSString *objectString = [notification object];
    UIScrollView *scroll=(UIScrollView *)[self viewWithTag:201];
    NSDictionary *dict=[[[CSDataProvider CSDataProviderShare].config objectForKey:@"ClassView"] objectForKey:@"Class"];
    
    CGSize size=CGSizeFromString([dict objectForKey:@"Size"]);
    /**
     *  初始化类别按钮
     */
    for (CSClassButton *button in [scroll subviews]) {
        button.lblClassName.textColor=[UIColor whiteColor];
        [button.classImageBG setImage:nil];
        button.classImageBG.frame=CGRectMake(0, 0, size.width, size.height);
        
    }
    CSClassButton *btn=(CSClassButton*)[scroll viewWithTag:[objectString intValue]+700];
    btn.classImageBG.frame=CGRectMake(0, 0, size.width+2, size.height);
    [btn.classImageBG setImage:[CSDataProvider imgWithContentsOfImageName:@"flxz.png"]];
    btn.classImageBG.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    btn.classImageBG.layer.shadowOffset = CGSizeMake(0, 0);
    btn.classImageBG.layer.shadowOpacity = 0.5;
    btn.classImageBG.layer.shadowRadius = 10.0;
    /**
     *  实现类别的滚动
     */
    /**
     *  判断上下滚动
     */
    if ([[[[CSDataProvider CSDataProviderShare].config objectForKey:@"ClassView"] objectForKey:@"Anyway"]isEqualToString:@"across"]) {
        if ((scroll.contentOffset.y+scroll.frame.size.height<btn.frame.origin.y+btn.frame.size.height&&scroll.contentOffset.y<btn.frame.origin.y)) {//往上滚动
            if (scroll.contentOffset.y<scroll.contentSize.height- scroll.frame.size.height) {
                CGPoint position = CGPointMake(0,btn.frame.origin.y-btn.frame.size.height);
                [scroll setContentOffset:position animated:YES];
            }
            if (scroll.contentOffset.y>scroll.contentSize.height-scroll.frame.size.height) {
                CGPoint position = CGPointMake(0,scroll.contentSize.height-scroll.frame.size.height );
                [scroll setContentOffset:position animated:YES];
            }
            
        }else if (scroll.contentOffset.y>btn.frame.origin.y&&scroll.contentOffset.y+scroll.frame.size.height>btn.frame.origin.y+btn.frame.size.height) {//往下滚动
            
            if (scroll.contentOffset.y>=btn.frame.origin.y) {
                CGPoint position = CGPointMake(0,btn.frame.origin.y);
                [scroll setContentOffset:position animated:YES];
            }
            if (scroll.contentOffset.y>btn.frame.size.height&&btn.frame.origin.y==0) {
                CGPoint position1 = CGPointMake(0,0);
                [scroll setContentOffset:position1 animated:NO];
            }
        }
    }else{
   
    /**
     *  判断左右滚动
     */
    if ((scroll.contentOffset.x+scroll.frame.size.width>btn.frame.origin.x+btn.frame.size.width&&scroll.contentOffset.x<btn.frame.origin.x)) {
        if (scroll.contentOffset.x<scroll.contentSize.width- scroll.frame.size.width) {
            CGPoint position = CGPointMake(btn.frame.origin.x,0 );
            [scroll setContentOffset:position animated:YES];
        }
        if (scroll.contentOffset.x>scroll.contentSize.width-scroll.frame.size.width) {
            CGPoint position = CGPointMake(scroll.contentSize.width-scroll.frame.size.width,0 );
            [scroll setContentOffset:position animated:YES];
        }
    }else if (scroll.contentOffset.x>btn.frame.origin.x&&scroll.contentOffset.x+scroll.frame.size.width>btn.frame.origin.x+btn.frame.size.width) {
        if (scroll.contentOffset.x>=btn.frame.origin.x) {
            CGPoint position = CGPointMake(btn.frame.origin.x,0 );
            [scroll setContentOffset:position animated:YES];
        }
        if (scroll.contentOffset.x<=btn.frame.size.width&&btn.frame.origin.x==0) {
            CGPoint position1 = CGPointMake(0,0);
            [scroll setContentOffset:position1 animated:NO];
        }
    }
}
}
#pragma mark - 更换布局通知
-(void)ChangeFrame
{
    NSDictionary *config=[[CSDataProvider CSDataProviderShare].config objectForKey:@"ClassView"];
    UIImageView *image=(UIImageView *)[self viewWithTag:200];
    image.frame=CGRectFromString([config objectForKey:@"ViewFrame"]);
    [image setImage:[CSDataProvider imgWithContentsOfImageName:[config objectForKey:@"BackgroundImage"]]];
    UIView *view=[self viewWithTag:201];
    view.frame=CGRectFromString([config objectForKey:@"ScrollViewFrame"]);
}
#pragma mark - 类别按钮事件
/**
 *  按钮事件
 *
 *  @param btn
 */
-(void)btnClicked:(CSClassButton *)btn
{
    if ([[CSDataProvider CSDataProviderShare].PackageItem count]>0||(![[[CSDataProvider CSDataProviderShare].foodsArray lastObject] objectForKey:@"combo"]&&[[[[CSDataProvider CSDataProviderShare].foodsArray lastObject] objectForKey:@"ISTC"] intValue] ==1)) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请选择完该套餐再进行该操作" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }

     UIScrollView *scroll=(UIScrollView *)[self viewWithTag:201];
    NSDictionary *dict=[[[CSDataProvider CSDataProviderShare].config objectForKey:@"ClassView"] objectForKey:@"Class"];
    CGSize size=CGSizeFromString([dict objectForKey:@"Size"]);
    /**
     *  初始化类别按钮
     */
    for (CSClassButton *button in [scroll subviews]) {
        button.lblClassName.textColor=[UIColor whiteColor];
        [button.classImageBG setImage:nil];
        button.classImageBG.frame=CGRectMake(0, 0, size.width, size.height);
        
    }
    /**
     *  选择的按钮的显示效果
     */
    btn.classImageBG.frame=CGRectMake(0, 0, size.width+2, size.height);
    [btn.classImageBG setImage:[CSDataProvider imgWithContentsOfImageName:@"flxz.png"]];
    btn.classImageBG.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    btn.classImageBG.layer.shadowOffset = CGSizeMake(0, 0);
    btn.classImageBG.layer.shadowOpacity = 0.5;
    btn.classImageBG.layer.shadowRadius = 5.0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"classButtonClick" object:[NSString stringWithFormat:@"%d",btn.tag-700]];
}


@end
