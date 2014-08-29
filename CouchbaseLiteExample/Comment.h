//
//  Comment.h
//  CouchbaseLiteExample
//
//  Created by Kaz.U on 2014/05/07.
//  Copyright (c) 2014年 ssdkfk. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

@interface Comment : CBLModel

@property (copy) NSString *comment; // テキストフィールドの値
@property (strong) NSDate *createdAt; // 今の日付
@property BOOL check; // YES

@end
