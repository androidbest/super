//
//  DownloadCell.h
//  zwy
//
//  Created by cqsxit on 13-10-15.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DownloadCell;
@protocol DownloadCellDelegate <NSObject>

- (void)downloadCellSaveWithFilePath:(NSString *)FilePath DownloadCell:(DownloadCell *)cell;

@end

@interface DownloadCell : UITableViewCell

@property (strong ,nonatomic)UIProgressView * progressFileDown;//进度条
@property (strong ,nonatomic)NSURL * urlFile;//URL
@property (strong ,nonatomic)NSString *filePath;//文件保存路径
@property (strong ,nonatomic)UILabel * labelText;
@property (strong ,nonatomic)UILabel * fileText; 
@property (assign ,nonatomic)id<DownloadCellDelegate>delegate;
- (id)initWithDelegate:(id)delegate URL:(NSString *)url reuseIdentifier:(NSString *)reuseIdentifier filePath:(NSString *)path;

- (id)initWithURL:(NSString *)url reuseIdentifier:(NSString *)reuseIdentifier filePath:(NSString *)path;

@end
