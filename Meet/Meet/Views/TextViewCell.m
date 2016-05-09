//
//  TextViewCell.m
//  Meet
//
//  Created by jiahui on 16/5/4.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "TextViewCell.h"

@implementation TextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
        //        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return self;
}

- (void)loadViews {
    
//    _textView = [[CellPlaceHolderTextView alloc] init];
    _textView = [[CellTextView alloc] init];
    _textView.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    [self.contentView addSubview:_textView];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self setViewsFrame];
}

- (void)setViewsFrame {
    if (_textView.bounds.size.height == 0) {
        _textView.frame = CGRectMake(10, 1, self.contentView.bounds.size.width - 10 - 5, self.contentView.bounds.size.height -2);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
