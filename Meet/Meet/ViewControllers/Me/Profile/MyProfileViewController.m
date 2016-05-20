//
//  MyProfileViewController.m
//  Meet
//
//  Created by jiahui on 16/4/30.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MyProfileViewController.h"
#import "CellTextField.h"
#import "LabelAndTextFieldCell.h"
#import "TextViewCell.h"
//#import "CellPlaceHolderTextView.h"
#import "MoreProfileViewController.h"
#import "AddInformationViewController.h"
#import "AddStarViewController.h"
#import "NetWorkObject.h"
#import "UISheetView.h"
#import "UserInfoDao.h"

typedef NS_ENUM(NSUInteger, SectonContentType) {
    SectionProfile,
    SectionWoerkExperience,
    SectionOccupation,///职业
    SectionEducateExp,//教育
    SectionPrivate,///个人亮点
    SectionMore,//更多
};

typedef NS_ENUM(NSUInteger, RowType) {
    RowHeadImage,
    RowName,
    RowSex,
    RowBirthday,
    RowHeight,
    RowPhoneNumber,
    RowWX_Id,
    RowWorkLocation,
    RowYearIncome,
    RowState,
    RowHome,
    RowConstellation,
};

@interface MyProfileViewController () <UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UISheetViewDelegate,UIAlertViewDelegate> {
    NSArray *_titleContentArray;
    
    __weak IBOutlet UIView *_chooseView;
    __weak IBOutlet UIView *_bottomPickerView;
    __weak IBOutlet UIDatePicker *_datePicker;
    __weak IBOutlet UIPickerView *_picker;

    
    NSArray *_arraySexPick;////2
    NSMutableArray *_arrayHeightPick;/////4
    NSMutableArray *_arrayWorkLocationPick;////7
    NSArray *_arrayIncomePick;/////8
    NSArray *_arrayLovedPick;/////9
    NSArray *_arrayConstellationPick;////10
    
    
    
    NSIndexPath *_selectIndexParth;////当前选择的位置
    NSInteger _pickerSelectRow;
    
    NSMutableDictionary *_dicValues;////////tableView内容数据缓存 Key为对应的Title Value为用户填入的结果
    NSMutableDictionary *_dicPickSelectValues;////保存pickView对应的位置 ，value为pickView所选的位置，key为对应的title字符串
    
    
    NSMutableArray *_arrayWorkExper;///工作经历
    NSMutableArray *_arrayOccupationLable;///职业标签
    NSMutableArray *_arrayEducateExper;///教育背景
    
    UISheetView *_sheetView;
    UIAlertView *_sexAlertView;
    
    BOOL _isNotSelectHeight;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;
@property (strong, nonatomic) NSMutableArray *photos;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人信息";
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];
    [UITools navigationRightBarButtonForController:self action:@selector(saveAction:) normalTitle:@"保存" selectedTitle:nil];
    _titleContentArray = @[@"头像",@"真实姓名",@"性别",@"出生日期",@"身高",@"手机号",@"微信号",@"工作生活城市",@"年收入",@"情感状态",@"家乡",@"星座"];
    _dicValues = [NSMutableDictionary dictionary];
    _dicPickSelectValues = [NSMutableDictionary dictionary];
//    _arrayWorkExper = [NSMutableArray array];
    _arrayWorkExper = [NSMutableArray arrayWithArray:@[@"产品总监 - 面包旅行",@"产品经理 - 百度"]];
    _arrayOccupationLable = [NSMutableArray arrayWithArray:@[@"产品总监, 产品经理 "]];
    _arrayEducateExper = [NSMutableArray arrayWithArray:@[@"哈尔滨工业大学 - 电子商务 - 本科 ",@"光山县第三高级中学 - 高中"]];
    
    _arraySexPick = @[@"男",@"女"];
    _arrayHeightPick = [NSMutableArray arrayWithObject:@"150CM以下"];
    for (int i = 150; i <= 190; i++) {
      NSString *str = FORMAT(@"%dcm",i);
        [_arrayHeightPick addObject:str];
    }
    [_arrayHeightPick addObject:@"190以上"];
    _arrayIncomePick = @[@"10W以下",@"10W-20w",@"20W-30w",@"30W-50w",@"50W-100w",@"100W以上"];
    _arrayLovedPick = @[@"单身并享受单身的状态",@"单身但渴望找到另一半",@"已有男女朋友，但未婚",@"已婚",@"离异，寻觅中",@"丧偶，寻觅中"];
    _arrayConstellationPick = @[@"水平座",@"双鱼座",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座"];
    
    _chooseView.hidden = YES;
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.maximumDate = [NSDate  date];
    _picker.backgroundColor = [UIColor whiteColor];
    
    
    if (_isFristLogin) {
        [self downLoadUserWeChatImage];
    }
    [self mappingDicValue];
}

