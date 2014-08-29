//
//  ViewController.m
//  CouchbaseLiteExample
//
//  Created by Kaz.U on 2014/05/02.
//  Copyright (c) 2014年 ssdkfk. All rights reserved.
//

#import "ViewController.h"
#import "Comment.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *dataArray;
    
    CBLReplication *pull;
    CBLReplication *push;

}


@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self replicationSetting];
    
    dataArray = [NSMutableArray new];
    
    [self allRead];
    [_comments reloadData];
}


- (IBAction)ButtonPushd:(id)sender
{
    
    if ([_textField.text length]) {
        
        // モデルに情報を追加
        Comment *c = [[Comment alloc] initWithNewDocumentInDatabase:[self database]];
        
        c.comment = _textField.text;
        c.createdAt = [NSDate date];
        c.check = YES;
        
        NSError *err;
        if (![c save:&err]) {
            NSLog(@"SaveError! %@",err);
        }
        else{
            NSLog(@"Save Success!");
        }
        
        
        // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
        
        // 入力コメント削除
        self.textField.text = @"";
        
        [self allRead];
        
        [_comments reloadData];

    }
    
    [_textField resignFirstResponder];
    
}

- (IBAction)syncButtonPushed:(id)sender {
    [push start];
    [pull start];
}




#pragma mark - TableView Delegate/Datasource
/****************************************************************************
 * TableView Delegate/Datasouceメソッド郡
 ****************************************************************************/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行の高さ
    return 56;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // セクション数
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // セクション内のRow数
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // TableViewに表示
    Comment *c = [dataArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = c.comment;
    cell.detailTextLabel.text = [c.createdAt description];
    
    if (c.check)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell...
    
    return cell;
}


- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{

    // ここに、Checkの更新を実装しましょう ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    Comment *c = [dataArray objectAtIndex:indexPath.row];
    c.check = !c.check;
    [c save:nil];
    
    [self allRead];
    [_comments reloadData];

    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
}


#pragma mark - TableView Editing

/****************************************************************************
 * TableView の編集
 ****************************************************************************/

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (void)tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // ここにDeleteを実装しましょう ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
        Comment *c = [dataArray objectAtIndex:indexPath.row];
        [c deleteDocument:nil];
        
        // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
        
        [dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        
    }
}


#pragma mark - TextField Delegate

/****************************************************************************
 * TextField Delegate
 ****************************************************************************/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




#pragma mark - Couchbase Lite
/****************************************************************************
 * CouchbaseLite各種メソッド郡
 ****************************************************************************/


- (BOOL)saveModel:(CBLModel *)model{
    NSError *saveError;
    if (![model save: &saveError]) {
        NSLog(@" save error %@", saveError);
        return NO;
    }
    return YES;
}



- (void)allRead
{
    
    [dataArray removeAllObjects];
    
    CBLDatabase *database = [self database];
    
    // All Query
    
    // ここにRead(全部取得)を実装しましょう ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    CBLQuery* query = [database createAllDocumentsQuery];
    
    NSError *error;
    CBLQueryEnumerator *rowEnum = [query run: &error];
    for (CBLQueryRow* row in rowEnum) {
        NSLog(@"Doc ID = %@", row.key);
        
        CBLDocument *doc  = [database documentWithID:row.key];
        NSLog(@"%@",doc.properties);

        Comment *c = [Comment modelForDocument:doc];
        [dataArray addObject:c];
        
        
    }
    
    
    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    
}

/*
- (void)dateRead
{
    [dataArray removeAllObjects];
    
    CBLDatabase *database = [self database];
    
    // All Query
    
    CBLQuery *allQuery = [[database viewNamed:@"byDate"] createQuery];
    allQuery.descending = YES;
    
    NSError *allError;
    CBLQueryEnumerator *rowEnum = [allQuery run: &allError];
    
    for (CBLQueryRow* row in rowEnum) {
        NSLog(@"Doc ID = %@", row.key);
        NSLog(@"Value  = %@", row.value);
        CBLDocument *cDoc = [database documentWithID:row.key];
        
        Comment *c = [Comment modelForDocument:cDoc];
        
        [dataArray addObject:c];
        NSLog(@"%@",cDoc.properties);
    }
}

*/

/*
- (void)createView
{
    
    CBLDatabase* database = [self database];
    CBLView* view = [database viewNamed: @"byDate"];
    
    [view setMapBlock: MAPBLOCK({
        id date = [doc objectForKey: @"createdAt"];
        if (date) emit(date, doc);
    }) version: @"1.0"];
    
}
 */




// レプリケーション設定
- (void)replicationSetting
{
    
    CBLDatabase* database = [self database];
    
    pull = [database createPullReplication:[NSURL URLWithString:@"https://ssdkfk.cloudant.com/example/"]];
    push = [database createPushReplication:[NSURL URLWithString:@"https://ssdkfk.cloudant.com/example/"]];
    
    pull.continuous = push.continuous = YES;
    
    // レプリケーションの状態監視
    NSNotificationCenter* nctr = [NSNotificationCenter defaultCenter];
    [nctr addObserver: self selector: @selector(replicationProgress:)
                 name: kCBLReplicationChangeNotification object: pull];
    [nctr addObserver: self selector: @selector(replicationProgress:)
                 name: kCBLReplicationChangeNotification object: push];


    
    
}

- (void) replicationProgress: (NSNotificationCenter*)n
{
    if (pull.status == kCBLReplicationActive || push.status == kCBLReplicationActive) {
        
        unsigned completed = pull.completedChangesCount +push.completedChangesCount;
        unsigned total = pull.changesCount+ push.changesCount;
        
        NSLog(@"SYNC progress: %u / %u", completed, total);
    } else {
        NSLog(@"Finish");
        [self allRead];
        [_comments reloadData];
    }
    
}


- (CBLDatabase *)database{
    
    // データベースの呼び出し
    CBLManager *manager = [CBLManager sharedInstance];
    NSError *error;
    CBLDatabase* database = [manager databaseNamed: DATABASE_NAME
                                             error: &error];
    
    return database;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
