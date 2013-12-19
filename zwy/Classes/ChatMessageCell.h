//
//  ChatMessageCell.h
//  zwy
//
//  Created by wangshuang on 12/18/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *chatTime;
@property (strong, nonatomic) IBOutlet UIButton *leftHead;
@property (strong, nonatomic) IBOutlet UIButton *rightHead;
@property (strong, nonatomic) IBOutlet UIImageView *leftMessage;
@property (strong, nonatomic) IBOutlet UIImageView *rightMessage;

@end
