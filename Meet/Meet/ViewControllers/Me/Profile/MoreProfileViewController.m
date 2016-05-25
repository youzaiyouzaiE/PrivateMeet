//
//  MoreProfileViewController.m
//  Meet
//
//  Created by jiahui on 16/5/4.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MoreProfileViewController.h"
#import "CellTextField.h"
//#import "CellPlaceHolderTextView.h"
#import "TextViewCell.h"
#import "UITextView+Placeholder.h"
#import "CellTextView.h"
#import "MyPhotosViewController.h"
#import "MoreDescriptionDao.h"
#import "MoreDescriptionModel.h"

#define TABLE_HEADER_VIEW_H         49

@interface MoreProfileViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate> {
    NSMutableArray *_arrayModel;
    NSMutableArray *_arraySection;
    NSMutableDictionary *_dicHeaderContent;
    NSMutableDictionary *_dicPlaceHolder;
    NSMutableDictionary *_dicContentModels;
    NSCache *_cacheImages;
    NSMutableArray *_arrayHaveImageIndex;/////那些位置有图片 得到本地图片用
    NSMutableArray *_arrayCacheImgaeKeys;
    
    
    
    BOOL keyboardShow;
    CGRect tableViewFrame;
    
    NSIndexPath *_editingIndexPath;
    BOOL isEditSectionTitle;
    NSUInteger _editingSection;
    
    BOOL isModifyImages;
    BOOL isModifyText;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MoreProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_editType == 0) {
        [self customNavigationBar];
    } else {
        [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];
    }
    self.navigationItem.title = @"更多个人介绍";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.hidesBottomBarWhenPushed = YES;
    [UITools navigationRightBarButtonForController:self action:@selector(saveAction:) normalTitle:@"保存" selectedTitle:nil];
    _arrayModel = [NSMutableArray array];
    _arraySection = [NSMutableArray arrayWithArray:@[@"lifeAndJob",@"interset",@"custom0",@"hopeFriends",@"last"]];
    _dicHeaderContent = [NSMutableDictionary dictionaryWithDictionary:@{_arraySection[0]:@"您的工作、生活情况",_arraySection[1]:@"您的兴趣及爱好",_arraySection[2]:@"给您增加的内容起个标题吧",_arraySection[3]:@"您希望认识什么样的朋友",_arraySection[4]:@""}];
    _dicPlaceHolder = [NSMutableDictionary dictionaryWithDictionary:@{_arraySection[0]:@"包括但不限于：你的工作内容、工作状态及工作中的收获；你的生活方式、对生活要求及对未来生活的期待。",_arraySection[1]:@"可以分享下你的兴趣爱好都有哪些，为什么会喜欢，以及有什么期待",_arraySection[2]:@"再分享一些其他的故事",_arraySection[3]:@"可以说说你希望认识什么样的朋友",_arraySection[4]:@""}];
    _cacheImages = [[NSCache alloc] init];
    _arrayModel = [NSMutableArray array];
    _arrayHaveImageIndex = [NSMutableArray array];
    _arrayCacheImgaeKeys = [NSMutableArray array];
    _dicContentModels = [NSMutableDictionary dictionary];
    
    [self moreDescriptionModelsFromDB];
    [self cacheMoreDescriptionModelInDicContent];
    
    [self getImagesInTableLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideAction:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)cacheMoreDescriptionModelInDicContent {
    for (int i = 0; i < _arraySection.count -1; i++) {
        NSString *key = FORMAT(@"%d",i);
        MoreDescriptionModel *model;
        if (_arrayModel.count == 0) {
            model = [self createDescriptionModelForIndex:i];
        } else {
            model = [[MoreDescriptionDao shareInstance] selectMoreDescriptionByUserID:[UserInfo shareInstance].userId andIndex:i];
            if (!model) {
                model = [self createDescriptionModelForIndex:i];
            }
        }
        [_dicContentModels setObject:model forKey:key];
    }
}

- (MoreDescriptionModel *)createDescriptionModelForIndex:(NSInteger) index {
    MoreDescriptionModel *model = [[MoreDescriptionModel alloc] init];
    model.userId = [UserInfo shareInstance].userId;
    model.index = index;
    model.title = _dicHeaderContent[_arraySection[index]];
    return model;
}

- (void)moreDescriptionModelsFromDB {
    NSString *userId = [UserInfo shareInstance].userId;
    NSArray *array = [[MoreDescriptionDao shareInstance] selectMoreDescriptionByUserID:userId];
    if (array.count > 0) {
        [_arrayModel addObjectsFromArray:array];
    }
}

#pragma mark - read Images
- (void)getImagesInTableLocation {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mostContetPath = [[AppData shareInstance] getCacheMostContetnImagePath];
        NSArray *mostContetImagesDocArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mostContetPath error:nil];
        [mostContetImagesDocArray enumerateObjectsUsingBlock:^(NSString *section, NSUInteger idx, BOOL *stop) {
            NSString *sectionPath = [mostContetPath stringByAppendingPathComponent:section];
            NSArray *rowConttArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sectionPath error:nil];
            [rowConttArray enumerateObjectsUsingBlock:^(NSString *row, NSUInteger idx, BOOL *stop) {
//                NSLog(@"indePath Section :%@, row :%@",section, row);
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row.intValue inSection:section.intValue];
                [_arrayHaveImageIndex addObject:indexPath];
            }];
        }];
        [self loadAllSmallImagesInCache];
    });
}

