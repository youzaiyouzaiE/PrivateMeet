//
//  ThreeImageCell.m
//  Meet
//
//  Created by jiahui on 16/4/30.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "ThreeImageCell.h"

#define CELL_HIGHT              100
#define IMAGE_HIGHT             (CELL_HIGHT - 20)
#define LEFT_MARGIN              16
#define RIGHT_MARGIN             5


#define IMAGE_LABEL_MARGIN     7
#define LABELS_MARGIN          4
#define  LABEL_H               20

@implementation ThreeImageCell {
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)loadViews
{
    _fristImageView = [[UIImageView alloc] init];
    _seconedImageView = [[UIImageView alloc] init];
    _thirdImageView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:_fristImageView];
    [self.contentView addSubview:_seconedImageView];
    [self.contentView addSubview:_thirdImageView];
}

- (void)defaultImageViewImages {
    _fristImageView.image = [UIImage imageNamed:@"NOPhoto"];
    _seconedImageView.image = [UIImage imageNamed:@"NOPhoto"];
    _thirdImageView.image = [UIImage imageNamed:@"NOPhoto"];
}

- (void)drawRect:(CGRect)rect {
    [self needsUpdateConstraints];
    [self setViewsFrame];
}

+ (CGFloat)threeImageCellHeight {
    return CELL_HIGHT;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self setViewsFrame];
}

- (void)setViewsFrame {
    if (_fristImageView.bounds.size.height == 0) {
        CGFloat middleGap = (self.contentView.bounds.size.width - LEFT_MARGIN - RIGHT_MARGIN - 3*IMAGE_HIGHT)/2;
//         NSLog(@"%f",middleGap);
        _fristImageView.frame = CGRectMake(LEFT_MARGIN,(self.contentView.bounds.size.height - IMAGE_HIGHT)/2, IMAGE_HIGHT, IMAGE_HIGHT);
        _seconedImageView.frame = CGRectMake(_fristImageView.frame.origin.x + _fristImageView.frame.size.width + middleGap,(self.contentView.bounds.size.height - IMAGE_HIGHT)/2, IMAGE_HIGHT, IMAGE_HIGHT);
        _thirdImageView.frame = CGRectMake(_seconedImageView.frame.origin.x + _seconedImageView.frame.size.width + middleGap,(self.contentView.bounds.size.height - IMAGE_HIGHT)/2, IMAGE_HIGHT, IMAGE_HIGHT);
    }
}


@end
