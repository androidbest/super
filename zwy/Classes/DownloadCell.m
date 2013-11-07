//
//  DownloadCell.m
//  zwy
//
//  Created by cqsxit on 13-10-15.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "DownloadCell.h"


@implementation DownloadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithDelegate:(id)delegate URL:(NSString *)url reuseIdentifier:(NSString *)reuseIdentifier filePath:(NSString *)path{
    
    self =[super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self){
        self.urlFile=[NSURL URLWithString:url];
        self.filePath =path;
        self.delegate=delegate;
        
        
        _fileText=[[UILabel alloc] init];
        _fileText.frame =CGRectMake(18,12,130, 20);
        _fileText.font=[UIFont systemFontOfSize:12];
        _fileText.textColor =[UIColor blackColor];
        [self addSubview:_fileText];
        
        self.progressFileDown =[[UIProgressView alloc] init];
        _progressFileDown.frame =CGRectMake(150, 20, 150, 5);
        _progressFileDown.progress=0.0f;
        [self addSubview:_progressFileDown];
        
        self.labelText=[[UILabel alloc] init];
        _labelText.frame =CGRectMake(260, 25, 80, 20);
        _labelText.font=[UIFont systemFontOfSize:10];
        _labelText.textColor =[UIColor grayColor];
        _labelText.text=@"0.00%";
        [self addSubview:_labelText];
        
        [self downRequestOperation];
    }
    return self;
}

- (id)initWithURL:(NSString *)url reuseIdentifier:(NSString *)reuseIdentifier filePath:(NSString *)path{
    self =[super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self){
        self.urlFile=[NSURL URLWithString:url];
        self.filePath =path;
        self.progressFileDown =[[UIProgressView alloc] init];
        _progressFileDown.frame =CGRectMake(150, 10, 150, 5);
        _progressFileDown.progress=0.0f;
        [self addSubview:_progressFileDown];
        
        self.labelText=[[UILabel alloc] init];
        _labelText.frame =CGRectMake(250, 15, 80, 20);
        _labelText.font=[UIFont systemFontOfSize:10];
        _labelText.textColor =[UIColor grayColor];
        _labelText.text=@"0.00%";
        [self addSubview:_labelText];
        
        [self downRequestOperation];
    }
    return self;
}

- (void)downRequestOperation{
    NSMutableURLRequest * request =[[NSMutableURLRequest alloc] initWithURL:_urlFile];
    AFURLConnectionOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:_filePath append:NO];
    
    [(AFHTTPRequestOperation *)operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.labelText.text=@"下载完成";
        [self.delegate downloadCellSaveWithFilePath:_filePath DownloadCell:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@",error);
        self.labelText.text=@"下载失败";
    }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float percentDone = totalBytesRead/(float)totalBytesExpectedToRead;
        _progressFileDown.progress =percentDone;
        self.labelText.text =[NSString stringWithFormat:@"%d%%",(int)(percentDone*100.0f)];

    }];
    
    [operation start];
    [self.delegate downloadingAllThread:operation];
}

- (void)stopOperation:(AFURLConnectionOperation *)operation{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
