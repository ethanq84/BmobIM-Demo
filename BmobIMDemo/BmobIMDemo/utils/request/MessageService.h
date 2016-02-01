//
//  MessageService.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/20.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BmobIMDemoPCH.h"
#import <BmobSDK/Bmob.h>
#import "SysMessage.h"


@interface MessageService : NSObject

/**
 *  查找某个用户的通知信息
 *
 *  @param date  当前时间
 *  @param block 信息数组
 */
+(void)inviteMessages:(NSDate *)date completion:(BmobObjectArrayResultBlock)block;


@end
