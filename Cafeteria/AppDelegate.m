//
//  AppDelegate.m
//  Cafeteria
//
//  Created by chensen on 14/11/3.
//  Copyright (c) 2014年 Choicesoft. All rights reserved.
//

#import "AppDelegate.h"
#import "CSLoginViewController.h"
#import "CSHomePageAdViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self copyFiles];
    if (!languageMode) {
        [[NSUserDefaults standardUserDefaults] setObject:@"cn" forKey:@"language"];
    }
    CSHomePageAdViewController *order=[[CSHomePageAdViewController alloc] init];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:order];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark - 将文件拷贝到沙河
- (void)copyFiles{
    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [[docPaths objectAtIndex:0] stringByAppendingPathComponent:@"booksystem"];


//stringByAppendingPathComponent:@"songzi"];
    
//	NSString *docPath = [NSString stringWithFormat:@"%@/BookSystem/",[docPaths objectAtIndex:0]];
    NSLog(@"%@",docPath);
    [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    
//    NSString *sqlpath = [docPath stringByAppendingPathComponent:@"BookSystem.plist"];
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
//    if (![fileManager fileExistsAtPath:sqlpath]){
        NSArray *ary = [NSBundle pathsForResourcesOfType:@"jpg" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"JPG" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"png" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"PNG" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"plist" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        ary = [NSBundle pathsForResourcesOfType:@"sqlite" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
//    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
