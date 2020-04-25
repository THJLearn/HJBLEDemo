//
//  Tool.m
//  HJBLEDemo
//
//  Created by 赵优路 on 2020/4/25.
//  Copyright © 2020 thj. All rights reserved.
//

#import "Tool.h"

@implementation Tool
- (NSData *)getBattery {
    Byte value[3]={0};
    value[0]= 0x1B;
    value[1]= 0x99;
    value[2]= 0x01;
    NSData * data = [NSData dataWithBytes:&value length:sizeof(value)];
    return data;
}
//字符串转data
- (NSData*)hexToBytes:(NSString *)str
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
@end
