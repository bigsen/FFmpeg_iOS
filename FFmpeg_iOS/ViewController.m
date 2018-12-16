//
//  ViewController.m
//  FFmpeg_iOS
//
//  Created by sen on 2018/12/15.
//  Copyright © 2018年 sen. All rights reserved.
//

#import "ViewController.h"
#import "ffmpeg.h"
@interface ViewController ()
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self normalRun2];

}


/**
 第一种调用方式
 */
- (void)normalRun{
    NSString *fromFile = [[NSBundle mainBundle]pathForResource:@"video.mov" ofType:nil];
    NSString *toFile = @"/Users/sen/Desktop/Output/video.gif";
    
    int argc = 4;
    char **arguments = calloc(argc, sizeof(char*));
    if(arguments != NULL)
    {
        arguments[0] = "ffmpeg";
        arguments[1] = "-i";
        arguments[2] = (char *)[fromFile UTF8String];
        arguments[3] = (char *)[toFile UTF8String];
        
        if (!ffmpeg_main(argc, arguments)) {
            NSLog(@"生成成功");
        }
    }
}

- (void)normalRun2{
    
    NSString *fromFile = [[NSBundle mainBundle]pathForResource:@"video.mov" ofType:nil];
    NSString *toFile   = @"/Users/sen/Desktop/Output/video.gif";
    
    NSString *command_str = [NSString stringWithFormat:@"ffmpeg -i %@ %@",fromFile,toFile];
    
    // 分割字符串
    NSMutableArray  *argv_array  = [command_str componentsSeparatedByString:(@" ")].mutableCopy;
    
    // 获取参数个数
    int argc = (int)argv_array.count;
    
    // 遍历拼接参数
    char **argv = calloc(argc, sizeof(char*));
    
    for(int i=0; i<argc; i++)
    {
        NSString *codeStr = argv_array[i];
        argv_array[i]     = codeStr;
        argv[i]      = (char *)[codeStr UTF8String];
    }
    
    ffmpeg_main(argc, argv);
}
@end
