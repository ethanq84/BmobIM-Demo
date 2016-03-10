//
//  ImageChatView.m
//  BmobIMDemo
//
//  Created by Bmob on 16/3/2.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "ImageChatView.h"
#import "BmobIMDemoPCH.h"


@implementation ImageChatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIButton *)imageButton{
    if (!_imageButton) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.chatContentView addSubview:_imageButton];
    }
    
    return _imageButton;
}


-(void)setMessage:(BmobIMMessage *)msg user:(BmobIMUserInfo *)userInfo{
    [super setMessage:msg user:userInfo];
 
}

-(void)layoutViewsSelf{
    [super layoutViewsSelf];
    self.imageButton.hidden = NO;
    
    BmobIMImageMessage *imgMsg = (BmobIMImageMessage *)self.msg;
    
    [self.imageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chatBackgroundImageView );
        make.left.equalTo(self.chatBackgroundImageView.mas_left ).with.offset(6);
        if (imgMsg.width > 150) {
            make.width.equalTo(@(150));
            make.height.equalTo(@(150* imgMsg.height/imgMsg.width ));
        }else{
            make.width.equalTo(@(imgMsg.width));
            make.height.equalTo(@(imgMsg.height));
        }
    }];
    
    [self.chatContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.avatarBackgroundImageView.mas_left).with.offset(-8);
        make.top.equalTo(self.avatarBackgroundImageView);
        make.width.equalTo(self.imageButton.mas_width).with.offset(20);
        make.height.equalTo(self.imageButton.mas_height).with.offset(20);
        make.bottom.equalTo(self.mas_bottom).with.offset(-8).with.priorityMedium();
    }];
    [self.chatBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.chatContentView).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
   
    [self.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[[self.msg.content componentsSeparatedByString:@"&"] lastObject]]  forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (imgMsg.width == 0.0f || imgMsg.height == 0.0f) {
            [self.imageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.chatBackgroundImageView );
                make.right.equalTo(self.chatBackgroundImageView.mas_right ).with.offset(-6);
                if (image.size.width > 150) {
                    make.width.equalTo(@(150));
                    make.height.equalTo(@(150* image.size.height/image.size.width));
                }else{
                    make.width.equalTo(@(image.size.width));
                    make.height.equalTo(@(image.size.height));
                }
                
            }];
        }
    }];
}


-(void)layoutViewsOther{
    [super layoutViewsOther];
    self.imageButton.hidden = NO;
    
    BmobIMImageMessage *imgMsg = (BmobIMImageMessage *)self.msg;
    [self.imageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chatBackgroundImageView );
        make.right.equalTo(self.chatBackgroundImageView.mas_right ).with.offset(-6);
        if (imgMsg.width > 150) {
            make.width.equalTo(@(150));
            make.height.equalTo(@(150* imgMsg.height/imgMsg.width));
        }else{
            make.width.equalTo(@(imgMsg.width));
            make.height.equalTo(@(imgMsg.height));
        }
        
    }];
    
    [self.chatContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarBackgroundImageView.mas_right).with.offset(8);
        make.top.equalTo(self.avatarBackgroundImageView);
        make.width.equalTo(self.imageButton.mas_width).with.offset(20);
        make.height.equalTo(self.imageButton.mas_height).with.offset(20);
        make.bottom.equalTo(self.mas_bottom).with.offset(8).with.priorityMedium();
    }];
    
    [self.chatBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.chatContentView).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    [self.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.msg.content] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self.imageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.chatBackgroundImageView );
            make.right.equalTo(self.chatBackgroundImageView.mas_right ).with.offset(-6);
            if (image.size.width > 150) {
                make.width.equalTo(@(150));
                make.height.equalTo(@(150* image.size.height/image.size.width));
            }else{
                make.width.equalTo(@(image.size.width));
                make.height.equalTo(@(image.size.height));
            }
            
        }];
    }];
}

@end
