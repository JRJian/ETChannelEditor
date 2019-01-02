//
//  ETChannelEditor.m
//  ETChannelEditor
//
//  Created by Jian on 2018/12/29.
//  Copyright © 2018 Oscar. All rights reserved.
//

#import "ETChannelEditor.h"
#import "ETChannelEditorReusableHeaderView.h"
#import "ETChanncelEditorCell.h"

#import "UIImage+ETAdd.h"

static NSString * const kReuseIdentifier4Header = @"ETChannelEditorReusableHeaderView";
static NSString * const kReuseIdentifier4Cell = @"ETChanncelEditorCell";

API_AVAILABLE(ios(10.0))
@interface ETChannelEditor()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <ETChannel *> *pinChannels_;
@property (nonatomic, strong) NSMutableArray <ETChannel *> *unpinChannels_;

@property (nonatomic, strong) UIButton *editButton;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000 && TARGET_OS_IOS
@property (nonatomic, strong) UIImpactFeedbackGenerator *impactGenerator;
#endif

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation ETChannelEditor {
    NSIndexPath *_sourceIndexPath;
    CGRect _lastMovedCellFrame;
}

- (instancetype)initWithFrame:(CGRect)frame
                  pinChannels:(NSArray<ETChannel *> *)pinChannels
                unpinChannels:(NSArray<ETChannel *> *)unpinChannels {
    self = [super initWithFrame:frame];
    
    self.pinChannels_ = [pinChannels mutableCopy];
    self.unpinChannels_ = [unpinChannels mutableCopy];
    
    [self addSubview:self.collectionView];
    
    [self.collectionView addGestureRecognizer:self.longPressGesture];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionViewLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.bounds) - 30, 64);
    self.collectionView.frame = self.bounds;
}

#pragma mark -
#pragma mark Actions
- (void)editAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.longPressGesture.enabled = sender.selected;
    [self.collectionView reloadData];
}

- (void)lonePressMoving:(UILongPressGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:_collectionView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        { //手势开始
            [self beginInteractiveMovementAtPoint:point];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self updateInteractiveMovementAtPoint:point];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self endInteractiveMovement];
            break;
        }
        default:
            [self endInteractiveMovement];
            break;
    }
}

- (void)beginInteractiveMovementAtPoint:(CGPoint)point {
    _sourceIndexPath = [self indexPathWithPoint:point blackIndexPath:nil];
    
    if (!_sourceIndexPath)
        return;
    
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:_sourceIndexPath];
    
    if (!cell) return;
    
    [_collectionView bringSubviewToFront:cell];
    
    _lastMovedCellFrame = cell.frame;
    
    [cell setTransform:CGAffineTransformMakeScale(1.3, 1.3)];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000 && TARGET_OS_IOS
    [self.impactGenerator impactOccurred];
#endif
}

- (void)updateInteractiveMovementAtPoint:(CGPoint)point {
    if (!_sourceIndexPath)
        return;
    
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:_sourceIndexPath];
    cell.center = point;
    
    NSIndexPath *targetIndexPath = [self indexPathWithPoint:point
                                             blackIndexPath:_sourceIndexPath];
    
    if (!targetIndexPath)
        return;
    
    [self moveItemAtIndexPath:_sourceIndexPath toIndexPath:targetIndexPath];
    
    //更新item位置
    [_collectionView moveItemAtIndexPath:_sourceIndexPath toIndexPath:targetIndexPath];
    
    _lastMovedCellFrame = [_collectionView cellForItemAtIndexPath:targetIndexPath].frame;
    
    _sourceIndexPath = targetIndexPath;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000 && TARGET_OS_IOS
    [self.impactGenerator impactOccurred];
#endif
}

- (void)endInteractiveMovement {
    if (!_sourceIndexPath)
        return;
    
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:_sourceIndexPath];
    
    [UIView animateWithDuration:0.3 animations:^{
        [cell setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        cell.frame = self->_lastMovedCellFrame;
    } completion:^(BOOL finished) {
        self->_lastMovedCellFrame = CGRectZero;
        self->_sourceIndexPath = nil;
    }];
}

#pragma mark -
#pragma mark Utilites
- (NSIndexPath *)indexPathWithPoint:(CGPoint)point blackIndexPath:(NSIndexPath *)blackIndexPath {
    NSIndexPath *retIndexPath = nil;
    
    if (self.pinChannels_.count == 1) {return retIndexPath;}
    
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        
        if (indexPath.section > 0)
            continue;
        
        if (blackIndexPath && [blackIndexPath compare:indexPath] == NSOrderedSame)
            continue;
        
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            
            if (indexPath.row < self.pinChannels_.count) {
                ETChannel *channel = self.pinChannels_[indexPath.row];
                if (self.canMoveChannelHandler) {
                    if (self.canMoveChannelHandler(channel)) {
                        retIndexPath = indexPath;
                        break;
                    }
                } else {
                    retIndexPath = indexPath;
                    break;
                }
            }
        }
    }
    return retIndexPath;
}


- (void)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    if (sourceIndexPath.section == 0 && destinationIndexPath.section == 0) {
        if (sourceIndexPath.row < self.pinChannels.count && destinationIndexPath.row < self.pinChannels.count) {
            NSString *removedTag = self.pinChannels[sourceIndexPath.row];
            [self.pinChannels_ removeObjectAtIndex:sourceIndexPath.row];
            [self.pinChannels_ insertObject:removedTag atIndex:destinationIndexPath.row];
        }
    }
}

