//
//  CSClassViewController.m
//  Cafeteria
//
//  Created by chensen on 14/11/11.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSClassViewController.h"
//#import "CSOrderViewController.h"
//#import "CSClassView.h"

@interface CSClassViewController ()

@end

@implementation CSClassViewController
{
    NSDictionary *_pageConfig;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *pageConfig=[CSDataProvider CSDataProviderShare].config;
//    CGSize size=CGSizeFromString([[pageConfig objectForKey:@"ClassView"] objectForKey:@"ViewFrame"])
//    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 768)];
//    [imageView setImage:[UIImage imageNamed:[[pageConfig objectForKey:@"ClassView"] objectForKey:@"BackgroundImage"]]];
//    [self.view addSubview:imageView];
    
    CGRect rect=CGRectFromString([[pageConfig objectForKey:@"ClassView"] objectForKey:@"ViewFrame"]);
    CSClassView *classView=[[CSClassView alloc] initWithFrame:CGRectFromString([[pageConfig objectForKey:@"ClassView"] objectForKey:@"ViewFrame"])];
    
    classView.tag=1000;

    [self.view addSubview:classView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeFrame) name:@"ChangeFrame" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //改变详情的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:@"1"];
}
-(void)ChangeFrame
{
    UIView *view=[self.view viewWithTag:101];
    view.frame=CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"ClassView"] objectForKey:@"ViewFrame"]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
