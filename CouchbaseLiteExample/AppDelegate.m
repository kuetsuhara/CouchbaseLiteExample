//
//  AppDelegate.m
//  CouchbaseLiteExample
//
//  Created by Kaz.U on 2014/05/02.
//  Copyright (c) 2014年 ssdkfk. All rights reserved.
//

#import "AppDelegate.h"
#import "CouchbaseLite/CouchbaseLite.h"
#import "CouchbaseLite/CBLDocument.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    BOOL result = [self databaseCreate];
    NSLog (@"This Hello Couchbase Lite run %@!", (result ? @"was a total success" : @"was a dismal failure"));
    
    // Override point for customization after application launch.
    return YES;
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


// creates a database, and then creates, stores, and retrieves a document
- (BOOL) databaseCreate {
    
    // holds error error messages from unsuccessful calls
    NSError *error;
    
    // create a shared instance of CBLManager
    CBLManager *manager = [CBLManager sharedInstance];
    if (!manager) {
        NSLog (@"Cannot create shared instance of CBLManager");
        return NO;
    }
    
    // データベース名の作成
    NSString *dbname = DATABASE_NAME;
    if (![CBLManager isValidDatabaseName: dbname]) {
        NSLog (@"Bad database name");
        return NO;
    }
    
    // データベースの作成
    CBLDatabase *database = [manager databaseNamed: dbname error: &error];
    if (!database) {
        NSLog (@"Cannot create database. Error message: %@", error.localizedDescription);
        return NO;
    }
    
    return YES;
    
}


@end
