//
//  CSLoginViewController.m
//  Cafeteria
//
//  Created by chensen on 14/11/11.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSLoginViewController.h"
#import "CSSettingViewController.h"
#import "CSMainViewController.h"
#import "AFNetworking.h"
#import "SBJSON.h"
#import "CSDataProvider.h"
#import "SVProgressHUD.h"

@interface CSLoginViewController ()

@end

@implementation CSLoginViewController
{
    AFHTTPRequestOperationManager *manager; //创建请求（iOS 6-7）
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
    //导航条隐藏
    self.navigationController.navigationBar.hidden=YES;
    /**
     *  背景图片
     */
    UIImageView *imageView=[[UIImageView alloc] init];
    [imageView setImage:[CSDataProvider imgWithContentsOfImageName:@"login.jpg"]];
    imageView.tag=900;
    [self.view addSubview:imageView];
    
    //设置按钮
    UIButton * button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(984, 728, 40, 40);
    [button1 setBackgroundImage:[CSDataProvider imgWithContentsOfImageName:@"setting.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag=2;
    [self.view addSubview:button1];
    button1.backgroundColor=[UIColor clearColor];
    //判断横竖屏
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        imageView.frame=CGRectMake(0, 0, 1024, 768);
        button1.frame=CGRectMake(964, 708, 50, 50);
        [imageView setImage:[CSDataProvider imgWithContentsOfImageName:@"login.png"]];
    }else
    {
        
        imageView.frame=CGRectMake(0, 0, 768, 1024);
        button1.frame=CGRectMake(708, 964, 50, 50);
        [imageView setImage:[CSDataProvider imgWithContentsOfImageName:@"login_v.png"]];
    }
    [self creatLoginView];
    
}
/**
 *  登录框
 */
-(void)creatLoginView
{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 560, 320)];
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        imageView.center = CGPointMake(512,384);
    }else
    {
        imageView.center = CGPointMake(384,512);
    }
    [imageView setImage:[CSDataProvider imgWithContentsOfImageName:@"loginBox.png"]];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled=YES;
    imageView.tag=901;
    UIImageView *logo=[[UIImageView alloc] initWithFrame:CGRectMake(35, 35, 440, 50)];
    [logo setImage:[CSDataProvider imgWithContentsOfImageName:@"logo.png"]];
    [imageView addSubview:logo];
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(175, 245,210, 50);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=1;
    button.backgroundColor=[UIColor clearColor];
    [imageView addSubview:button];
    UITextField *textField1=[[UITextField alloc] initWithFrame:CGRectMake(130, 110, 340, 40)];
    textField1.clearsOnBeginEditing = YES;
    textField1.tag=9010;
    textField1.clearButtonMode = UITextFieldViewModeUnlessEditing;
    [imageView addSubview:textField1];
    textField1.text=@"18811111114";
    UITextField *textField2=[[UITextField alloc] initWithFrame:CGRectMake(130, 170, 340, 40)];
    textField2.clearsOnBeginEditing = YES;
    textField2.tag=9011;
    textField2.text=@"123456";
    textField2.clearButtonMode = UITextFieldViewModeUnlessEditing;
    textField2.secureTextEntry = YES;
    [imageView addSubview:textField2];
}

/**
 *
 */
