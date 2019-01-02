//
//  ETChannelEditorReusableHeaderView.m
//  ETChannelEditor
//
//  Created by Jian on 2018/12/29.
//  Copyright © 2018 Oscar. All rights reserved.
//

#import "ETChannelEditorReusableHeaderView.h"

@implementation ETChannelEditorReusableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addSubview:self.titleLabel];
    [self addSubview:self.descriptionLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    [self.descriptionLabel sizeToFit];
    
    self.titleLabel.frame = CGRectMake(15,
                                       0,
                                       CGRectGetWidth(self.titleLabel.frame),
                                       CGRectGetHeight(self.bounds));
    self.descriptionLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10,
                                             0,
                                             CGRectGetWidth(self.descriptionLabel.frame),
                                             CGRectGetHeight(self.bounds));
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel new];
        _descriptionLabel.font = [UIFont systemFontOfSize:12];
        _descriptionLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
    return _descriptionLabel;
}

@end
