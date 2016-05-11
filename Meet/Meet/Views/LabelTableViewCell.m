//
//  LabelTableViewCell.m
//  Meet
//
//  Created by jiahui on 16/5/11.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "LabelTableViewCell.h"

@implementation LabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)labeAddLayerMargin:(BOOL)isSet andSetLabelText:(NSString *)text {
    if (isSet) {
        _label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _label.layer.borderWidth = 1.0f;
        _label.layer.cornerRadius = 4.0f;
    }
    _label.text = text;
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _label.alpha = 0.6;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _label.alpha = 1;
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    _label.alpha = 1;
    [super touchesCancelled:touches withEvent:event];
}
@end
