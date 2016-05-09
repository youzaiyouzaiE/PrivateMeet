//
//  MyPhotoItem.h
//  Meet
//
//  Created by jiahui on 16/4/30.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol photoItemDelegate <NSObject>

- (void)photoItemButtonAction:(NSInteger)selectIndex;

@end

@interface MyPhotoItem : UICollectionViewCell

@property (weak, nonatomic) id <photoItemDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (assign, nonatomic) NSInteger index;

@end
