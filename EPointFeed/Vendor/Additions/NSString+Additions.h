//
//  NSString+Additions.h
//  JY
//
//  Created by Mars on 14-9-16.
//  Copyright (c) 2014年 YiJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+Additions.h"

@interface NSString (Additions)

- (NSString *)capitalizedFirstLetter;
- (NSString *)omitSpace;

- (NSString *)formatPhone;
- (NSString *)formatFromPhone;

- (NSString *)formatTelePhone;

- (NSString *)formatBankCard;

- (NSString *)formatCharatersPhone;

- (NSString *)formatFromBankCard;

- (NSString *)formatStringWithOutDecimal;

- (NSString *)formatSymbolString:(NSString *)symbol;

- (NSString *)stringByReplacingOccurrencesOfCharactersInSet:(NSCharacterSet *)characterSet withString:(NSString *)string;

- (BOOL)has_yjFlag;
- (NSString *)remove_yjFlag; // 替换@@
- (NSArray *)yj_Attributes; // 返回的range 是没有@@时的位置

- (BOOL)isValidEmail;

- (BOOL)isValidPhone;

- (BOOL)isValidPassword;

- (BOOL)isValidAccount;

- (BOOL)isValidIdentificationNo;

- (BOOL)isValidVerifyNum;

- (BOOL)isValidateAlphabet;

- (NSDictionary *)formatURLParameterDictionary;

@end
