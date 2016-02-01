//
//  ChatBottomControlView.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/21.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "ChatBottomControlView.h"

@implementation ChatBottomControlView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ChatBottomControlView" owner:self options:nil] firstObject];
        [self addSubview:view];
        
        
        [self.typeButton setImage:[UIImage imageNamed:@"chat_icon1"] forState:UIControlStateNormal];
        [self.typeButton setImage:[UIImage imageNamed:@"chat_icon1_"] forState:UIControlStateHighlighted ];
        
        [self.emojiButton setImage:[UIImage imageNamed:@"chat_icon2"] forState:UIControlStateNormal];
        [self.emojiButton setImage:[UIImage imageNamed:@"chat_icon2_"] forState:UIControlStateHighlighted];
        
        [self.talkButton setImage:[UIImage imageNamed:@"chat_icon3"] forState:UIControlStateNormal];
        [self.talkButton setImage:[UIImage  imageNamed:@"chat_icon3_"] forState:UIControlStateHighlighted];
    }
    return self;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
