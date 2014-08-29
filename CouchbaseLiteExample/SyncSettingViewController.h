//
//  SyncSettingViewController.h
//  CouchbaseLiteExample
//
//  Created by Kaz.U on 2014/05/07.
//  Copyright (c) 2014年 ssdkfk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyncSettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *IDTextField;
@property (weak, nonatomic) IBOutlet UITextField *PassTextField;

- (IBAction)doneButtonPushed:(id)sender;

@end
