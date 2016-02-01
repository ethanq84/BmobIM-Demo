//
//  ChatView.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/22.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobIMSDK/BmobIMSDK.h>

@interface ChatView : UIView

@property (strong, nonatomic) UIButton *avatarButton;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIButton *imageButton;

@property (strong, nonatomic) BmobIMMessage *msg;

-(void)setMessage:(BmobIMMessage *)msg user:(BmobIMUserInfo *)userInfo;

@end