- (void)mappingDicValue{
 
    UIImage *image = [UIImage imageWithContentsOfFile:[self imageSaveParth]];
    _dicValues[_titleContentArray[0]] = image;
    _dicValues[_titleContentArray[1]] = [UserInfo shareInstance].name;
    _dicValues[_titleContentArray[2]] = [UserInfo shareInstance].sex.intValue == 1 ? @"男":@"女" ;
}

- (NSString *)imageSaveParth {
    NSString *saveFilePath = [AppData getCachesDirectoryUserInfoDocumetPathDocument:@"headimg"];
    NSString *saveImagePath = [saveFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"0.JPG"]];
    return saveImagePath;
}

- (void)downLoadUserWeChatImage {
    [NetWorkObject downloadTask:[UserInfo shareInstance].headimgurl progress:^(NSProgress *downloadProgress) {
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath.path);
        UIImage *image = [UIImage imageWithContentsOfFile:filePath.path];
        NSData *imgData = UIImageJPEGRepresentation(image, 1);
        NSString *saveImagePath = [self imageSaveParth];
        if ([imgData writeToFile:[self imageSaveParth] atomically:NO]) {
            NSError *error;
            if (![[NSFileManager defaultManager] removeItemAtPath:filePath.path error:&error]) {
                 NSLog(@"error :%@",error.localizedDescription);
            }
            [self reloadUerImage:saveImagePath];
        } else {
        
        }
    }];
}

- (void)reloadUerImage:(NSString *)imagePath {
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (image) {
        _dicValues[_titleContentArray[0]] = image;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    _bottomViewConstraint.constant = - 300;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data
- (NSArray *)setPickerViewContentArray:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == RowSex) {
        return _arraySexPick;
    } else if (row == RowHeight) {
        return _arrayHeightPick;
    } else if (row == RowWorkLocation || row == RowHome) {
        return _arrayWorkLocationPick;
    } else if (row == RowYearIncome) {
        return _arrayIncomePick;
    } else if (row == RowState) {
        return _arrayLovedPick;
    } else if (row == RowConstellation) {
        return _arrayConstellationPick;
    }
    return nil;
}

#pragma mark - Action
- (void)backAction:(id)sender {
    if (_isFristLogin) {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:FRIST_LOGIN_NOTIFICATION_Key object:nil];
        }];
        
    } else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction:(id)sender {
    if (_selectIndexParth.section == 0 && _selectIndexParth.row == 2) {////Sex Item
        [self sexItemModify];
        return ;
    }
}

- (IBAction)tapGestureRecognizer:(UITapGestureRecognizer *)sender {
    if (_selectIndexParth.section == 0 && _selectIndexParth.row == 2) {////Sex Item
        [self sexItemModify];
        return ;
    }
    [self mappingPickContentInDic];
    [self showChooseViewAnimation:NO];
}

- (IBAction)cancelAction:(id)sender {
    [self showChooseViewAnimation:NO];
}

- (IBAction)tureButtonAction:(id)sender {
    [self mappingPickContentInDic];
    [self showChooseViewAnimation:NO];
}

- (void)mappingPickContentInDic {
    NSString *key = _titleContentArray[_selectIndexParth.row];
    if (_datePicker.hidden) {
        NSString *result = [self setPickerViewContentArray:_selectIndexParth][_pickerSelectRow];
        _dicValues[key] = result;
        [_dicPickSelectValues setObject:[NSNumber numberWithInt:_pickerSelectRow] forKey:key];
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDate *date = _datePicker.date;
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormat stringFromDate:date];
        _dicValues[key] = strDate;
    }
}

- (void)hiddenDatePicker:(BOOL)hidden {
    if (hidden) {
        _datePicker.hidden = YES;
        _picker.hidden = NO;
        [_picker reloadAllComponents];
    } else {
        _datePicker.hidden = NO;
        _picker.hidden = YES;
    }
}

- (void)showChooseViewAnimation:(BOOL)show {
    if (show) {
        _bottomViewConstraint.constant = 0;
    } else {
        _bottomViewConstraint.constant = -250;
    }
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState |   UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                             [_bottomPickerView layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             if (show) {
                                 _chooseView.hidden = NO;
                             } else {
                                 _chooseView.hidden = YES;
                                 [self.tableView reloadRowsAtIndexPaths:@[_selectIndexParth] withRowAnimation:UITableViewRowAnimationNone];
                             }
                         }];
}

