//
//  SMTabBar.m
//  SMSplitViewController
//
//  Created by Sergey Marchukov on 15.02.14.
//  Copyright (c) 2014 Sergey Marchukov. All rights reserved.
//
//  This content is released under the ( http://opensource.org/licenses/MIT ) MIT License.
//

#import "SMTabBarV.h"
//#import "SMTabBarItemV.h"
#import "SMTabBarItemCellV.h"
#import "CSNetWork.h"
#import "CSDataProvider.h"
#import "SVProgressHUD.h"




@interface SMTabBarV ()

@property (nonatomic, strong) UITableView *tabsTable;
@property (nonatomic, strong) UITableView *actionsTable;

@end

@implementation SMTabBarV
{
    __block CGFloat _tabsButtonsHeight;
    __block CGFloat _actionsButtonsHeight;
    NSIndexPath *_selectedTab;
}

#pragma mark -
#pragma mark - Initialization

- (id)init {
    
    self = [super init];
    
    if (self) {
//        self.backgroundColor=[UIColor lightGrayColor];
        self.clipsToBounds = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangFrame) name:@"changeFrame" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectRow:) name:@"SelectRow" object:nil];
    }
    
    return self;
}

- (void)tabsInit:(NSArray *)tabs {
    
    if (tabs) {
        
        NSMutableArray *tmpItems = [NSMutableArray array];
        
        [tabs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
            if ([obj isKindOfClass:[SMTabBarItem class]]) {
                
                _tabsButtonsHeight += tabItemHeight;
                [tmpItems addObject:obj];
            }
        }];
    
        _tabsButtons = [NSArray arrayWithArray:tmpItems];
        
        _tabsTable = [[UITableView alloc] initWithFrame:tabsButtonsFrame style:UITableViewStylePlain];
        _tabsTable.scrollEnabled = NO;
        _tabsTable.dataSource = self;
        _tabsTable.delegate = self;
        _tabsTable.backgroundColor=[UIColor redColor];
        _tabsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabsTable.backgroundColor = [UIColor blackColor];
        _tabsTable.tableFooterView = [[UIView alloc] init];
        
        if (_tabsButtons.count > 0) {
            NSIndexPath *firstTab = [NSIndexPath indexPathForRow:0 inSection:0];
            _selectedTabIndex = [firstTab row];
            [_tabsTable selectRowAtIndexPath:firstTab animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:_tabsTable didSelectRowAtIndexPath:firstTab];
        }
        [self addSubview:_tabsTable];
    }
}
#pragma mark - 跳转通知
-(void)selectRow:(NSNotification *)notification
{
    NSInteger i = [[notification object] intValue];
    NSIndexPath *firstTab = [NSIndexPath indexPathForRow:i inSection:0];
    
    _selectedTabIndex = [firstTab row];
    if (i==2) {
        bs_dispatch_sync_on_main_thread(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCQueryOrder" object:nil];
        });
    }
    [_tabsTable selectRowAtIndexPath:firstTab animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:_tabsTable didSelectRowAtIndexPath:firstTab];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)actionsInit:(NSArray *)actions {
    
    if (actions) {
        
        NSMutableArray *tmpItems = [NSMutableArray array];
        
        [actions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if ([obj isKindOfClass:[SMTabBarItem class]]) {
            
                _actionsButtonsHeight += tabItemHeight;
                [tmpItems addObject:obj];
            }
        }];
        
        _actionsButtons = [NSArray arrayWithArray:tmpItems];
        
        _actionsTable = [[UITableView alloc] initWithFrame:actionButtonFrame style:UITableViewStylePlain];
        _actionsTable.scrollEnabled = NO;
        _actionsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _actionsTable.delegate = self;
        _actionsTable.dataSource = self;
        
        _actionsTable.backgroundColor = [UIColor blackColor];
        _actionsTable.tableFooterView = [[UIView alloc] init];
        [self addSubview:_actionsTable];
    }
}
#pragma mark -
#pragma mark - ViewController Lifecycle

- (void)ChangFrame
{
    
//    [super viewWillLayoutSubviews];
    self.frame = CGRectFromString([[[CSDataProvider CSDataProviderShare].config objectForKey:@"MainView"] objectForKey:@"TabBarViewFrame"]);
    
    if (_tabsTable) {
        
        _tabsTable.frame = tabsButtonsFrame;
    }
    
    if (_actionsTable) {
        
        _actionsTable.frame = actionButtonFrame;
//        _actionsTable.backgroundColor=[UIColor lightGrayColor];
    }
}


#pragma mark -
#pragma mark - Properties

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    
    _backgroundImage = backgroundImage;
    CGRect frame = CGRectMake(0, 20 * iOS_7, self.bounds.size.width, self.bounds.size.height);
    UIGraphicsBeginImageContext(self.frame.size);
    [backgroundImage drawInRect:frame];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (UIImage *)background {
    
    return _backgroundImage;
}

- (void)setTabsButtons:(NSArray *)tabsButtons {
    
    [self tabsInit:tabsButtons];
}

-(void)setActionsButtons:(NSArray *)actionsButtons {
 
    [self actionsInit:actionsButtons];
}

#pragma mark -
#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView == _tabsTable ? _tabsButtons.count : _actionsButtons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tabItemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMTabBarItemCellV *cell = [[SMTabBarItemCellV alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    SMTabBarItem *tabItem = nil;
    
    if (tableView == _tabsTable) {
        
        tabItem = [_tabsButtons objectAtIndex:indexPath.row];
//        cell.viewController = tabItem.viewController;
        cell.cellType = SMTabBarItemCellVTab;
        cell.isFirstCell = indexPath.row == 0;
//        cell.selectedColor = tabItem.viewController.view.backgroundColor;
    }
    else if (tableView == _actionsTable) {
        tabItem = [_actionsButtons objectAtIndex:indexPath.row];
        cell.actionBlock = tabItem.actionBlock;
        cell.cellType = SMTabBarItemCellVAction;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.iconView.image = tabItem.image;
    cell.selectedImage = tabItem.selectedImage;
    cell.image = tabItem.image;
    cell.titleLabel.text = tabItem.title;
    
    return cell;
}

