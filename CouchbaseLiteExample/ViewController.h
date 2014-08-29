//
//  ViewController.h
//  CouchbaseLiteExample
//
//  Created by Kaz.U on 2014/05/02.
//  Copyright (c) 2014年 ssdkfk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *comments;

- (IBAction)ButtonPushd:(id)sender;
- (IBAction)syncButtonPushed:(id)sender;


@end
