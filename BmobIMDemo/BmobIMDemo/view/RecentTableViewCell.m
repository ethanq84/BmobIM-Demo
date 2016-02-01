//
//  RecentTableViewCell.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/29.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "RecentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation RecentTableViewCell

//-(instancetype)init{
//
//}

- (void)awakeFromNib {
    // Initialization code
    [self.avatarImageView.layer setMasksToBounds:YES];
    [self.avatarImageView.layer setCornerRadius:25];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setEntity:(BmobIMConversation *)entity{
    _entity = entity;
    self.titleLabel.text = entity.conversationTitle;
    self.contentLabel.text = entity.conversationDetail;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:entity.conversationIcon] placeholderImage:[UIImage imageNamed:@"head"]];
    
}

@end