#pragma  mark - 导航按钮的选择事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tabsTable) {
        if (![_selectedTab isEqual:indexPath]) {
            _selectedTab = indexPath.copy;
            _selectedTabIndex = [indexPath row];
            [_delegate tabBar:indexPath.row];
        }
    }
    else {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [_tabsTable selectRowAtIndexPath:_selectedTab animated:NO scrollPosition:UITableViewScrollPositionNone];
        SMTabBarItemCellV *selectedCell = (SMTabBarItemCellV *)[tableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.actionBlock)
            selectedCell.actionBlock();
    }
}
#pragma mark - 将要选择事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    //根据 NSIndexPath判定行是否可选。
    if ([[CSDataProvider CSDataProviderShare].PackageItem count]>0||(![[[CSDataProvider CSDataProviderShare].foodsArray lastObject] objectForKey:@"combo"]&&[[[[CSDataProvider CSDataProviderShare].foodsArray lastObject] objectForKey:@"ISTC"] intValue] ==1)) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请选择完该套餐再进行该操作" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return nil;
    }
    else
    {
        if (_tabsTable==tv) {
            
            if (path.row==2) {
//                NSDictionary *dict=[[CSNetWork shareCSNetWork] ChineseFoodQueryOrder:@"2"];
                bs_dispatch_sync_on_main_thread(^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCQueryOrder" object:nil];
                });
                
                    /**
                     *  判断菜品数量是否大于0
                     */
                NSLog(@"%@",[CSDataProvider CSDataProviderShare].foodQueryArray);
                    if ([CSDataProvider CSDataProviderShare].foodQueryArray&&[[CSDataProvider CSDataProviderShare].foodQueryArray count]>0) {
                        return path;
                    }else
                    {
                        if ([[CSDataProvider CSDataProviderShare].foodsArray count]>0) {
                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"你是否要发送选择的菜品" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                            alert.tag=100;
                            [alert show];
                            return nil;
                        }else
                        {
                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请点完菜品后进行该操作" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alert show];
                            return nil;
                        }

                    }
            }
        }
    }
    return path;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [SVProgressHUD showProgress:-1 status:[CSDataProvider localizedString:@"Load"] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(ZCsendFood) toTarget:self withObject:nil];
//        NSString *weatherUrl1=[NSString stringWithFormat:@"%@orderFood?data=%@",[CSDataProvider ZCCafeteriaWebServiceIP],[[CSDataProvider CSDataProviderShare] ZCCafeteriaSendFoodString]];
//        NSLog(@"%@",weatherUrl1);
//        NSURLRequest* request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:[weatherUrl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//        AFHTTPRequestOperation* operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
//        //设置下载完成调用的block
//        [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSDictionary *dicInfo1 = [NSDictionary dictionaryWithXMLData:operation.responseData];
//            [SVProgressHUD dismiss];
//            //        NSDictionary *dict=[dicInfo1 objectForKey:@"ns:return"];
//            NSData *jsonData = [[dicInfo1 objectForKey:@"ns:return"] dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary *dic = [[NSJSONSerialization JSONObjectWithData:jsonData
//                                                                 options:NSJSONReadingMutableContainers
//                                                                   error:&err] objectForKey:@"result"];
//            if(err) {
//                NSLog(@"json解析失败：%@",err);
//            }else
//            {
//                if ([[dic objectForKey:@"state"] intValue]==1) {
//                    [CSDataProvider CSDataProviderShare].foodsArray=nil;
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCQueryOrder" object:nil];
//                    [SVProgressHUD showSuccessWithStatus:[dic objectForKey:@"msg"]];
//                    NSIndexPath *firstTab = [NSIndexPath indexPathForRow:2 inSection:0];
//                    _selectedTabIndex = [firstTab row];
//                    [_tabsTable selectRowAtIndexPath:firstTab animated:YES scrollPosition:UITableViewScrollPositionNone];
//                    [self tableView:_tabsTable didSelectRowAtIndexPath:firstTab];
//                }else
//                {
//                    [SVProgressHUD showSuccessWithStatus:[dic objectForKey:@"msg"]];
//                }
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [SVProgressHUD showErrorWithStatus:@"网络连接超时"];
//        }];
//        [operation1 start];
    }
}
-(void)ZCsendFood
{
    NSDictionary *dict=[[CSDataProvider CSDataProviderShare] ZCSend];
    [SVProgressHUD dismiss];
    if (!dict) {
        [SVProgressHUD showErrorWithStatus:[CSDataProvider localizedString:@"ConnectionTimeout"]];
        return;
    }
        if ([[dict objectForKey:@"state"] intValue]==1) {
            if ([[dict objectForKey:@"state"] intValue]==1) {
                [CSDataProvider CSDataProviderShare].foodsArray=nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCQueryOrder" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"msg"]];
                NSIndexPath *firstTab = [NSIndexPath indexPathForRow:2 inSection:0];
                _selectedTabIndex = [firstTab row];
                [_tabsTable selectRowAtIndexPath:firstTab animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self tableView:_tabsTable didSelectRowAtIndexPath:firstTab];
                
            }else
            {
                [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"msg"]];
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
        }
    
}
#pragma mark -
#pragma mark - Autototate iOS 6.0 +

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

@end
