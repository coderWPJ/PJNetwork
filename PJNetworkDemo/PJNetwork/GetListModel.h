//
//  GetListModel.h
//  PJNetwork
//
//  Created by wu on 2018/9/27.
//  Copyright © 2018年 wu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 "trackId": 84487757,
 "uid": 2629577,
 "playUrl64": "http://audio.xmcdn.com/group40/M07/6E/C8/wKgJVFrd_Qqi2EPuAWTbR3XdNo8603.mp3",
 "playUrl32": "http://audio.xmcdn.com/group42/M0B/A3/F5/wKgJ81rd_PSidRhXALJtus5AQYg245.mp3",
 "playPathHq": "",
 "playPathAacv164": "http://audio.xmcdn.com/group41/M0B/A7/36/wKgJ8Vrd_Wnhk2Y_AWkcInh3ZF8937.m4a",
 "playPathAacv224": "http://audio.xmcdn.com/group42/M06/A8/E5/wKgJ9Frd_PSjnXnUAIoRYV5AOvw352.m4a",
 "title": "段子来了丨女人这本书，就算翻烂了也读不懂~80423（采采）",
 "duration": 2923,
 "albumId": 203355,
 "isPaid": false,
 "isVideo": false,
 "isDraft": false,
 "isRichAudio": false,
 "type": 0,
 "relatedId": 0,
 "orderNo": 686,
 "isHoldCopyright": true,
 "processState": 2,
 "createdAt": 1524498014000,
 "coverSmall": "http://fdfs.xmcdn.com/group40/M0B/6F/4E/wKgJVFreAtyi-2itAADOqmdoNLU341_web_meduim.jpg",
 "coverMiddle": "http://fdfs.xmcdn.com/group40/M0B/6F/4E/wKgJVFreAtyi-2itAADOqmdoNLU341_web_large.jpg",
 "coverLarge": "http://fdfs.xmcdn.com/group40/M0B/6F/4E/wKgJVFreAtyi-2itAADOqmdoNLU341_mobile_large.jpg",
 "nickname": "采采",
 "smallLogo": "http://fdfs.xmcdn.com/group39/M03/50/9D/wKgJn1pkuV-TvjcCAACTPuQEyCw892_mobile_small.jpg",
 "userSource": 1,
 "opType": 1,
 "isPublic": true,
 "likes": 3602,
 "playtimes": 5688136,
 "comments": 894,
 "shares": 0,
 "status": 1
 */

@interface GetListModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *coverSmall;

@end
