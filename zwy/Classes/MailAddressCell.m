//
//  MailAddressCell.m
//  zwy
//
//  Created by cqsxit on 13-10-22.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "MailAddressCell.h"

@implementation MailAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imageCheckView =[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 25, 25)];
        _imageCheckView.image =[UIImage imageNamed:@"btn_uncheck"];
        [self addSubview:_imageCheckView];
        
        self.labelText =[[UILabel alloc] initWithFrame:CGRectMake(50, 17, 250,15)];
        _labelText.font=[UIFont boldSystemFontOfSize:16];
        [self addSubview:_labelText];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
