//
//  NSString+Additions.m
//  YuanGongBao
//
//  Created by Mars on 14-9-16.
//  Copyright (c) 2014年 YiJie. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *)capitalizedFirstLetter
{
    if (self.length>0) {
        NSString* first = [self substringToIndex:1];
        NSString* firstUp = [first uppercaseString];
        return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstUp];
    } else {
        return [self copy];
    }
    
}

/**
 * 去除字符串左右的空格
 */
-(NSString *)omitSpace
{
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return str;
}



- (BOOL)has_yjFlag
{
    NSArray *contents = [self componentsSeparatedByString:@"@@"];

    if (contents.count < 3)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (NSString *)remove_yjFlag
{
    if ([self has_yjFlag])
    {
        return [self stringByReplacingOccurrencesOfString:@"@@" withString:@""];
    }
    else
    {
        return self;
    }
}

- (NSArray *)yj_Attributes
{
    NSArray *contents = [self componentsSeparatedByString:@"@@"];

    if (contents.count < 3)
    {
        return nil;
    }
    else
    {
        NSString * expression = @"(@@.*?@@)"; //_message = @"您输入的企业码为@@noa@h001@@，即将加入@@阳@光城@@理财专区。";

        NSError * error = NULL;
        NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];

        NSArray * matches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];

        NSMutableArray *attributes = [[NSMutableArray alloc] init];

        [matches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             NSTextCheckingResult * match = (NSTextCheckingResult *)obj;
             NSRange range = NSMakeRange(match.range.location - 4 * idx, match.range.length - 4);

             [attributes addObject:[NSValue valueWithRange:range]];
         }];

        return attributes;
    }
}

#pragma mark formatter Mehtods

-(NSString *)formatStringWithOutDecimal
{
    NSString *decimal = self;
    
    NSArray *array = [NSArray seperateArrayWithString:decimal byString:@"."];

    decimal = array[0];
    
    return decimal;
    
}

-(NSString *)formatSymbolString:(NSString *)symbol
{
    NSString *symbolString = self;
    
    NSArray *array = [NSArray seperateArrayWithString:symbolString byString:symbolString];
    
    if (array.count>1) {
        
        symbolString = array[1];

    }
    
    return symbolString;
}

/**
 *  格式化手机号码
 */
-(NSString *)formatPhone
{
    NSString *phone =  self;
    
    phone = [self formatFromPhone];
    NSRange range = NSMakeRange(0,3);
    NSRange range1 = NSMakeRange(3, 4);
    
    if (self.length>3 && self.length <= 7) {
        
        phone = [NSString stringWithFormat:@"%@ %@",[self substringWithRange:range],[self substringFromIndex:3]];
    }
    else if (self.length>7 && self.length <= 11)
    {
        phone = [NSString stringWithFormat:@"%@ %@ %@",[self substringWithRange:range],[self substringWithRange:range1],[self substringFromIndex:7]];
    }
    
    return phone;
}

-(NSString *)formatTelePhone
{
    NSString *formateTelePhone = self;
    
    if (formateTelePhone.length > 3) {
        NSRange range = NSMakeRange(0, 3);
        formateTelePhone = [NSString stringWithFormat:@"%@-%@",[self substringWithRange:range],[self substringFromIndex:3]];
    }
    
    return formateTelePhone;
}

-(NSString *)formatCharatersPhone
{
    NSString *formateTelePhone = self;
    
    if (formateTelePhone.length > 7) {
        
        NSRange range = NSMakeRange(3, 4);
        formateTelePhone = [formateTelePhone stringByReplacingCharactersInRange:range withString:@"****"];
    }
    
    return formateTelePhone;
}

/**
 * formatFromPhone
 */
