// Copyright 2015 IBM Corp. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import <IMFCore/IMFCore.h>
#import <IMFPush/IMFPush.h>
@interface AppDelegate ()
@property IMFLogger *logger;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    IMFClient *imfClient = [IMFClient sharedInstance];
    [imfClient initializeWithBackendRoute:@"https://testpushjaa.mybluemix.net" backendGUID:@"1cb0f3a3-ecde-4ef7-90a0-e983449e25b9"];
    
    //initialize push:
    [[UIApplication sharedApplication] registerUserNotificationSettings:
     [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert |UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    // get Push instance

    IMFPushClient* push = [IMFPushClient sharedInstance];
    // set current working environment

    
    [push registerDeviceToken:deviceToken completionHandler:^(IMFResponse *response, NSError *error) {
        
        IMFLogger *logger = [IMFLogger loggerForName:@"AppDelegate"];
        
        if (error){
            [logger logErrorWithMessages:@"error registering for push notifications: %@", error.description];
        } else {
            [logger logDebugWithMessages:@"registered for push notifications."];
        }
    }];   }
    -(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
        //userInfo dictionary will contain data sent from server.
        
        NSDictionary *notification = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        NSString *body = [notification objectForKey:@"body"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification Received"
        message:body delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
@end
