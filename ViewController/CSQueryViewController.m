//
//  CSQueryViewController.m
//  Cafeteria
//
//  Created by chensen on 14/12/25.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSQueryViewController.h"
#import "CSQueryView.h"

@interface CSQueryViewController ()

@end

@implementation CSQueryViewController

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
//    UITableView *tableView=[UITableView alloc]
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare].config objectForKey:@"Query"];
    
    self.view.backgroundColor=[UIColor whiteColor];
   
    CSQueryView *query=[[CSQueryView alloc] initWithFrame:CGRectFromString([dict objectForKey:@"ViewFrame"])];
    [self.view addSubview:query];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //改变详情的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:@"4"];
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