- (void)sexItemModify {
    if (![UserInfo shareInstance].modifySex) {
        if (!_sexAlertView) {
            _sexAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"reminder", @"") message:NSLocalizedString(@"Once confirm the gender，you can't change any more！", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"")  otherButtonTitles:NSLocalizedString(@"Ok", @"") , nil];
        }
        [_sexAlertView show];
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == _sexAlertView) {
        if (buttonIndex == 1) {
            [UserInfo shareInstance].modifySex = 1;
            [[UserInfoDao shareInstance] updateBean:[UserInfo shareInstance]];
            [self mappingPickContentInDic];
            [self showChooseViewAnimation:NO];
        } else {
            
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    return NO;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self setPickerViewContentArray:_selectIndexParth].count;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return (NSString *)[self setPickerViewContentArray:_selectIndexParth][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _pickerSelectRow = row;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return  @"工作经历";
    } if (section == 2) {
        return  @"职业标签";
    } if (section == 3) {
        return  @"教育背景";
    } if (section == 4) {
        return  @"您的个人亮点";
    } if (section == 5) {
        return  @"更多个人介绍";
    } 
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _titleContentArray.count;
    } else if( section == 1) {
        return _arrayWorkExper.count + 1;
    } else if (section == 2) {
        return  _arrayOccupationLable.count+ 1;
    } else if (section == 3) {
        return  _arrayEducateExper.count+ 1;
    }else if (section == 4 || section == 5) {
        return  1;
    }
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 82;
        } else
            return 49;
    } else if (indexPath.section == 4 || indexPath.section == 5) {
        return 90;
    }
        return 49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && row == 0) {
        NSString *const cellIdentifier = @"profileImageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
        imageView.layer.cornerRadius = imageView.bounds.size.width/2;
        imageView.layer.masksToBounds = YES;
        _dicValues[_titleContentArray[0]] ? (imageView.image = _dicValues[_titleContentArray[0]]) :(imageView.image = [UIImage imageNamed:@"RadarKeyboard_HL"]) ;
        return cell;
    } else if(section == 0) {
        if (row == RowName || row == RowPhoneNumber || row == RowWX_Id) {
            NSString *cellIdentifier = @"profileTextFieldCell";
            LabelAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = (LabelAndTextFieldCell *)[[[NSBundle mainBundle] loadNibNamed:@"LabelAndTextFieldCell" owner:self options:nil] objectAtIndex:0];
                cell.textField.delegate = self;
            }
            cell.titelLabel.text = _titleContentArray[row];
            cell.textField.placeholder = _titleContentArray[row];
             cell.textField.indexPath = indexPath;
            cell.textField.text = _dicValues[_titleContentArray[row]];
            return  cell;
        } else {
            NSString *cellIdentifier = @"profileLabelCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *titlLabel = (UILabel *)[cell viewWithTag:1];
            titlLabel.text = _titleContentArray[row];
            UILabel *contentLabel = (UILabel *)[cell viewWithTag:2];
            contentLabel.text = _dicValues[_titleContentArray[row]];
            return  cell;
        }
    } else if (section == 1 || section == 2 || section == 3) {
        NSString * const labelCell =@"defaultCell";
        cell = [tableView dequeueReusableCellWithIdentifier:labelCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:labelCell];
            cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        }
        if (section == 1) {
            if (row < _arrayWorkExper.count) {
                cell.textLabel.text = _arrayWorkExper[row];
                cell.imageView.image = nil;
            } else {
                cell.imageView.image = [UIImage imageNamed:@"imageAdd"];
                cell.textLabel.text =  @"添加工作经历";
            }
        } else if(section == 2) {
            if (row < _arrayOccupationLable.count) {
                cell.textLabel.text = _arrayOccupationLable[row];
                cell.imageView.image = nil;
            } else {
                cell.imageView.image = [UIImage imageNamed:@"imageAdd"];
                cell.textLabel.text =  @"添加职业标签";
            }
        } else if (section == 3) {
            if (row < _arrayEducateExper.count) {
                cell.textLabel.text = _arrayEducateExper[row];
                cell.imageView.image = nil;
            } else {
                cell.imageView.image = [UIImage imageNamed:@"imageAdd"];
                cell.textLabel.text =  @"添加教育背景";
            }
        }
