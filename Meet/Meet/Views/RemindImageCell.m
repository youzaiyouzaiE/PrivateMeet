//
//  RemindImageCell.m
//  Meet
//
//  Created by jiahui on 16/5/2.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "RemindImageCell.h"

#define LeftItemMargin      16
#define RightItemMargin     16

#define ImageTitleView_W    74
#define ImageTitleView_H    84

@interface RemindImageCell () {
//    NSMutableArray *_arrayItems;
}

@end

@implementation RemindImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _arrayItems = [NSMutableArray array];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    _fristItem = [[ImageAndTitleView alloc] init];
    _secondItem = [[ImageAndTitleView alloc] init];
    _thirdItem = [[ImageAndTitleView alloc] init];
    _fourItem = [[ImageAndTitleView alloc] init];
    
    _fristItem.bounds = CGRectMake(0, 0, 74, 84);
    _secondItem.bounds = CGRectMake(0, 0, 74, 84);
    _thirdItem.bounds = CGRectMake(0, 0, 74, 84);
    _fourItem.bounds = CGRectMake(0, 0, 74, 84);
    
    [self.contentView addSubview:_fristItem];
    [self.contentView addSubview:_secondItem];
    [self.contentView addSubview:_thirdItem];
    [self.contentView addSubview:_fourItem];
    
    [_fristItem loadSubViewFrames];
    [_secondItem loadSubViewFrames];
    [_thirdItem loadSubViewFrames];
    [_fourItem loadSubViewFrames];
    
//    [_arrayItems addObject:_fristItem];
//    [_arrayItems addObject:_secondItem];
//    [_arrayItems addObject:_thirdItem];
//    [_arrayItems addObject:_fourItem];
}

+ (CGFloat)remindImageCellHeight {
    return 92;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)addTapGestureRecognizers {
    _fristItem.imageView.userInteractionEnabled = YES;
    _secondItem.imageView.userInteractionEnabled = YES;
    _thirdItem.imageView.userInteractionEnabled = YES;
    _fourItem.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fristTapGestureRecognizer:)];
    [_fristItem addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondTapGestureRecognizer:)];
    [_secondItem addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdTapGestureRecognizer:)];
    [_thirdItem addGestureRecognizer:tap3];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fourTapGestureRecognizer:)];
    [_fourItem addGestureRecognizer:tap4];
}

- (void)fristTapGestureRecognizer:(id)sender {
    
    
     NSLog(@"frist");
}

- (void)secondTapGestureRecognizer:(id)sender {
     NSLog(@"second");
}

- (void)thirdTapGestureRecognizer:(id)sender {
     NSLog(@"third");
}

- (void)fourTapGestureRecognizer:(id)sender {
     NSLog(@"four");
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setSubViewsFrame];
}

- (void)setSubViewsFrame {
//    if (_fristItem.frame.size.width == 0) {
        _fristItem.frame = CGRectMake(LeftItemMargin, 4, ImageTitleView_W, ImageTitleView_H);
        _secondItem.frame = CGRectMake((self.contentView.bounds.size.width - ImageTitleView_W * 4 - LeftItemMargin - RightItemMargin)/3 + _fristItem.frame.origin.x + _fristItem.bounds.size.width, 4, ImageTitleView_W, ImageTitleView_H);
        _thirdItem.frame = CGRectMake((self.contentView.bounds.size.width - ImageTitleView_W * 4 - LeftItemMargin - RightItemMargin)/3 + _secondItem.frame.origin.x + _secondItem.bounds.size.width, 4, ImageTitleView_W, ImageTitleView_H);
        _fourItem.frame = CGRectMake((self.contentView.bounds.size.width - ImageTitleView_W * 4 - LeftItemMargin - RightItemMargin)/3 + _thirdItem.frame.origin.x + _thirdItem.bounds.size.width, 4, ImageTitleView_W, ImageTitleView_H);
//    }
}

@end
