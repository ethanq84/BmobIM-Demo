//
//  BmobIMImageMessage.h
//  BmobIMSDK
//
//  Created by Bmob on 16/1/30.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <BmobIMSDK/BmobIMSDK.h>

@interface BmobIMImageMessage : BmobIMMessage


/**
 *  创建图片消息
 *
 *  @param url        图片的url
 *  @param attributes 用户自定义的属性
 *
 *  @return 图片信息
 */
+(instancetype)messageWithUrl:(NSString *)url
                   attributes:(NSDictionary *)attributes;


@end
