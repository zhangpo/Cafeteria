//
//  CSVIPOperation.m
//  Cafeteria
//
//  Created by chensen on 14/12/27.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSVIPOperation.h"
#import "CSVIPOperationButton.h"

@implementation CSVIPOperation
@synthesize VIEWTAG=_VIEWTAG;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *array=[[NSArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:[CSDataProvider localizedString:@"VIP Info"],@"DES",@"VIPOperation1.png",@"image", nil],[NSDictionary dictionaryWithObjectsAndKeys:[CSDataProvider localizedString:@"Coupons"],@"DES",@"VIPOperation2.png",@"image", nil],[NSDictionary dictionaryWithObjectsAndKeys:[CSDataProvider localizedString:@"History Order"],@"DES",@"VIPOperation3.png",@"image", nil], nil];
        NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"VIPOperation"];
        //添加背景图片
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"ViewFrame"])];
        imageView.tag=200;
        [imageView setImage:[CSDataProvider imgWithContentsOfImageName:[dict objectForKey:@"BackgroundImage"]]];
        [self addSubview:imageView];
        //初始化UIScrollView
        UIScrollView *scvMenu = [[UIScrollView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"ScrollViewFrame"])];
        scvMenu.tag=201;
        [self addSubview:scvMenu];
        //设置隐藏皮条
        scvMenu.showsHorizontalScrollIndicator = NO;
        scvMenu.showsVerticalScrollIndicator = NO;
        scvMenu.bounces = NO;
        CGSize size=CGSizeFromString([[dict objectForKey:@"VIPOperation"] objectForKey:@"Size"]);
        int count = [array count];
        for (int i=0;i<count;i++){
            CSVIPOperationButton *btn = [CSVIPOperationButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            NSDictionary *infoclass = [array objectAtIndex:i];
            btn.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:30];
            btn.tag = 700+i;
            //            btn.backgroundColor=[UIColor colorWithRed:255/255.0 green:156/255.0 blue:0/139 alpha:1];
            btn.backgroundColor=[UIColor clearColor];
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn.classImage setImage:[UIImage imageWithContentsOfFile:[[infoclass objectForKey:@"image"] documentPath]]];
            btn.classInfo=infoclass;
            btn.lblClassName.text=[infoclass objectForKey:@"DES"];
            btn.lblClassCount.hidden=YES;
                btn.frame=CGRectMake(0,size.height*i, size.width, size.height);
                scvMenu.contentSize=CGSizeMake(size.width, size.height*count);
            [scvMenu addSubview:btn];
            _VIEWTAG=@"5";
        }
        
        CSVIPOperationButton *btn=(CSVIPOperationButton *)[[self viewWithTag:201] viewWithTag:700];
        [self btnClicked:btn];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"changeFrame" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonMove) name:@"OperationMove" object:nil];
    }
    return self;
}
-(void)buttonMove
{
        UIScrollView *scroll=(UIScrollView *)[self viewWithTag:201];
        CSVIPOperationButton *button = [[scroll subviews] objectAtIndex:0];
        [self btnClicked:button];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)ChangeFrame
{
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"VIPOperation"];
    UIImageView *imageView=(UIImageView *)[self viewWithTag:200];
    imageView.frame=CGRectFromString([dict objectForKey:@"ViewFrame"]);
    [imageView setImage:[CSDataProvider imgWithContentsOfImageName:[dict objectForKey:@"BackgroundImage"]]];
    UIView *view=[self viewWithTag:201];
    view.frame=CGRectFromString([dict objectForKey:@"ScrollViewFrame"]);
}
-(void)btnClicked:(CSVIPOperationButton *)btn
{
    UIScrollView *scroll=(UIScrollView *)[self viewWithTag:201];
    for (CSVIPOperationButton *button in [scroll subviews]) {
        button.lblClassName.textColor=[UIColor whiteColor];
        [button.classImageBG setImage:nil];
    }
    [btn.classImageBG setImage:[CSDataProvider imgWithContentsOfImageName:@"flxz.png"]];
    btn.classImageBG.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    btn.classImageBG.layer.shadowOffset = CGSizeMake(0, 0);
    btn.classImageBG.layer.shadowOpacity = 0.5;
    btn.classImageBG.layer.shadowRadius = 10.0;
    if (btn.tag==700) {
        _VIEWTAG=@"5";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:@"5"];
    }else if (btn.tag==701){
        _VIEWTAG=@"27";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:@"27"];
    }else if (btn.tag==702){
        _VIEWTAG=@"6";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:@"6"];
    }
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