-(void)LoginRequest
{
    [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeClear];
    //卡号
    UITextField *tf1=(UITextField *)[[self.view viewWithTag:901] viewWithTag:9010];
    //密码
    UITextField *tf2=(UITextField *)[[self.view viewWithTag:901] viewWithTag:9011];
    //获取当前时间
    NSDate *datenow = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *date = [dateFormatter stringFromDate:datenow];
    NSString *pwd=[CSDataProvider md5:[NSString stringWithFormat:@"%@-%@",date,tf2.text]];
    NSString *weatherUrl1=[NSString stringWithFormat:@"%@login?padid=%@&cardno=%@&pwd=%@",[CSDataProvider ZCCafeteriaWebServiceIP],[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"],tf1.text,pwd];
    NSURLRequest* request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:[weatherUrl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSLog(@"%@",weatherUrl1);
    AFHTTPRequestOperation* operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dicInfo1 = [NSDictionary dictionaryWithXMLData:operation.responseData];
        [SVProgressHUD dismiss];
        NSData *jsonData = [[dicInfo1 objectForKey:@"ns:return"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [[NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err] objectForKey:@"result"];
        if(err) {
            NSLog(@"json解析失败：%@",err);
        }else
        {
            if ([[dic objectForKey:@"state"] intValue] ==1) {
                [CSDataProvider CSDataProviderShare].VIPINFO=[dic objectForKey:@"msg"];
                [CSDataProvider CSDataProviderShare].cardNum=tf1.text;
                [CSDataProvider CSDataProviderShare].cardWord=tf2.text;
                [CSDataProvider CSDataProviderShare].SAVETIME=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                CSMainViewController *main=[[CSMainViewController alloc] init];
                [self.navigationController pushViewController:main animated:YES];
            }else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[CSDataProvider localizedString:@"Loginfailed"] message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
                [alert show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接超时"];
    }];
    [operation1 start];
}


#pragma mark - 判断视图改变的方法
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self changFrame];
}
-(void)changFrame
{
    UIImageView *view=(UIImageView *)[self.view viewWithTag:900];
    
    //    UIView *view1=[self.view viewWithTag:1];
    UIView *view2=[self.view viewWithTag:2];
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        [view setImage:[CSDataProvider imgWithContentsOfImageName:@"login.png"]];
        view.frame=CGRectMake(0, 0, 1024, 768);
        view2.frame=CGRectMake(984, 728, 40, 40);
    }else
    {
        [view setImage:[CSDataProvider imgWithContentsOfImageName:@"login_v.png"]];
        view.frame=CGRectMake(0, 0, 768, 1024);
        view2.frame=CGRectMake(728, 984, 40, 40);
    }
    UIView *view3=[self.view viewWithTag:901];
    view3.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
}
#pragma mark - 按钮事件
-(void)buttonClick:(UIButton *)btn
{
    if (btn.tag==1) {
//        UITextField *tf1=(UITextField *)[[self.view viewWithTag:901] viewWithTag:9010];
//
//
//        [CSDataProvider CSDataProviderShare].cardNum=tf1.text;
//        CSMainViewController *main=[[CSMainViewController alloc] init];
//        [self.navigationController pushViewController:main animated:YES];
    [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(login) toTarget:self withObject:nil];
//        [self LoginRequest];
//        [self login];
    }else
    {
        CSSettingViewController *settingUpViewController = [[CSSettingViewController alloc]initWithNibName:nil bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:settingUpViewController];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:nav animated:YES completion:^{
            
        }];

    }
}
-(void)login
{
    UITextField *tf1=(UITextField *)[[self.view viewWithTag:901] viewWithTag:9010];
    //密码
    UITextField *tf2=(UITextField *)[[self.view viewWithTag:901] viewWithTag:9011];
    NSDictionary *info=[[NSDictionary alloc] initWithObjectsAndKeys:tf1.text,@"user",tf2.text,@"password", nil];
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare]ZCLogin:info];
    [SVProgressHUD dismiss];
    if (!dict) {
        [SVProgressHUD showErrorWithStatus:[CSDataProvider localizedString:@"ConnectionTimeout"]];
        return;
    }
    if ([[dict objectForKey:@"state"] intValue] ==1) {
        [CSDataProvider CSDataProviderShare].VIPINFO=[dict objectForKey:@"msg"];
        [CSDataProvider CSDataProviderShare].cardNum=tf1.text;
        [CSDataProvider CSDataProviderShare].cardWord=tf2.text;
        [CSDataProvider CSDataProviderShare].SAVETIME=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        [CSDataProvider CSDataProviderShare].cardID=[[dict objectForKey:@"msg"] objectForKey:@"cardId"];
        bs_dispatch_sync_on_main_thread(^{
            CSMainViewController *main=[[CSMainViewController alloc] init];
            [self.navigationController pushViewController:main animated:YES];
        });
        
    }else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[CSDataProvider localizedString:@"Loginfailed"] message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];
        });
        
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [CSDataProvider CSDataProviderShare].foodsArray=nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
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
