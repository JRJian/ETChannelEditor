//
//  ETChannelEditor.h
//  ETChannelEditor
//
//  Created by Jian on 2018/12/29.
//  Copyright © 2018 Oscar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString ETChannel;

NS_ASSUME_NONNULL_BEGIN

@interface ETChannelEditor : UIView

@property (nonatomic, strong, readonly) NSArray <ETChannel *> *pinChannels;
@property (nonatomic, strong, readonly) NSArray <ETChannel *> *unpinChannels;
@property (nonatomic, strong, readonly) UIButton *editButton;
/**
 Default is Zero.
 */
@property (nonatomic, assign) NSUInteger minimumCountOfPinChannel;

@property (nonatomic, copy) BOOL(^canMoveChannelHandler)(ETChannel *channel);
@property (nonatomic, copy) void(^didSelectChannelHandler)(ETChannel *channel);

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame
                  pinChannels:(NSArray <ETChannel *> *)pinChannels
                unpinChannels:(NSArray <ETChannel *> *)unpinChannels;

@end

NS_ASSUME_NONNULL_END
