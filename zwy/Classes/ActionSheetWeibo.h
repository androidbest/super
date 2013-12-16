//
//  ActionSheetWeibo.h
//  zwy
//
//  Created by cqsxit on 13-10-30.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionSheetWeibo;
@protocol ActionSheetWeiboDetaSource <NSObject>
@optional
- (void)actionSheetIndex:(NSInteger)index;

@end

@interface ActionSheetWeibo : UIActionSheet<UIActionSheetDelegate>

- (id)initWithViewdelegate:(id)delegate WithSheetTitle:(NSString *)_title;

@property (assign ,nonatomic)id<ActionSheetWeiboDetaSource>DetaSource;

@end
