//
//  SyncSettingViewController.m
//  CouchbaseLiteExample
//
//  Created by Kaz.U on 2014/05/07.
//  Copyright (c) 2014年 ssdkfk. All rights reserved.
//

#import "SyncSettingViewController.h"

@interface SyncSettingViewController () <UITextFieldDelegate>

@end

@implementation SyncSettingViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    self.IDTextField.delegate = self;
    self.PassTextField.delegate = self;
    
    
    self.IDTextField.text   = [def valueForKeyPath:@"syncID"];
    self.PassTextField.text = [def valueForKeyPath:@"syncPass"];
    
}


- (IBAction)doneButtonPushed:(id)sender {
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    [def setObject:_IDTextField.text forKey:@"syncID"];
    [def setObject:_PassTextField.text forKey:@"syncPass"];
    [def synchronize];
    
    NSURLCredential* cred;
    cred = [NSURLCredential
            credentialWithUser: _IDTextField.text
            password: _PassTextField.text
            persistence: NSURLCredentialPersistencePermanent];
    
    
    NSURLProtectionSpace* space;
    
    space = [[NSURLProtectionSpace alloc]
             initWithHost: @"ssdkfk.cloudant.com"
             port: 443
             protocol: @"https"
             realm: @"Cloudant Private Database"
             authenticationMethod: NSURLAuthenticationMethodDefault];
    
    // realmは「$ curl -i -X POST http://sync.example.com/dbname/」を叩いて確認する
    
    [[NSURLCredentialStorage sharedCredentialStorage]
     setDefaultCredential: cred
     forProtectionSpace: space];

    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
