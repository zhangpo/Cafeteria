//
//  CSSettingViewController.m
//  Cafeteria
//
//  Created by chensen on 14/12/8.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "CSSettingViewController.h"
#import "OpenUDID.h"
#import "AFNetworking.h"

@interface CSSettingViewController ()

@end

@implementation CSSettingViewController
{
    GRRequestsManager *requestsManager;
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[CSDataProvider localizedString:@"Finish"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickLeftBtn)];
    UITableView *setting = [[UITableView alloc] initWithFrame:CGRectMake(0,0,550, 650) style:UITableViewStyleGrouped];
    setting.tag=100;
    setting.delegate = self;
    setting.dataSource = self;
    [self.view addSubview:setting];
}
-(void)clickLeftBtn
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 2;
            break;
        case 5:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellName=@"cellName";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.text=@"";
    cell.accessoryView=nil;
    cell.detailTextLabel.textAlignment=NSTextAlignmentRight;
    cell.detailTextLabel.textColor=[UIColor blackColor];
    cell.detailTextLabel.text=@"";
    switch (indexPath.section) {
            //声音设置
        case 0:{
            switch (indexPath.row) {
                case 0:
                {
                    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"sound"]) {
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sound"];
                    }
                    cell.textLabel.text=[CSDataProvider localizedString:@"Sound"];
                    UISwitch *sw = [[UISwitch alloc] init];
                    [sw sizeToFit];
                    [sw addTarget:self action:@selector(skipClicked:) forControlEvents:UIControlEventValueChanged];
                    //        sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"SkipSend"];
                    sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"sound"];
                    cell.accessoryView = sw;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        case 1:{
            switch (indexPath.row) {
                case 0:
                {
                    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"POSID"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"POSID"];
                    }
                    cell.textLabel.text=@"POSID或台位号:";
                    cell.detailTextLabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"POSID"];
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:{
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text=[CSDataProvider localizedString:@"Physical coding"];
                    cell.detailTextLabel.text=[OpenUDID value];
                }
                    break;
                case 1:
                {
                    cell.textLabel.text=[CSDataProvider localizedString:@"Equipment coding"];
                    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"iPadID"];
                    }
                    cell.detailTextLabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:{
            switch (indexPath.row) {
                case 0:
                {
                    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"user"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user"];
                    }
                    cell.textLabel.text=[CSDataProvider localizedString:@"User Name"];
                    cell.detailTextLabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
                }
                    break;
                case 1:
                {
                    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"password"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
                    }
                    cell.textLabel.text=[CSDataProvider localizedString:@"Password"];
                    cell.detailTextLabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
                }
                    break;
                case 2:
                {
                    
                    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"api"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"api"];
                    }
                    cell.textLabel.text=[CSDataProvider localizedString:@"FTP address"];
                    cell.detailTextLabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"api"];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 4:{
            switch (indexPath.row) {
                case 0:
                {
                    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"ip"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ip"];
                    }
                    cell.textLabel.text=@"IP";
                    cell.detailTextLabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
                }
                    break;
                case 1:
                {
                    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"port"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"port"];
                    }
                    cell.textLabel.text=[CSDataProvider localizedString:@"Port"];
                    cell.detailTextLabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"port"];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 5:{
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=[CSDataProvider localizedString:@"Update the data"];
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert=[[UIAlertView alloc] init];
    alert.delegate=self;
    [alert addButtonWithTitle:[CSDataProvider localizedString:@"Cancel"]];
    [alert addButtonWithTitle:[CSDataProvider localizedString:@"OK"]];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    UITextField *tf1=[alert textFieldAtIndex:0];
    tf1.delegate=self;
    switch (indexPath.section) {
        case 0:
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:
                {
                    alert.title=[CSDataProvider localizedString:@"Please enter the POSID"];
                    alert.tag=201;
                    tf1.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"POSID"];
                    [alert show];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:{
            switch (indexPath.row) {
                case 0:
                {
                    [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeBlack];
                    NSString *weatherUrl =[NSString stringWithFormat:@"%@registerDeviceId?&handvId=%@",[[CSDataProvider CSDataProviderShare] HMDwebServiceIP],[OpenUDID value]];
//                    NSURL *url = [NSURL URLWithString:weatherUrl];
                    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:weatherUrl]];
                    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    //设置下载完成调用的block
                    
                    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject){
                        [SVProgressHUD dismiss];
                        NSDictionary *dicInfo = [NSDictionary dictionaryWithXMLData:operation.responseData];
                        if (dicInfo) {
                            NSString *str=[dicInfo objectForKey:@"ns:return"];
                            NSArray *array=[str componentsSeparatedByString:@"@"];
                            if ([[array objectAtIndex:0] intValue]==0) {
                                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                            }else
                            {
                                [SVProgressHUD showErrorWithStatus:[array objectAtIndex:1]];
                            }
                        }
                        NSLog(@"Service Data String:%@",dicInfo);
                    }failure:^(AFHTTPRequestOperation* operation, NSError* error){
                        [SVProgressHUD dismiss];
                        NSLog( @"Server timeout!" );
                    }];
                    [operation start];

                }
                    break;
                case 1:
                {
                    alert.title=[CSDataProvider localizedString:@"Please enter the physical encoding"];
                    alert.tag=202;
                    tf1.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"iPadID"];
                    [alert show];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:{
            switch (indexPath.row) {
                case 0:
                {
                    alert.title=[CSDataProvider localizedString:@"Please enter your user name"];
                    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
                    alert.tag=301;
                    tf1.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
                    [alert show];
                }
                    break;
                case 1:
                {
                    alert.title=[CSDataProvider localizedString:@"Please enter the password"];
                    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
                    tf1.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
                    alert.tag=302;
                    [alert show];
                }
                    break;
                case 2:
                {
                    alert.title=[CSDataProvider localizedString:@"Please enter the FTP address"];
                    alert.tag=303;
                    tf1.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"api"];
                    [alert show];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 4:{
            switch (indexPath.row) {
                case 0:
                {
                    alert.title=[CSDataProvider localizedString:@"Please enter the IP address"];
                    alert.tag=401;
                    tf1.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
                    [alert show];
                }
                    break;
                case 1:
                {
                    alert.title=[CSDataProvider localizedString:@"Please enter the port"];
                    tf1.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"port"];
                    alert.tag=402;
                    [alert show];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 5:{
            switch (indexPath.row) {
                case 0:
                {
                    requestsManager = [[GRRequestsManager alloc] initWithHostname:[[NSUserDefaults standardUserDefaults] objectForKey:@"api"] user:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] password:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
                    requestsManager.delegate=self;
                    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    NSString *localFilePath = [documentsDirectoryPath stringByAppendingPathComponent:@"booksystem.zip"];
                    
                    [requestsManager addRequestForDownloadFileAtRemotePath:@"booksystem/booksystem.zip" toLocalPath:localFilePath];
                    [requestsManager startProcessingRequests];
                }
                    break;
                default:
                    break;
            }
        }
            
        default:
            break;
    }
}
#pragma mark - GRRequestsManagerDelegate

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didStartRequest:(id<GRRequestProtocol>)request
{
    NSLog(@"requestsManager:didStartRequest:");
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteListingRequest:(id<GRRequestProtocol>)request listing:(NSArray *)listing
{
    
    NSLog(@"requestsManager:didCompleteListingRequest:listing: \n%@", listing);
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteCreateDirectoryRequest:(id<GRRequestProtocol>)request
{
    NSLog(@"requestsManager:didCompleteCreateDirectoryRequest:");
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteDeleteRequest:(id<GRRequestProtocol>)request
{
    NSLog(@"requestsManager:didCompleteDeleteRequest:");
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompletePercent:(float)percent maximumSize:(float)maximumSize forRequest:(id<GRRequestProtocol>)request
{
    //    [NSString stringWithFormat:@"%.2f",request.maximumSize];
    [SVProgressHUD showProgress:-1 status:[NSString stringWithFormat:@"更新%.2f%%",percent*100]];
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteUploadRequest:(id<GRDataExchangeRequestProtocol>)request
{
    NSLog(@"requestsManager:didCompleteUploadRequest:");
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteDownloadRequest:(id<GRDataExchangeRequestProtocol>)request
{
    [SVProgressHUD showSuccessWithStatus:@"更新完成"];
    NSLog(@"requestsManager:didCompleteDownloadRequest:");
    [CSDataProvider UnzipCloseFile];
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didFailWritingFileAtPath:(NSString *)path forRequest:(id<GRDataExchangeRequestProtocol>)request error:(NSError *)error
{
    [SVProgressHUD showSuccessWithStatus:@"更新失败"];
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didFailRequest:(id<GRRequestProtocol>)request withError:(NSError *)error
{
    NSLog(@"requestsManager:didFailRequest:withError: \n %@", error);
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array=[[NSArray alloc] initWithObjects:[CSDataProvider localizedString:@"Sound Settings"],[CSDataProvider localizedString:@"POS Code Settings"],[CSDataProvider localizedString:@"iPad Setting"],[CSDataProvider localizedString:@"FTP Settings"],[CSDataProvider localizedString:@"IP Setting"],[CSDataProvider localizedString:@"Data"], nil];
    return [array objectAtIndex:section];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
//    UITextField *tf1=[alertView textFieldAtIndex:0];
//    [tf1 resignFirstResponder];
//    [alertView resignFirstResponder];
    if (alertView.tag==201) {
        UITextField *tf1=[alertView textFieldAtIndex:0];
        [tf1 resignFirstResponder];
        if (buttonIndex==1) {
            [[NSUserDefaults standardUserDefaults] setObject:tf1.text forKey:@"POSID"];
        }
    }else if (alertView.tag==202) {
        UITextField *tf1=[alertView textFieldAtIndex:0];
        [tf1 resignFirstResponder];
        if (buttonIndex==1) {
            [[NSUserDefaults standardUserDefaults] setObject:tf1.text forKey:@"iPadID"];
        }
    }else if (alertView.tag==301) {
        UITextField *tf1=[alertView textFieldAtIndex:0];
        [tf1 resignFirstResponder];
        if (buttonIndex==1) {
            [[NSUserDefaults standardUserDefaults] setObject:tf1.text forKey:@"user"];
        }
    }else if (alertView.tag==302) {
        UITextField *tf1=[alertView textFieldAtIndex:0];
        [tf1 resignFirstResponder];
        if (buttonIndex==1) {
            [[NSUserDefaults standardUserDefaults] setObject:tf1.text forKey:@"password"];
        }
    }else if (alertView.tag==303) {
        UITextField *tf1=[alertView textFieldAtIndex:0];
        [tf1 resignFirstResponder];
        if (buttonIndex==1) {
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"user"]||![[NSUserDefaults standardUserDefaults] objectForKey:@"password"]) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[CSDataProvider localizedString:@"Please enter your user name or password"] message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
                [alert show];
                return;
            }
            [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Is to test whether the FTP"] maskType:SVProgressHUDMaskTypeBlack];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                BOOL succeed=[[CSDataProvider CSDataProviderShare] checkFTPSetting:tf1.text];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    [SVProgressHUD dismiss];
                    if (succeed) {
                        bs_dispatch_sync_on_main_thread(^{
                            UIAlertView*alert=[[UIAlertView alloc] initWithTitle:[CSDataProvider localizedString:@"FTP set success"] message:nil delegate:self cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
                            alert.tag=1000;
                            [alert show];
                        });
                    }else
                    {
                        bs_dispatch_sync_on_main_thread(^{
                            UIAlertView*alert=[[UIAlertView alloc] initWithTitle:[CSDataProvider localizedString:@"FTP set failed"] message:nil delegate:nil cancelButtonTitle:[CSDataProvider localizedString:@"OK"] otherButtonTitles:nil];
                            [alert show];
                        });
                    }
                });  
            });
        }
    }else if (alertView.tag==401) {
        UITextField *tf1=[alertView textFieldAtIndex:0];
        [tf1 resignFirstResponder];
        if (buttonIndex==1) {
            [[NSUserDefaults standardUserDefaults] setObject:tf1.text forKey:@"ip"];
        }
    }else if (alertView.tag==402) {
        UITextField *tf1=[alertView textFieldAtIndex:0];
        [tf1 resignFirstResponder];
        if (buttonIndex==1) {
            [[NSUserDefaults standardUserDefaults] setObject:tf1.text forKey:@"port"];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    UITableView *table=(UITableView *)[self.view viewWithTag:100];
    [table reloadData];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldDoneEditing:textField];
}
-(IBAction)textFieldDoneEditing:(id)sender
{
	[sender resignFirstResponder];
}
-(void)skipClicked:(UISwitch *)sw
{
    NSUserDefaults *myUserDefaults = [NSUserDefaults standardUserDefaults];
    [myUserDefaults setBool:sw.isOn forKey:@"sound"];
    [myUserDefaults synchronize];
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
