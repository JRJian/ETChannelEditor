//
//  ETChanncelEditorCell.h
//  ETChannelEditor
//
//  Created by Jian on 2018/12/29.
//  Copyright © 2018 Oscar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ETChanncelEditorCellStatus) {
    ETChanncelEditorCellStatusNomral = 1 << 0,// With nothing
    ETChanncelEditorCellStatusEditing = 1 << 1, // With the close icon
    ETChanncelEditorCellStatusPlus = 1 << 2, // With the add icon
    ETChanncelEditorCellStatusEditingWithoutRoundedCorners = ETChanncelEditorCellStatusEditing & ETChanncelEditorCellStatusNomral,
};

NS_ASSUME_NONNULL_BEGIN

@interface ETChanncelEditorCell : UICollectionViewCell

/**
 Channel label
 */
@property (nonatomic, strong) UILabel *channelLabel;

/**
 See the enum of ETChanncelEditorCellStatus
 Default : ETChanncelEditorCellStatusNomral
 */
@property (nonatomic, assign) ETChanncelEditorCellStatus status;

@end

NS_ASSUME_NONNULL_END