- (void)loadAllSmallImagesInCache {
    [_arrayHaveImageIndex enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [self loadSmallImagesInCachWithIndexPath:indexPath isReload:NO];
    }];
}

- (void)loadSmallImagesInCachWithIndexPath:(NSIndexPath *)indexPath isReload:(BOOL)isReload{
    if (isReload) {////删除之前 对应indexPath里缓存的内容
        NSString *head = FORMAT(@"%ld-%ld-",(long)indexPath.section,(long)indexPath.row);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@",head];
        NSArray *resultArray = [_arrayCacheImgaeKeys filteredArrayUsingPredicate:predicate];
        [resultArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * stop) {
            [_arrayCacheImgaeKeys removeObject:obj];
            [_cacheImages removeObjectForKey:obj];
        }];
    }
    
    NSString *path = [[AppData shareInstance] getCachesSmallImageWithImageIndexPath:indexPath];
    NSArray *imagesName = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    [imagesName enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        NSString *imagePath = [path stringByAppendingPathComponent:name];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        [_cacheImages setObject:image forKey:[self cacheImageKey:indexPath andIndex:idx isReloadTable:NO]];
    }];
}

- (NSString *)cacheImageKey:(NSIndexPath *)indexPath andIndex:(NSInteger)idx isReloadTable:(BOOL)isReload{
    NSString *key = FORMAT(@"%ld-%ld-%ld",(long)indexPath.section,(long)indexPath.row,(long)idx);
    if (!isReload ){
        [_arrayCacheImgaeKeys addObject:key];
    }
    return key;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - customView
-(void)customNavigationBar {
    UIButton *cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut setFrame:CGRectMake(0, 0, 40, 40)];
    [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBut addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBut];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)cancelButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)backAction:(id)sender {
    if (isModifyImages) {
        self.modifyBlock();
    }
    if (isModifyText) {
        self.modifyTextBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction:(id)sender {
    for (MoreDescriptionModel *model in _dicContentModels.allValues) {
        if (model.idKey.length > 0) {
            [[MoreDescriptionDao shareInstance] updateBean:model];
        } else
            [[MoreDescriptionDao shareInstance] insertBean:model];
    }
    if (isModifyImages) {
        self.modifyBlock();
    }
    if (_editType == 0){
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    } else {
        if (isModifyText) {
            self.modifyTextBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Image File Writ
- (void)saveImageToDocument:(UIImage *)image location:(NSIndexPath *)indexPath {
    NSString *_smallImageDocumetPath = [[AppData shareInstance] getCachesSmallImageWithImageIndexPath:indexPath];
    NSString *_bigImageDocumetPath = [[AppData shareInstance] getCachesBigImageWithImageIndexPath:indexPath];
    UIImage *imageSmall = [UITools imageWithImageSimple:image scaledToSize:[self smallSize]];
    NSString *imageName = [AppData random_uuid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *bigImageSavePath = [_bigImageDocumetPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.JPG",imageName]];
        NSString *smallImageSavePath = [_smallImageDocumetPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.JPG",imageName]];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        if ([imageData writeToFile:bigImageSavePath atomically:NO]) {
            //             NSLog(@"存入文件 成功！");
        } else {
            NSLog(@"图片未能存入");
        }
        NSData *smallImageData = UIImageJPEGRepresentation(imageSmall, 1);
        if ([smallImageData writeToFile:smallImageSavePath atomically:NO]) {
            //             NSLog(@"存入文件 成功！");
        } else {
            NSLog(@"图片未能存入");
        }
    });
}

- (void)deleteImageWithName:(NSString *)imageName location:(NSIndexPath *)indexPath {
    NSString *_smallImageDocumetPath = [[AppData shareInstance] getCachesSmallImageWithImageIndexPath:indexPath];
    NSString *_bigImageDocumetPath = [[AppData shareInstance] getCachesBigImageWithImageIndexPath:indexPath];
    NSString *bigImagePath = [_bigImageDocumetPath stringByAppendingPathComponent:imageName];
    NSError *error = nil;
    NSString *smallImagePath = [_smallImageDocumetPath stringByAppendingPathComponent:imageName];
    NSError *smallError = nil;
    if ([[NSFileManager defaultManager] removeItemAtPath:smallImagePath error:&smallError] && [[NSFileManager defaultManager] removeItemAtPath:bigImagePath error:&error]) {

    } else {
        NSLog(@"remove small %@.JPG Error :%@",imageName,smallError.localizedDescription);
        NSLog(@"remove %@.JPG error :%@",imageName,error.localizedDescription);
    }
}

- (CGSize)smallSize {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake((self.view.bounds.size.width) * scale/3, (self.view.bounds.size.width) * scale/3);
    return size;
}

#pragma mark - NSNotificationCenter
- (void)keyboardShowAction:(NSNotification *)notification {
    if (keyboardShow) {
        return ;
    }
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    tableViewFrame = _tableView.frame;
        _tableView.frame = CGRectMake(tableViewFrame.origin.x, tableViewFrame.origin.y, tableViewFrame.size.width, tableViewFrame.size.height - keyboardSize.height);
    if (isEditSectionTitle) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_editingSection] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } else
        [self.tableView scrollToRowAtIndexPath:_editingIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    keyboardShow = YES;
}

- (void)keyboardHideAction:(NSNotification *)sender {
    if (!keyboardShow) {
        return ;
    }
    _tableView.frame = tableViewFrame;
    keyboardShow = NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arraySection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == _arraySection.count -1) {
        return 1;
    } else
        return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section != _arraySection.count -1) {
        return 150;
    } else
        return 90;
//        return [self imageCellHeightForRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, TABLE_HEADER_VIEW_H)];
    CellTextField *textField = [[CellTextField alloc] initWithFrame:CGRectMake(20, (TABLE_HEADER_VIEW_H -30)/2 , self.tableView.bounds.size.width *2/3, 30)];
    textField.section = section;
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleNone;
    textField.text = _dicHeaderContent[_arraySection[section]];
    [view addSubview: textField];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TABLE_HEADER_VIEW_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell ;
    if (indexPath.row == 0) {
        if (indexPath.section == _arraySection.count -1) {
            NSString * const labelCell =@"defaultCell";
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:labelCell];
//            cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"申请Meet记者采编";
            return cell;
        } else {
            NSString *cellIdentifier = @"textViewCell";
            TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[TextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.textView.delegate = self;
            }
            cell.textView.placeholder = _dicPlaceHolder[_arraySection[indexPath.section]];
            cell.textView.indexPath = indexPath;
            MoreDescriptionModel *model = _dicContentModels[FORMAT(@"%ld",(long)indexPath.section)];
            NSString *modelContent = model.content;
            if (modelContent == nil) {
                modelContent = @"";
            }
            cell.textView.text = modelContent;
            return cell;
        }
    } else if (indexPath.row == 1){
        NSString *cellIdentifier = @"addImageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        UIImageView *imageView1 = (UIImageView *)[cell viewWithTag:2];
        UIImageView *imageView2 = (UIImageView *)[cell viewWithTag:3];
        imageView1.image = [_cacheImages objectForKey:[self cacheImageKey:indexPath andIndex:0 isReloadTable:YES]];
        imageView2.image = [_cacheImages objectForKey:[self cacheImageKey:indexPath andIndex:1 isReloadTable:YES]];
        if (imageView1.image != nil || imageView2.image != nil) {
            label.hidden = YES;
            imageView2.hidden = NO;
            imageView1.hidden = NO;
        } else {
            label.hidden = NO;
            imageView2.hidden = YES;
            imageView1.hidden = YES;
        }
    }
    return cell;
}

- (CGFloat)imageCellHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_arrayHaveImageIndex containsObject:indexPath]) {
        return 90;
    } else
        return 50;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    return NO;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[CellTextField class]]) {
        CellTextField *cellTextField = (CellTextField *)textField;
        _editingSection = cellTextField.section;
        isEditSectionTitle = YES;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[CellTextField class]]) {
        CellTextField *cellTextField = (CellTextField *)textField;
        _editingSection = cellTextField.section;
        MoreDescriptionModel *model = _dicContentModels[FORMAT(@"%d",_editingSection)];
        if (![model.title isEqualToString:textField.text]) {
            isModifyText = YES;
            model.title = textField.text;
        }
    }
}