-(NSString *)formatFromPhone
{
    NSString *formateFromPhone = self;
    NSRange range = [self rangeOfString:@"-"];
    NSRange range1 = [self rangeOfString:@" "];
    if (range.location != NSNotFound) {
        //有横杆
        formateFromPhone = [formateFromPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    else if (range1.location != NSNotFound) {
        
        formateFromPhone = [formateFromPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
        
    }
    else if ([self hasPrefix:@"+86 "]) {
        
        formateFromPhone = [formateFromPhone substringFromIndex:4];
    }
    
    return formateFromPhone;
}

-(NSString *)formatBankCard
{
    NSString *formatBank = self;
    NSRange range1 = NSMakeRange(0, 4);
    NSRange range2 = NSMakeRange(4, 4);
    NSRange range3 = NSMakeRange(8, 4);
    NSRange range4 = NSMakeRange(12, 4);
    
    formatBank  = [self formatFromBankCard];
    
    if (self.length>4 && self.length <= 8) {
        
        formatBank = [NSString stringWithFormat:@"%@ %@",[self substringWithRange:range1],[self substringFromIndex:4]];
    }
    else if (self.length>8 && self.length <= 12)
    {
        formatBank = [NSString stringWithFormat:@"%@ %@ %@",[self substringWithRange:range1],[self substringWithRange:range2],[self substringFromIndex:8]];
    }
    else if(self.length>12 && self.length <= 16){
        
        formatBank = [NSString stringWithFormat:@"%@ %@ %@ %@",[self substringWithRange:range1],[self substringWithRange:range2],[self substringWithRange:range3],[self substringFromIndex:12]];
        
    }
    else if(self.length > 16){
        
        formatBank = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",[self substringWithRange:range1],[self substringWithRange:range2],[self substringWithRange:range3],[self substringWithRange:range4],[self substringFromIndex:16]];
    }
    
    return formatBank;
}

/**
 *  去除银行卡号中的空格
 */
-(NSString *)formatFromBankCard
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (NSString *)stringByReplacingOccurrencesOfCharactersInSet:(NSCharacterSet *)characterSet withString:(NSString *)string
{
    NSArray* words = [self componentsSeparatedByCharactersInSet:characterSet];
    NSString *leftString = [words componentsJoinedByString:@""];
    return leftString;
}

#pragma mark ValidString

- (BOOL)isValidEmail
{
    return ([self rangeOfString:@"@"].location != NSNotFound && [self rangeOfString:@"@"].location > 0 && self.length > [self rangeOfString:@"@"].location + 1);
}

- (BOOL)isValidPhone
{
    NSString *phoneRegex = @"1[0-9]{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)isValidPassword
{
    if (self.length<6 || self.length>20) {
        return NO;
    }
    
    BOOL hasAlpha = NO;
    BOOL hasDigit = NO;
    BOOL hasSpecialChar = NO;
    const char *cString = [self cStringUsingEncoding:NSUTF8StringEncoding];
    for (int i=0; i<self.length; ++i) {
        if (isalpha(cString[i])) {
            hasAlpha = YES;
        } else if (isdigit(cString[i])) {
            hasDigit = YES;
        } else {
            hasSpecialChar = YES;
        }
    }
    
    BOOL isPasswordValid = hasAlpha+hasDigit+hasSpecialChar>=2;
    
    return isPasswordValid;
}

- (BOOL)isValidAccount
{
    BOOL isAccountValid = [self isValidEmail] || [self isValidPhone];
    return isAccountValid;
}

- (BOOL)isValidIdentificationNo
{
    if (self.length != 18)
    {
        return NO;
    }
    
    NSString *identificationNoRegex = @"[0-9]{17}([0-9]|x|X)";
    NSPredicate *identificationNoTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", identificationNoRegex];
    return [identificationNoTest evaluateWithObject:self];
}

-(BOOL)isValidVerifyNum
{
    if (self.length != 6)
    {
        return NO;
    }
    
    NSString *identificationNoRegex = @"\\d{6}$";
    NSPredicate *identificationNoTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", identificationNoRegex];
    return [identificationNoTest evaluateWithObject:self];
}

-(BOOL)isValidateAlphabet
{
    NSString *identificationRegex = @"^[a-zA-Z]+$";
    NSPredicate *identificationNoTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", identificationRegex];
    return [identificationNoTest evaluateWithObject:self];
}

- (NSDictionary *)formatURLParameterDictionary {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (self.length && [self rangeOfString:@"="].location != NSNotFound) {
        NSArray *keyValuePairs = [self componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in keyValuePairs) {
            NSArray *pair = [keyValuePair componentsSeparatedByString:@"="];
            // don't assume we actually got a real key=value pair. start by assuming we only got @[key] before checking count
            NSString *paramValue = pair.count == 2 ? pair[1] : @"";
            // CFURLCreateStringByReplacingPercentEscapesUsingEncoding may return NULL
            parameters[[pair[0] lowercaseString]] = [paramValue formatURLDecodedString] ?: @"";
        }
    }
    return parameters;
}

- (NSString *)formatURLDecodedString {
    NSString *input =[self stringByReplacingOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, self.length)];
    return [input stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
