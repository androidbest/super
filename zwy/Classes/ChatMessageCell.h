//
//  ChatMessageCell.h
//  zwy
//
//  Created by wangshuang on 12/18/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageCell : UITableViewCell
@property (strong, nonatomic) UILabel *chatTime;
@property (strong, nonatomic) UIButton *leftHead;
@property (strong, nonatomic) UIButton *rightHead;
@property (strong, nonatomic) UIImageView *leftMessage;
@property (strong, nonatomic) UIImageView *rightMessage;

@end
