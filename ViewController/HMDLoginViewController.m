//
//  HMDLoginViewController.m
//  Cafeteria
//
//  Created by chensen on 14/12/18.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "HMDLoginViewController.h"
#import "HMDOrderViewController.h"
#import "CSSettingViewController.h"
#import "CSDataProvider.h"

@interface HMDLoginViewController ()

@end

@implementation HMDLoginViewController
{
    NSMutableArray *buttonArray;
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
    buttonArray=[[NSMutableArray alloc] init];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [imageView setImage:[UIImage imageNamed:@"HMDLogin.jpg"]];
    [self.view addSubview:imageView];
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"中文",@"English",@"日本語",nil];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(130, 375, 760, 55)];
    view.backgroundColor=[UIColor colorWithRed:200/255.0 green:200/255.0 blue:135/255.0 alpha:0.2];
    [self.view addSubview:view];
    [CSDataProvider CSDataProviderShare].languageTag=@"1";
    for (int i=0; i<3; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(20+250*i, 7, 220, 35);
        button.backgroundColor=[UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:[segmentedArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        button.tag=i;
        [button addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [buttonArray addObject:button];
    }
    for (int i=0; i<2; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(280+240*i, 675, 230, 50);
        button.backgroundColor=[UIColor clearColor];
        button.tag=i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    UIButton * button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(964, 708, 40, 40);
    [button1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag=2;
    [button1 setImage:[CSDataProvider imgWithContentsOfImageName:@"setting.png"] forState:UIControlStateNormal];
    [self.view addSubview:button1];
}
-(void)segmentAction:(UIButton *)Segmented{
    for (UIButton *button in buttonArray) {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [Segmented setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    if (Segmented.tag==0) {
        [CSDataProvider CSDataProviderShare].languageTag=@"1";
    }else if(Segmented.tag==1){
        [CSDataProvider CSDataProviderShare].languageTag=@"2";
    }else
    {
        [CSDataProvider CSDataProviderShare].languageTag=@"11";
    }
}
-(void)btnClick:(UIButton *)btn{
    if (btn.tag!=2) {
        if (btn.tag==0) {
            [CSDataProvider CSDataProviderShare].openTableTag=@"3";
        }else
        {
            [CSDataProvider CSDataProviderShare].openTableTag=@"4";
        }
        HMDOrderViewController *orderView=[[HMDOrderViewController alloc] init];
        [self.navigationController pushViewController:orderView animated:YES];
    }else
    {
        CSSettingViewController *settingUpViewController = [[CSSettingViewController alloc]initWithNibName:nil bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:settingUpViewController];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        //        [self presentModalViewController:nav animated:YES];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
