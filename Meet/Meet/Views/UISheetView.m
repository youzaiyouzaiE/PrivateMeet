//
//  UISheetView.m
//  Meet
//
//  Created by jiahui on 16/5/10.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "UISheetView.h"

#define TABLE_CELL_H        40
#define TABLE_SECTION_GAP   5

@interface UISheetView ()<UITableViewDelegate,UITableViewDataSource> {
    NSArray *_arrayContents;
    UIView *_backView;
    CGRect _frame ;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation UISheetView

- (instancetype)initWithContenArray:(NSArray *)array {
    self = [super init];
    if (self) {
        _arrayContents = array;
        if (_arrayContents && _arrayContents.count > 2) {
            self.bounds = CGRectMake(0, 0, ScreenWidth, _arrayContents.count * TABLE_CELL_H + TABLE_SECTION_GAP);
            self.frame = CGRectMake(0, ScreenHeight + self.bounds.size.height, CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds ));
            _frame = self.frame;
            self.backgroundColor = [UIColor blackColor];
            [self loadContentView];
        }
    }
    return self;
}

- (void)loadContentView {
    if (_arrayContents == nil) {
        return;
    }

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.scrollEnabled = NO;
    [self addSubview:self.tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    if(IOS_7LAST){
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 1, 0, 0);
    }
    [SHARE_APPDELEGATE.window addSubview:self];
    
//    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
//    _backView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
//    [_backView addSubview:self];
//    [SHARE_APPDELEGATE.window addSubview:_backView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _arrayContents.count - 1;
    } else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return TABLE_SECTION_GAP;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLE_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (indexPath.section == 0) {
        cell.textLabel.text = _arrayContents[indexPath.row];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = _arrayContents.lastObject;
    }
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(sheetView:didSelectRowAtIndex:)]) {
        NSInteger index;
        if (indexPath.section == 0) {
            index = indexPath.row;
        } else {
            index = _arrayContents.count - 1;
        }
        [self.delegate sheetView:self didSelectRowAtIndex:indexPath.row];
    }
}

- (void)show {
    [self animationForShow:YES];
}

- (void)hidden {
    [self animationForShow:NO];
}

- (void)animationForShow:(BOOL)isShow {
  [UIView animateWithDuration:0.3 animations:^{
      isShow ? (self.frame = CGRectMake(0, ScreenHeight - self.bounds.size.height, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))) : (self.frame = _frame );
  } completion:^(BOOL finished) {
      if (isShow) {
          _backView.hidden = NO;
      } else
          _backView.hidden = YES;
  }];
}


@end
