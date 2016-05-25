//
//  MyDisplayViewController.m
//  Meet
//
//  Created by jiahui on 16/5/13.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MyDisplayViewController.h"
#import "MoreProfileViewController.h"
#import "UIView+frameAdjust.h"
#import "CTTextView.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CTFrameParser.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "MoreDescriptionDao.h"
#import "MoreDescriptionModel.h"

@interface MyDisplayViewController () {
    __weak IBOutlet UIScrollView *_scrollView;
    NSInteger _scrollViewContentHeight;
    NSMutableDictionary *_dicContentImages;
    NSMutableArray *_arrayContentModels;
    
    BOOL _isModifyPhotos;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewConstraintH;


@property (weak, nonatomic) IBOutlet CTTextView *ctView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctviewHConstraint;

@end
@implementation MyDisplayViewController

#define SECTION_MARGIN  12
#define VIEW_MARGIN     5
#define IMAGEVIEW_X     5
#define IMAGAVIEW_W     (self.view.width - 2*IMAGEVIEW_X)
//#define IMAGEVIEW_H     IMAGAVIEW_W

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人介绍";
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];
    [UITools navigationRightBarButtonForController:self action:@selector(editAction:) normalTitle:@"编辑" selectedTitle:nil];
    self.hidesBottomBarWhenPushed = YES;
    _dicContentImages = [NSMutableDictionary dictionary];
    [self loadDocumentGetAllBigImages];
    
    _scrollViewContentHeight = 10;
    
    _arrayContentModels = [NSMutableArray array];
    [self moreDescriptionModelsFromDB];
    [self loadCoreTextViewAndImageViews];
}

- (void)moreDescriptionModelsFromDB {
    [_arrayContentModels removeAllObjects];
    NSString *userId = [UserInfo shareInstance].userId;
    NSArray *array = [[MoreDescriptionDao shareInstance] selectMoreDescriptionByUserIDOrderByIndexASC:userId];
    [_arrayContentModels addObjectsFromArray:array];
}

- (void)loadCoreTextViewAndImageViews {
    NSArray *array = [_scrollView subviews];
    for (UIView *subView in array) {
        if ([subView isKindOfClass:[CTTextView class]] || [subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    for (NSInteger i = 0; i < _arrayContentModels.count; i++) {
        MoreDescriptionModel *model = _arrayContentModels[i];
        _scrollViewContentHeight += SECTION_MARGIN;
        CTTextView *coreTextView = [[CTTextView alloc] init];//
        CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
        config.width = IMAGAVIEW_W;
        NSString *modelTitle = model.title;
        if (modelTitle == nil) {
            modelTitle = @"";
        }
        NSString *titlStr = [model.title stringByAppendingString:@"\n"];
        NSString *modelContent = model.content;
        if (modelContent == nil) {
            modelContent = @"";
        }
        NSString *contentStr= [titlStr stringByAppendingString:modelContent];
        NSDictionary *attr = [CTFrameParser attributesWithConfig:config];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:attr];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, titlStr.length)];
        [attStr addAttribute:NSBackgroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(titlStr.length, contentStr.length - titlStr.length)];
        
        CoreTextData *data = [CTFrameParser parseAttributedContent:attStr config:config];
        coreTextView.data = data;
        coreTextView.backgroundColor = [UIColor whiteColor];
        coreTextView.frame = CGRectMake(IMAGEVIEW_X, _scrollViewContentHeight, IMAGAVIEW_W, data.height);
        [_scrollView addSubview:coreTextView];
        _scrollViewContentHeight += data.height;
        [self loadImageViewsWithSection:i];
    }
    _scrollViewConstraintH.constant = _scrollViewContentHeight + 10;
}

- (void)loadImageViewsWithSection:(NSInteger)section {
    NSArray *imageArray = _dicContentImages[[NSNumber numberWithInt:section]];
    [imageArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * stop) {
        CGSize size = image.size;
        CGFloat scale = size.width/IMAGAVIEW_W;
        CGFloat h = size.height/scale;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGEVIEW_X, _scrollViewContentHeight + VIEW_MARGIN, IMAGAVIEW_W, h)];
        imageView.image = image;
        [imageView setupImageViewer];
        [_scrollView addSubview:imageView];
        _scrollViewContentHeight += (imageView.height + VIEW_MARGIN);
    }];
}

- (void)reloadScrollView {
    
    [self loadDocumentGetAllBigImages];
    _scrollViewContentHeight = 10;
    [self moreDescriptionModelsFromDB];
    [self loadCoreTextViewAndImageViews];
    [self.view needsUpdateConstraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

#pragma  mark - files Data
- (void)loadDocumentGetAllBigImages {////获取文件里的image（大图片）
    [_dicContentImages removeAllObjects];
    NSMutableArray *array = [NSMutableArray array];
        NSString *mostContetPath = [[AppData shareInstance] getCacheMostContetnImagePath];
        NSArray *mostContetImagesDocArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mostContetPath error:nil];
        [mostContetImagesDocArray enumerateObjectsUsingBlock:^(NSString *section, NSUInteger idx, BOOL *stop) {
            NSString *sectionPath = [mostContetPath stringByAppendingPathComponent:section];
            NSArray *rowConttArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sectionPath error:nil];
            [rowConttArray enumerateObjectsUsingBlock:^(NSString *row, NSUInteger idx, BOOL *stop) {
                
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row.intValue inSection:section.intValue];
                [array addObject:indexPath];
            }];
        }];
        [self loadAllBigImagesInCacheWithIndexPathArry:array];
}

- (void)loadAllBigImagesInCacheWithIndexPathArry:(NSArray *)array {
    [array enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        NSString *path = [[AppData shareInstance] getCachesBigImageWithImageIndexPath:indexPath];
        NSArray *imagesName = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        NSMutableArray *array = [NSMutableArray array];
        [imagesName enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
            NSString *imagePath = [path stringByAppendingPathComponent:name];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            [array addObject:image];
        }];
        [_dicContentImages setObject:array forKey:[NSNumber numberWithInt:indexPath.section]];
    }];
}

#pragma mark - action
- (void)backAction:(id)sender {
    if (_isModifyPhotos) {
        self.block();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction:(id)sender {
    ///填写更多个人信息
    UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
    MoreProfileViewController *moreVC = [meStoryBoard instantiateViewControllerWithIdentifier:@"MoreProfileViewController"];
    moreVC.modifyBlock = ^(){
        _isModifyPhotos = YES;
        [self reloadScrollView];
    };
    moreVC.modifyTextBlock = ^(){
        [self reloadScrollView];
    };
    moreVC.editType = 1;
    [self.navigationController pushViewController:moreVC animated:YES];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToMyDisplayVC"]) {
        
    }
}

@end
