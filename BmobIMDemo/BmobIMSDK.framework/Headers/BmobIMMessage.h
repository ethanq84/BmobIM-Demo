//
//  BIMMessage.h
//  BmobIMSDK
//
//  Created by Bmob on 16/1/12.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "BmobIMConfig.h"




@interface BmobIMMessage : NSObject

/**
 *  消息来源者
 */
@property (copy, nonatomic  ) NSString                    *fromId;

/**
 *  消息接收者
 */
@property (copy, nonatomic  ) NSString                    *toId;

/**
 *  消息内容
 */
@property (copy, nonatomic  ) NSString                    *content;


/**
 *  消息类型
 */
@property (assign, nonatomic) BmobIMMessageType           msgType;

/**
 *  是否已读
 */
@property (assign, nonatomic) BmobIMReceivedStatus        receiveStatus;

/**
 *  消息的状态，是否已发送等
 */
@property (assign, nonatomic) BmobIMSendStatus            sendStatus;

/**
 *  消息是单聊还是群聊
 */
@property (assign, nonatomic) BmobIMConversationType      conversationType;


/**
 *   精确到毫秒
 */
@property (assign, nonatomic) uint64_t                        createdTime;


/**
 *   精确到毫秒
 */
@property (assign, nonatomic) uint64_t                        updatedTime;


/**
 *  会话Id
 */
@property (strong, nonatomic) NSString                    *conversationId;

/**
 *  传递额外的信息
 */
@property (strong, nonatomic) NSDictionary                *extra;

/**
 *  将接收到的json转成message
 *
 *  @param dic      接收到的json格式信息
 *  @param belongId 当前用户的id
 *
 *  @return BmobIMMessage实例
 */
+(instancetype)messageFromReceivedDictionary:(NSDictionary *)dic userId:(NSString *)belongId;

@end
