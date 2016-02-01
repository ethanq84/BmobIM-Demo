//
//  ChatViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/21.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ChatBottomControlView.h"
#import "BmobIMDemoPCH.h"
#import <BmobSDK/Bmob.h>
#import "BmobIMDemoPCH.h"


@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet ChatBottomControlView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint    *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView           *tableView;

@property (strong, nonatomic) NSMutableArray     *messagesArray;
@property (strong, nonatomic) BmobIM             *sharedIM;
@property (strong, nonatomic) BmobUser           *loginUser;
@property (strong, nonatomic) UIRefreshControl   *freshControl;
@property (assign, nonatomic) NSUInteger         page;
@property (assign, nonatomic) BOOL               finished;

@property (strong, nonatomic) BmobIMUserInfo *userInfo;

@end

@implementation ChatViewController

static NSString *cellID = @"ChatCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
    _messagesArray = [[NSMutableArray alloc] init];

    self.loginUser = [BmobUser getCurrentUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bottomViewFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBottomView) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:kNewMessagesNotifacation object:nil];
    self.page = 0;
    
    [self loadMessageRecords];
    
    _freshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.freshControl];
    [self.freshControl addTarget:self action:@selector(loadMoreRecords) forControlEvents:UIControlEventValueChanged];
    
    
    
    self.userInfo = [self.sharedIM userInfoWithUserId:self.conversation.conversationId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupSubviews{
    [self setDefaultLeftBarButtonItem];
    [self setupRightBarButtonItem];
    self.navigationItem.title = self.conversation.conversationTitle;
    self.bottomView.textField.delegate = self;
    self.view.backgroundColor = kDefaultViewBackgroundColor;
    self.tableView.backgroundColor = kDefaultViewBackgroundColor;
}


-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

-(void)setupRightBarButtonItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 44);
    [button setTitle:@"清空消息" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clearCache) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:13]];
}

-(void)clearCache{
    [self.conversation deleteMessageWithdeleteMessageListOrNot:NO updateTime:[[NSDate date] timeIntervalSince1970] * 1000];
    [self.messagesArray removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - load messages

-(void)loadMessageRecords{
    
    
    NSArray *array = [self.conversation queryMessagesWithMessage:nil limit:10];
    
    
    if (array && array.count > 0) {
        NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(BmobIMMessage *obj1, BmobIMMessage *obj2) {
            if (obj1.updatedTime > obj2.updatedTime) {
                return NSOrderedDescending;
            }else if(obj1.updatedTime <  obj2.updatedTime) {
                return NSOrderedAscending;
            }else{
                return NSOrderedSame;
            }
            
        }];
        [self.messagesArray setArray:result];
        [self.tableView reloadData];
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)loadMoreRecords{
    if (!self.finished) {
        self.page ++;
        [self.freshControl beginRefreshing];
        
        if (self.messagesArray.count <= 0) {
            [self.freshControl endRefreshing];
            return;
        }
        BmobIMMessage *msg = [self.messagesArray firstObject];
        
        NSArray *array = [self.conversation queryMessagesWithMessage:msg limit:10];
        
        if (array && array.count > 0) {
            NSMutableArray *messages = [NSMutableArray arrayWithArray:self.messagesArray];
            [messages addObjectsFromArray:array];
            NSArray *result = [messages sortedArrayUsingComparator:^NSComparisonResult(BmobIMMessage *obj1, BmobIMMessage *obj2) {
                if (obj1.updatedTime > obj2.updatedTime) {
                    return NSOrderedDescending;
                }else if(obj1.updatedTime <  obj2.updatedTime) {
                    return NSOrderedAscending;
                }else{
                    return NSOrderedSame;
                }
                
            }];
            [self.messagesArray setArray:result];
            [self.tableView reloadData];
        }else{
            self.finished = YES;
            [self showInfomation:@"没有更多的历史消息"];
        }
        
    }else{
        [self showInfomation:@"没有更多的历史消息"];
    }
    
    [self.freshControl endRefreshing];
}

-(void)goback{
    
    //更新缓存
    [self.conversation updateLocalCache];
    
    [super goback];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)receiveMessage:(NSNotification *)noti{
    BmobIMMessage *message = noti.object;
    if ([message.fromId isEqualToString:self.conversation.conversationId]) {
        [self.messagesArray addObject:message];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

#pragma mark - bottom view

-(void)bottomViewFrameChange:(NSNotification *)noti{
    NSValue *aValue = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    CGFloat height = keyboardSize.height;
    self.bottomConstraint.constant = height;
    [UIView animateWithDuration:0.3f animations:^{
        [self.bottomView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view updateConstraints];
            if (self.messagesArray.count > 0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
        }
        
    }];
}

-(void)hideBottomView{
    self.bottomConstraint.constant = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        [self.bottomView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view updateConstraints];
    }];
}

#pragma mark - UITableView Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    CGFloat height = [tableView fd_heightForCellWithIdentifier:cellID  configuration:^(ChatTableViewCell *cell) {
        BmobIMMessage *msg = self.messagesArray[indexPath.row];
        if ([self.loginUser.objectId isEqualToString:msg.fromId]) {
            [cell setMsg:msg userInfo:nil] ;
        }else{
            [cell setMsg:msg userInfo:self.userInfo] ;
        }
        
    }];
    if (height < 85) {
        height = 85;
    }
    return height;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BmobIMMessage *msg = self.messagesArray[indexPath.row];
    
    if ([self.loginUser.objectId isEqualToString:msg.fromId]) {
        [cell setMsg:msg userInfo:nil] ;
    }else{
        [cell setMsg:msg userInfo:self.userInfo] ;
    }
    
    
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bottomConstraint.constant != 0.0f) {
        [self.view endEditing:YES];
    }
}


#pragma mark - textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendTextWithTextField:textField];
    return YES;

}




#pragma mark - message

-(void)sendTextWithTextField:(UITextField *)textField{
    if (textField.text.length == 0) {
        [self showInfomation:@"请输入内容"];
    }else{
        
        BmobIMTextMessage *message = [BmobIMTextMessage messageWithText:textField.text attributes:nil];
        message.conversationType =  BmobIMConversationTypeSingle;
        message.createdTime = (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
        message.updatedTime = message.createdTime;
        [self.messagesArray addObject:message];
        [self.tableView reloadData];
        self.bottomView.textField.text = nil;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        __weak typeof(self)weakSelf = self;
        [self.conversation sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        }];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