#pragma mark -  UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    isEditSectionTitle = NO;
    if ([textView isKindOfClass:[CellTextView class]]) {
        CellTextView *cellText = (CellTextView *)textView;
        _editingIndexPath = cellText.indexPath;
//         NSLog(@"_editingIndexPat:%d,%d",_editingIndexPath.section,_editingIndexPath.row);
        
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView isKindOfClass:[CellTextView class]]) {
        CellTextView *cellText = (CellTextView *)textView;
        _editingIndexPath = cellText.indexPath;
        MoreDescriptionModel *model = _dicContentModels[FORMAT(@"%d",_editingIndexPath.section)];
        if (![model.content isEqualToString:textView.text]) {
            isModifyText = YES;
            model.content = textView.text;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView isKindOfClass:[CellTextView class]]) {
//        CellTextView *cellText = (CellTextView *)textView;
    
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"puthToMyPhotosVC"]) {
        NSIndexPath *indexPath = [_tableView indexPathForCell:sender];
        MyPhotosViewController *myPhotosVC = (MyPhotosViewController *)[segue destinationViewController];
        myPhotosVC.selectIndexPath = indexPath;
        myPhotosVC.maxIamges = 2;
        myPhotosVC.updateBlock = ^(BOOL modify){
            isModifyImages = YES;
            [self loadSmallImagesInCachWithIndexPath:indexPath isReload:YES];
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        
    }
}


@end
