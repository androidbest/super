//
//  ConfigFile.h
//  zwy
//
//  Created by wangshuang on 13-5-5.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

//UIKIT_EXTERN NSString *NSStringFromCGPoint(CGPoint point);
//UIKIT_EXTERN NSString *NSStringFromCGSize(CGSize size);
//UIKIT_EXTERN NSString *NSStringFromCGRect(CGRect rect);
//UIKIT_EXTERN NSString *NSStringFromCGAffineTransform(CGAffineTransform transform);
//UIKIT_EXTERN NSString *NSStringFromUIEdgeInsets(UIEdgeInsets insets);
//
//UIKIT_EXTERN CGPoint CGPointFromString(NSString *string);
//UIKIT_EXTERN CGSize CGSizeFromString(NSString *string);
//UIKIT_EXTERN CGRect CGRectFromString(NSString *string);
//UIKIT_EXTERN CGAffineTransform CGAffineTransformFromString(NSString *string);
//UIKIT_EXTERN UIEdgeInsets UIEdgeInsetsFromString(NSString *string);

/*已查看过的“待办公文”路径*/
#define PATH_OVERMANAGE @"overManage.plist"

/*已查看过的“已办公文”路径*/
#define PATH_ENDMANAGE @"endManage.plist"

/*已查看过的“待审公文”路径*/
#define PATH_OVERHEAR @"overHear.plist"

/*已查看过的“已审公文”路径*/
#define PATH_ENDHEAR @"endHear.plist"

/*已查看过的“意见办理”路径*/
#define PATH_OPINIONMANAGE @"opinionManage.plist"

/*已查看过的“意见审批”路径*/
#define PATH_OPINIONHEAR @"opinionHear.plist"

/*日程提醒置顶标示*/
#define Warning_Frist @"warningFrist"

/*缓存图片地址*/
#define MESSGEFILEPATH @"messageFilePath"

/*发送图片尺寸刷新通告*/
#define NOTIFICATIONIMAGEDRAWRECT @"notificationImageDrawRect"

/*已赞新闻咨询保存plist文件*/
#define PATH_COMMEND @"commends.plist"


/**/
#define CHATMESSAGECOUNT(misdin,eccode) [NSString stringWithFormat:@"%@%@chatMessageCount",misdin,eccode]

/*聊天信息接受通告名*/
#define NOTIFICATIONCHAT @"notificationChat"

#import <Foundation/Foundation.h>
@interface ConfigFile : NSObject

@property(nonatomic,strong) NSMutableDictionary *configData;
+(ConfigFile *)newInstance;

//创建公文附件路径
- (void)paths;

-(void)initData;

//创建单位通讯录文件
+ (void)pathECGroups;

//创建用户文件夹
+ (void)pathUsersInfo;
#pragma mark - 获取通讯录所有信息
+ (NSMutableArray *)setAllPeopleInfo:(NSString *)str;
+ (NSMutableArray *)setEcNumberInfo;
@end