#pragma mark -
#pragma mark UICollectionViewDelegate

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.pinChannels.count;
    }
    return self.unpinChannels.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ETChannelEditorReusableHeaderView *reusableView = ({
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:kReuseIdentifier4Header
                                                  forIndexPath:indexPath];
    });
    
    switch (indexPath.section) {
        case 0: {
            reusableView.titleLabel.text = @"My Channels";
            reusableView.descriptionLabel.text = @"Click to enter the channel";
            
            [reusableView addSubview:self.editButton];
            CGFloat x = self.collectionViewLayout.headerReferenceSize.width - CGRectGetWidth(self.editButton.frame) + 15;
            CGFloat y = (self.collectionViewLayout.headerReferenceSize.height - CGRectGetHeight(self.editButton.frame)) * 0.5;
            [self.editButton setFrame:CGRectMake(x,
                                                 y,
                                                 CGRectGetWidth(self.editButton.frame),
                                                 CGRectGetHeight(self.editButton.frame))];
            break;
        }
        case 1: {
            reusableView.titleLabel.text = @"More Channels";
            reusableView.descriptionLabel.text = @"Click to add to My Channels";
            break;
        }
    }
    
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETChanncelEditorCell *cell = ({
        [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier4Cell
                                                  forIndexPath:indexPath];
    });
    
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row < self.pinChannels.count) {
                cell.channelLabel.text = self.pinChannels[indexPath.row];
            }
            
            if (self.editButton.selected) {
                
                if (self.canMoveChannelHandler) {
                    if (self.canMoveChannelHandler(cell.channelLabel.text))
                        cell.status = ETChanncelEditorCellStatusEditing;
                    else
                        cell.status = ETChanncelEditorCellStatusEditingWithoutRoundedCorners;
                }
                
            } else {
                cell.status = ETChanncelEditorCellStatusNomral;
            }
            break;
        }
        case 1: {
            if (indexPath.row < self.unpinChannels.count) {
                cell.channelLabel.text = self.unpinChannels[indexPath.row];
                cell.status = ETChanncelEditorCellStatusPlus;
            }
            break;
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        ETChannel *channel = self.pinChannels_.firstObject;
        if (indexPath.row < self.pinChannels_.count) {
            channel = self.pinChannels_[indexPath.row];
        }
        
        // Unedited status, click channel to trigger click event
        if (!self.editButton.selected) {
            !self.didSelectChannelHandler?:self.didSelectChannelHandler(channel);
            return;
        }
        
        // 编辑状态
        // 只剩下最少数量的时候不可删除
        if (self.pinChannels_.count == _minimumCountOfPinChannel)
            return;
        
        if (self.canMoveChannelHandler) {
            if (!self.canMoveChannelHandler(channel))
                return;
        }
        
        ETChanncelEditorCell *cell = (ETChanncelEditorCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell) {
            cell.status = ETChanncelEditorCellStatusPlus;
        }
        
        id obj = [self.pinChannels_ objectAtIndex:indexPath.row];
        [self.pinChannels_ removeObject:obj];
        [self.unpinChannels_ insertObject:obj atIndex:0];
        [_collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    } else {
        
        ETChanncelEditorCell *cell = (ETChanncelEditorCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell) {
            if (self.editButton.selected) {
                cell.status = ETChanncelEditorCellStatusEditing;
            } else {
                cell.status = ETChanncelEditorCellStatusNomral;
            }
        }
        
        id obj = [self.unpinChannels_ objectAtIndex:indexPath.row];
        [self.unpinChannels_ removeObject:obj];
        [self.pinChannels_ addObject:obj];
        [_collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:self.pinChannels_.count - 1 inSection:0]];
    }
}

#pragma mark -
#pragma mark Getter
- (UICollectionViewFlowLayout *)collectionViewLayout {
    if (!_collectionViewLayout) {
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _collectionViewLayout.minimumInteritemSpacing = 0;
        _collectionViewLayout.minimumLineSpacing = 10;
        _collectionViewLayout.itemSize = CGSizeMake(78, 34);
        _collectionViewLayout.headerReferenceSize = CGSizeMake(400, 68);
    }
    return _collectionViewLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                             collectionViewLayout:self.collectionViewLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[ETChannelEditorReusableHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:kReuseIdentifier4Header];
        
        [_collectionView registerClass:[ETChanncelEditorCell class] forCellWithReuseIdentifier:kReuseIdentifier4Cell];
    }
    return _collectionView;
}

- (UIButton *)editButton {
    if (!_editButton) {
        UIColor *color = [[UIColor redColor] colorWithAlphaComponent:0.55];
        UIImage *cornerRaidusImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(54, 28)];
        cornerRaidusImage = [cornerRaidusImage imageByRoundCornerRadius:14 corners:UIRectCornerAllCorners borderWidth:1.0 borderColor:color];
        
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [_editButton setTitle:@"Done" forState:UIControlStateSelected];
        [_editButton setTitleColor:color forState:UIControlStateNormal];
        [_editButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_editButton setBackgroundImage:cornerRaidusImage forState:UIControlStateNormal];
        [_editButton setFrame:CGRectMake(0, 0, 54, 28)];
        
        [_editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000 && TARGET_OS_IOS
- (UIImpactFeedbackGenerator *)impactGenerator {
    if (!_impactGenerator) {
        _impactGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    }
    return _impactGenerator;
}
#endif

- (UILongPressGestureRecognizer *)longPressGesture {
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    }
    return _longPressGesture;
}

- (NSArray<ETChannel *> *)pinChannels {
    return [_pinChannels_ copy];
}

- (NSArray<ETChannel *> *)unpinChannels {
    return [_unpinChannels_ copy];
}

@end
