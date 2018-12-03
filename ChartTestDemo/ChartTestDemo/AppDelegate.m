//
//  AppDelegate.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/5/8.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "AppDelegate.h"
#import <PushKit/PushKit.h>
#import <UserNotifications/UserNotifications.h>
#import "VoicePlayingManager.h"
@interface AppDelegate ()<PKPushRegistryDelegate>{
   
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initPushKit];
    return YES;
}

- (void)initPushKit{
    
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    UIUserNotificationSettings *userNotifySetting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:userNotifySetting];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)pushCredentials forType:(PKPushType)type {
    
    if([pushCredentials.token length] == 0){
        NSLog(@"voip token NULL");
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"%@",pushCredentials.token];
    NSString *tokenStr = [[[str stringByReplacingOccurrencesOfString:@"<" withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"________-token: %@",tokenStr);
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type{
    
    UIUserNotificationType theType = [UIApplication sharedApplication].currentUserNotificationSettings.types;
    
    if (theType == UIUserNotificationTypeNone)
    {
        UIUserNotificationSettings *userNotifySetting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:userNotifySetting];
    }
    
    NSDictionary * dic = payload.dictionaryPayload;
    
    NSLog(@"dic  %@",dic);
    
    NSDictionary *pushDic = @{@"aps":@{@"sound":@"cash_success.m4a",@"alert":@"实收0.01元，订单金额19999.01元",@"category":@"iOS category",@"content-available":@"1",@"mutable-content":@"1"},@"data":@{@"pay_type":@"1",@"order_type":@"1",@"sum_amount":@"19999.01"},@"type":@"3"};
    VoicePlayingManager *voicePlayingManager = [VoicePlayingManager sharedVoicePlayingManager];
    [voicePlayingManager getNotificationServiceUserInfo:pushDic finshBlock:^(NSString * _Nonnull finishStr) {
        NSLog(@"播放完成");
    }];
}


@end



