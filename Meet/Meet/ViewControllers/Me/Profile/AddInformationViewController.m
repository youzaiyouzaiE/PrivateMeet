//
//  AddInformationViewController.m
//  Meet
//
//  Created by jiahui on 16/5/5.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "AddInformationViewController.h"
#import "LabelAndTextFieldCell.h"
#import "CellTextField.h"
#import "LabelTableViewCell.h"

@interface AddInformationViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate> {
    NSMutableDictionary *_dicValues;
}

@end

@implementation AddInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dicValues = [NSMutableDictionary dictionary];
    NSString *str;
    if (_viewType == ViewTypeEdit) {
        str = @"编辑";
    } else if (_viewType == ViewTypeAdd) {
         str = @"添加";
    }
    if (_indexPath.section == 1 ) {////work
        _navTitle = [str stringByAppendingString:@"工作经历"];
        _arrayTitles = @[@"公司",@"职位"];
    } else if (_indexPath.section == 3) {
        _navTitle = [str stringByAppendingString:@"教育背景"];
        _arrayTitles = @[@"学校",@"专业",@"学历"];
    }
    self.navigationItem.title = _navTitle;
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];
    [UITools navigationRightBarButtonForController:self action:@selector(saveAction:) normalTitle:@"保存" selectedTitle:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction:(id)sender {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_viewType == ViewTypeAdd) {
        return _arrayTitles.count;
    } else
        return _arrayTitles.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayTitles.count) {
        return 120;
    }
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayTitles.count) {
        LabelTableViewCell *cell = (LabelTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"LabelTableViewCell" owner:self options:nil][0];
        [cell labeAddLayerMargin:YES andSetLabelText:@"删除"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        NSString *cellIdentifier = @"profileTextFieldCell";
        LabelAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = (LabelAndTextFieldCell *)[[[NSBundle mainBundle] loadNibNamed:@"LabelAndTextFieldCell" owner:self options:nil] objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textField.delegate = self;
        }
        cell.titelLabel.text = _arrayTitles[indexPath.row];
        cell.textField.indexPath = indexPath;
        cell.textField.placeholder = _arrayTitles[indexPath.row];
            return cell;
    }
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    NSInteger row = indexPath.row;
    NSString *dictionKey = @"key";
    dictionKey = _arrayTitles[row];
    _dicValues[dictionKey] = textfield.text;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
