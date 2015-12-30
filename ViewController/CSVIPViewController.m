//
//  CSVIPViewController.m
//  Cafeteria
//
//  Created by chensen on 14/12/27.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSVIPViewController.h"
#import "CSVIPOperation.h"

@interface CSVIPViewController ()

@end

@implementation CSVIPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDictionary *pageConfig=[CSDataProvider CSDataProviderShare].config;
        //    CGSize size=CGSizeFromString([[pageConfig objectForKey:@"ClassView"] objectForKey:@"ViewFrame"])
        
        
        CSVIPOperation *classView=[[CSVIPOperation alloc] initWithFrame:CGRectFromString([[pageConfig objectForKey:@"VIPOperation"] objectForKey:@"ViewFrame"])];
//        classView.backgroundColor=[UIColor blackColor];
        
        classView.tag=1000;
        
        [self.view addSubview:classView];

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CSVIPOperation *VIPOperation=(CSVIPOperation *)[self.view viewWithTag:1000];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:VIPOperation.VIEWTAG];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
