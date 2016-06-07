//
//  NSString+BKJSONDictionary.m
//  EPointFeed
//
//  Created by 俊王 on 16/5/12.
//  Copyright © 2016年 EB. All rights reserved.
//

#import "NSString+BKJSONDictionary.h"

@implementation NSString (BKJSONDictionary)

+(instancetype)dictionaryjsonSerializationToString:(NSDictionary *)jsonDic
{
    NSError *error = nil;
    //NSJSONWritingPrettyPrinted:指定生成的JSON数据应使用空格旨在使输出更加可读。如果这个选项是没有设置,最紧凑的可能生成JSON表示。
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&error];
    
    id jsonString = nil;
    if ([jsonData length] > 0 && error == nil){
        //NSData转换为String
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON String = %@", jsonString);
    }
    
    return jsonString;
}

@end
