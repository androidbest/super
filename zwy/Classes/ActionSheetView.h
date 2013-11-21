//
//  ActionSheetView.h
//  zwy
//
//  Created by cqsxit on 13-10-19.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActionSheetView;
@protocol ActionSheetViewDetaSource <NSObject>

- (void)actionSheetTimeText:(NSString *)Text;
@end
@interface ActionSheetView :UIActionSheet<UIActionSheetDelegate>

- (id)initWithViewdelegate:(id)delegate WithSheetTitle:(NSString *)_title sheetMode:(NSInteger)Mode;

@property(strong,nonatomic) UIDatePicker * dataSetView;
@property (assign ,nonatomic)id<ActionSheetViewDetaSource>DetaSource;
@property (strong ,nonatomic)NSDate *firstDate;

@end
