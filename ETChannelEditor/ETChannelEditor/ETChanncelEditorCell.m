//
//  ETChanncelEditorCell.m
//  ETChannelEditor
//
//  Created by Jian on 2018/12/29.
//  Copyright © 2018 Oscar. All rights reserved.
//

#import "ETChanncelEditorCell.h"
#import "UIImage+ETAdd.h"

@interface ETChanncelEditorCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *backgroundConerRadiusView;
@end

@implementation ETChanncelEditorCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self.contentView addSubview:self.backgroundConerRadiusView];
    [self.contentView addSubview:self.channelLabel];
    [self.contentView addSubview:self.iconImageView];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.backgroundConerRadiusView.bounds.size.height != self.bounds.size.height) {
        UIImage *cornerRaduisImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        cornerRaduisImage = [cornerRaduisImage imageByRoundCornerRadius:CGRectGetHeight(self.bounds) * 0.5
                                                                corners:UIRectCornerAllCorners
                                                            borderWidth:1.0
                                                            borderColor:[UIColor colorWithWhite:.95 alpha:1.0]];
        
        self.backgroundConerRadiusView.image = cornerRaduisImage;
    }
    
    self.backgroundConerRadiusView.frame = self.bounds;
    self.iconImageView.frame = CGRectMake(8, 0, 14, CGRectGetHeight(self.bounds));
    
    if (_status == ETChanncelEditorCellStatusNomral) {
        self.channelLabel.frame = CGRectInset(self.bounds, 15, 0);
    } else {
        self.channelLabel.frame = CGRectMake(20, 0, CGRectGetWidth(self.bounds) - 20 - 10, CGRectGetHeight(self.bounds));
    }
}

- (void)setStatus:(ETChanncelEditorCellStatus)status {
    _status = status;
    
    switch (status) {
        case ETChanncelEditorCellStatusNomral: {
            self.iconImageView.image = nil;
            self.backgroundConerRadiusView.hidden = NO;
            break;
        }
        case ETChanncelEditorCellStatusEditing: {
            self.iconImageView.image = [UIImage imageNamed:@"CLOSE"];
            self.backgroundConerRadiusView.hidden = NO;
            break;
        }
        case ETChanncelEditorCellStatusPlus: {
            self.iconImageView.image = [UIImage imageNamed:@"PLUS"];
            self.backgroundConerRadiusView.hidden = NO;
            break;
        }
        case ETChanncelEditorCellStatusEditingWithoutRoundedCorners: {
            self.iconImageView.image = nil;
            self.backgroundConerRadiusView.hidden = YES;
            break;
        }
    }
    
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark Getter
- (UIImageView *)backgroundConerRadiusView {
    if (!_backgroundConerRadiusView) {
        _backgroundConerRadiusView = [UIImageView new];
    }
    return _backgroundConerRadiusView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)channelLabel {
    if (!_channelLabel) {
        _channelLabel = [UILabel new];
        _channelLabel.adjustsFontSizeToFitWidth = YES;
        _channelLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        _channelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _channelLabel;
}

@end