//        NSLog(@"defaultCell section: %d",section);
        return cell;
    } else if (section == 4 || section == 5) {
        NSString *cellIdentifier = @"textViewCell";
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[TextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textView.delegate = self;
        }
        if (section == 4) {
            cell.textView.placeholder = @"空空如也～";
        } else if (section == 5) {
            cell.textView.placeholder = @"空空如也～";
        }
        cell.textView.indexPath = indexPath;
//         NSLog(@"textViewCell section: %d",section);
        return cell;
    }
    return  cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 2 && [UserInfo shareInstance].modifySex) {////Sex Item
        return ;
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    _selectIndexParth = indexPath;
    if (section == 0) {
        if (row == 0) {
            if ( !_sheetView) {
                _sheetView = [[UISheetView alloc] initWithContenArray:@[@"拍照",@"相册选择",@"取消"]];
                _sheetView.delegate = self;
            }
            [_sheetView show];
        } else if (row == RowBirthday) {/////date picker
            [self.view endEditing:YES];
            [self hiddenDatePicker:NO];
            [self showChooseViewAnimation:YES];
        } else if (row == RowSex || row == RowHeight || row == RowWorkLocation || row == RowYearIncome || row == RowState || row == RowHome || row == RowConstellation) {////_pickView
            [self.view endEditing:YES];
            NSInteger value = [_dicPickSelectValues[_titleContentArray[_selectIndexParth.row]] intValue];
            _pickerSelectRow = value;
            if (row == RowHeight && value == 0 && !_isNotSelectHeight) {
                value = 26;
                _pickerSelectRow = 26;
                [_dicPickSelectValues setObject:[NSNumber numberWithInt:value] forKey:_titleContentArray[_selectIndexParth.row]];
                _isNotSelectHeight = YES;
            }
            [self hiddenDatePicker:YES];
            [self showChooseViewAnimation:YES];
            [_picker selectRow:value inComponent:0 animated:NO];
        }
    } else if(section == 1 || section == 3 ) {
        [self performSegueWithIdentifier:@"pushToAddInformationVC" sender:self];
    }
}

#pragma mark - UISheetViewDelegate 
- (void)sheetView:(UISheetView *)sheet didSelectRowAtIndex:(NSInteger)index {
    switch (index) {
        case 0: //照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            imagePicker.mediaTypes = mediaTypes;
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        }
        case 1: //相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            imagePicker.mediaTypes = mediaTypes;
            imagePicker.allowsEditing = YES;
            imagePicker.navigationBar.tintColor = [UIColor whiteColor];
            imagePicker.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
           [imagePicker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
    [_sheetView hidden];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        ///头像上传后再保存到本地 刷新
//    });
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *saveImagePath = [self imageSaveParth];
    if ([imageData writeToFile:saveImagePath atomically:NO]) {
//        NSLog(@"保存 成功");
    }
    
    [self.navigationController dismissViewControllerAnimated: YES completion:^{
        [self reloadUerImage:saveImagePath];
        if (_isFristLogin) {
            
        } else
            self.block(YES, NO);
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [textField setReturnKeyType:UIReturnKeyDone];
    CellTextField *cellTextField = nil;
    if ([textField isKindOfClass:[CellTextField class]]) {
        cellTextField = (CellTextField *)textField;
        NSIndexPath *indexPath = cellTextField.indexPath;
        if ((indexPath.section == 0) && (indexPath.row == 4 || indexPath.row == 5 )) {
            [textField setKeyboardType:UIKeyboardTypeNumberPad];
            return  YES;
        } else {
            [textField setKeyboardType:UIKeyboardTypeDefault];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    CellTextField *cellTextField = nil;
    if ([textField isKindOfClass:[CellTextField class]]) {
        cellTextField = (CellTextField *)textField;
        [self mappingTextFieldDictionary:cellTextField];
    }
    return YES;
}

- (void)mappingTextFieldDictionary:(CellTextField *)textfield {
    if (textfield.text == nil || [textfield.text isEqualToString:@""]) {
        return ;
    }
    NSIndexPath *indexPath = textfield.indexPath;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *dictionKey = @"key";
    if (section == 0) {
        dictionKey = _titleContentArray[row];
    }
    _dicValues[dictionKey] = textfield.text;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView isKindOfClass:[CellTextView class]]) {
        CellTextView *cellTextView = (CellTextView *)textView;
        NSIndexPath *indexPath = cellTextView.indexPath;
        if (indexPath.section == 5) {
            [self performSegueWithIdentifier:@"ModalToMoreProfile" sender:self];
            return NO;
        } else if(indexPath.section == 4) {
            [self performSegueWithIdentifier:@"ModalToStarVC" sender:self];
            return  NO;
        }
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToAddInformationVC"]) {
        AddInformationViewController *addInfom = (AddInformationViewController *)[segue destinationViewController];
        addInfom.indexPath = _selectIndexParth;
        if ( _selectIndexParth.row == _arrayWorkExper.count || _selectIndexParth.row == _arrayEducateExper.count ) {
            addInfom.viewType = ViewTypeAdd;
        } else {
            addInfom.viewType = ViewTypeEdit;
        }
    } else if ([segue.identifier isEqualToString:@"ModalToStarVC"]) {
//        AddStarViewController *starVC = (AddStarViewController *)[segue destinationViewController];
    } else if ([segue.identifier isEqualToString:@"ModalToMoreProfile"]) {
//        MoreProfileViewController *moreVC = (MoreProfileViewController *)[segue destinationViewController];
//        moreVC.modifyBlock = ^(){
////            [self checkDocumentGetSmallImages];
//        };
    }
}

@end
