//
//  ChatView.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/22.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "ChatView.h"
#import "BmobIMDemoPCH.h"
#import <BmobSDK/Bmob.h>
#import "Masonry.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "AppManager.h"

@interface ChatView ()

@property (strong, nonatomic) UIImageView *avatarBackgroundImageView;

@property (strong, nonatomic) UIImageView *chatBackgroundImageView;

@property (strong, nonatomic) UIView *chatContentView;

@end


@implementation ChatView

-(UIImageView *)avatarBackgroundImageView{
    if (!_avatarBackgroundImageView) {
        _avatarBackgroundImageView = [[UIImageView alloc] init];
        
        [self addSubview:_avatarBackgroundImageView];
    }
    
    return _avatarBackgroundImageView;
}

-(UIView *)chatContentView{
    if (!_chatContentView) {
        _chatContentView = [[UIView alloc] init];
        [self addSubview:_chatContentView];
    }
    return _chatContentView;
}


-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [ UIFont systemFontOfSize:12];
        [_timeLabel.layer setCornerRadius:3];
        [_timeLabel.layer setMasksToBounds:YES];
        _timeLabel.backgroundColor = [UIColor colorWithR:227 g:228 b:232];
        [self addSubview:_timeLabel];
        _timeLabel.textColor = [UIColor colorWithR:136 g:136 b:136];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@140);
            make.top.equalTo(self.mas_top).with.offset(8);
            make.height.equalTo(@19);
        }];
    }
    return _timeLabel;
}

-(UIButton *)avatarButton{
    if (!_avatarButton) {
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_avatarButton];
        [_avatarButton.layer setMasksToBounds:YES];
        [_avatarButton.layer setCornerRadius:22];
    }
    
    return _avatarButton;
}


-(UIButton *)imageButton{
    if (!_imageButton) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_imageButton];
    }
    
    return _imageButton;
}


-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [self.chatContentView addSubview:_contentLabel];
        _contentLabel.preferredMaxLayoutWidth = kScreenWidth - 70 - 70;
    }
    return _contentLabel;
}


-(void)setMessage:(BmobIMMessage *)msg user:(BmobIMUserInfo *)userInfo{
    self.msg = msg;
    
    BmobUser *loginUser = [BmobUser getCurrentUser];
    if ([_msg.fromId isEqualToString:loginUser.objectId]) {
        [self layoutSubviewsWhenSelfMessage];
        [self.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[loginUser objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head"]];
    }else{
        [self layoutSubviewsWhenOtherMessage];
        [self.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:userInfo.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head"]];
    }
    switch (msg.msgType) {
        case BmobIMMessageTypeText:{
            self.contentLabel.text = self.msg.content;
        }
            break;
            
        default:
            break;
    }
    self.avatarBackgroundImageView.image = [UIImage imageNamed:@"head_bg"];
    self.timeLabel.text = [[AppManager defaultManager].dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.msg.updatedTime / 1000.0f] ];
    
}

-(void)setMsg:(BmobIMMessage *)msg{
    _msg = msg;
    
}

-(UIImageView *)chatBackgroundImageView{
    if (!_chatBackgroundImageView) {
        _chatBackgroundImageView = [[UIImageView alloc] init];
        [self.chatContentView addSubview:_chatBackgroundImageView];
        
    }
    return _chatBackgroundImageView;
}

-(void)layoutSubviewsWhenOtherMessage{
    
    [self.avatarBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.height.equalTo(@48);
        make.width.equalTo(@48);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(10);
    }];
    
    [self.avatarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.avatarBackgroundImageView);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];
    //[[UIImage imageNamed:@"bg_chat_left_nor"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 8, 17)]
    self.chatBackgroundImageView.image = [UIImage imageNamed:@"bg_chat_left_nor"] ;
    if (self.msg.msgType == BmobIMMessageTypeImage) {
        
    }else if(self.msg.msgType == BmobIMMessageTypeText){
    
        [self.chatContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarBackgroundImageView.mas_right).with.offset(8);
            make.top.equalTo(self.avatarBackgroundImageView);
//            make.bottom.equalTo(self.mas_bottom).with.offset(10);
            make.width.lessThanOrEqualTo(@(kScreenWidth - 70));
            make.height.equalTo(self.contentLabel.mas_height).with.offset(16);
            make.bottom.equalTo(self.mas_bottom).with.offset(-8).with.priorityMedium();
        }];
        [self.chatBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.chatContentView).insets(UIEdgeInsetsMake(0, 0, 10, 0));
        }];

        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            //make.edges.equalTo(self.chatContentView).insets(UIEdgeInsetsMake(8, 24, 18, 24));
            make.centerY.equalTo(self.chatBackgroundImageView.mas_centerY);
            make.left.equalTo(self.chatContentView.mas_left).with.offset(20);
            make.right.equalTo(self.chatContentView.mas_right).with.offset(-8);
        }];
    }
    self.contentLabel.textColor = [UIColor colorWithR:47 g:39 b:37];
}

-(void)layoutSubviewsWhenSelfMessage{
    [self.avatarBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@48);
        make.width.equalTo(@48);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(10);
    }];
    
    [self.avatarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.avatarBackgroundImageView);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];
    self.chatBackgroundImageView.image = [UIImage imageNamed:@"bg_chat_right_nor"];
    if (self.msg.msgType == BmobIMMessageTypeImage) {
        
    }else if(self.msg.msgType == BmobIMMessageTypeText){
        
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//                        make.edges.equalTo(self.chatContentView).insets(UIEdgeInsetsMake(8, 24, 18, 24));
            make.centerY.equalTo(self.chatBackgroundImageView.mas_centerY);
            make.left.equalTo(self.chatContentView.mas_left).with.offset(8);
            make.right.equalTo(self.chatContentView.mas_right).with.offset(-20);
        }];
        
        [self.chatContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.avatarBackgroundImageView.mas_left).with.offset(-8);
            make.top.equalTo(self.avatarBackgroundImageView);
            make.width.lessThanOrEqualTo(@(kScreenWidth - 70));
            make.height.equalTo(self.contentLabel.mas_height).with.offset(16);
            make.bottom.equalTo(self.mas_bottom).with.offset(-8).with.priorityMedium();
        }];
        [self.chatBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.chatContentView).insets(UIEdgeInsetsMake(0, 0, 10, 0));
        }];

    }
    self.contentLabel.textColor = [UIColor whiteColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
