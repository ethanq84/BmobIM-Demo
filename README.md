# BmobIM-Demo

## 开发环境
项目开发环境是基于XCode7，app支持的最低iOS版本为iOS7

## 项目介绍

### 布局
主要使用了StoryBoard和Masonry框架

### 说明文档
关于BmobIMSDK的快速入门文档，可以参考[这里](http://docs.bmob.cn/im/faststart/index.html?menukey=fast_start&key=start_im#index_iOS即时通讯服务)

### 模块

项目一共分为三大模块

1. 会话模块
2. 联系人模块
3. 设置模块
4. 注册登录模块

## 详情

### 会话模块
项目的会话模块用来显示聊天列表，通过聊天聊表，可以得知谁最近有跟用户联系过。点击cell，即可进入到聊天页面进行聊天

### 联系人模块

1. 好友通知：在这个页面可以直接查看有谁发来了好友请求
2. 附近的人：未实现
3. 好友列表：这里可以查服务器的数据然后显示出来
4. 用户列表页：显示了除了本人之外，在服务器上注册的人，用户在详情页可以选择添加好友，或者直接聊天

### 设置模块
设置页面提供了 上传头像，修改昵称，修改性别等接口，开发者可以通过这部分内容来熟悉BmobSDK的接口

### 注册登录模块
注册登录页面 提供了给用户注册或者登录的接口

### TODO

项目尚未完成的功能有

1. 设置部分的意见反馈功能

### 注意事项
项目是通过cocoapods管理第三方库的，所以运行时需要打开BmobIMDemo.xcworkspace这个文件
## 第三方库

| 第三方库 |     说明    | 地址 |
|---------|------------|-----|
| SDWebImage | 图片下载 | https://github.com/rs/SDWebImage |
| Masonry |界面布局|https://github.com/SnapKit/Masonry|
| UITableView+FDTemplateLayoutCell | UITableView 自动计算cell高度 |https://github.com/forkingdog/UITableView-FDTemplateLayoutCell|
| UUChatTableView | 显示录音时间 |https://github.com/ZhipingYang/UUChatTableView|
| AFNetworking | 下载文件 |https://github.com/AFNetworking/AFNetworking|

## 反馈
开发者在使用BmobIMSDK遇到的问题可以在Bmob的客服群，问答社区进行反馈或者建议。


