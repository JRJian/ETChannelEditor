//
//  ViewController.m
//  ETChannelEditor
//
//  Created by Jian on 2018/12/29.
//  Copyright © 2018 Oscar. All rights reserved.
//

#import "ViewController.h"
#import "ETChannelEditor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(0,
                             20,
                             CGRectGetWidth(self.view.bounds),
                             CGRectGetHeight(self.view.bounds) - 20);
    
    NSArray *pinChannels = @[@"Hot", @"Popular", @"Bilingual", @"China",
                             @"Business", @"Opinion", @"World", @"Culture",
                             @"Life", @"Travel", @"Sports", @"Video",
                             @"Special", @"Service", @"Newspaper"];
    
    NSArray *unpinChannels = @[@"NBA", @"Trend", @"Tech", @"Music"];
    
    ETChannelEditor *editor = [[ETChannelEditor alloc] initWithFrame:rect
                                                         pinChannels:pinChannels
                                                       unpinChannels:unpinChannels];
    
    [editor setCanMoveChannelHandler:^BOOL(ETChannel * _Nonnull channel) {
        if ([channel isEqualToString:@"Hot"])
            return NO;
        return YES;
    }];
    
    [editor setDidSelectChannelHandler:^(ETChannel * _Nonnull channel) {
        NSLog(@"click at %@", channel);
    }];
    
    [self.view addSubview:editor];
}


@end
