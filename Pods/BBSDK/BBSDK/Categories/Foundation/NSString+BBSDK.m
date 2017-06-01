//
//  NSString+BBSDK.m
//  BBSDK
//
//  Created by Dongjw on 17/5/11.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#import <ImageIO/ImageIO.h>

#import "NSArray+BBSDK.h"
#import "NSString+BBSDK.h"

@implementation NSString (BBSDK)

#pragma mark - Emoji
+ (NSMutableAttributedString *)noEmojiString:(NSString *)string
{
    NSString *emojiPathStr =  [[NSBundle mainBundle]pathForResource:@"emoji" ofType:@".plist"];
    NSArray *face =  [NSArray arrayWithContentsOfFile:emojiPathStr];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string];
    
    //2、通过正则表达式来匹配字符串
    
    NSString*regex_emoji =@"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]";//匹配表情
    
    NSError*error =nil;
    
    NSRegularExpression *re =[NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    
    if(!re) {
        
        NSLog(@"%@", [error localizedDescription]);
        //        return attributeString;
    }
    
    NSArray *resultArray = [re matchesInString:string options:(NSMatchingReportCompletion) range:NSMakeRange(0, string.length)];
    
    //根据匹配范围来用图片进行相应的替换
    NSMutableArray*imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [string substringWithRange:range];
        for(int i =0; i < face.count; i ++) {
            if([face[i][@"cht"]isEqualToString:subStr]) {
                //face[i][@"png"]就是我们要加载的图片
                //新建文字附件来存放我们的图片,iOS7才新加的对象
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];//给附件添加图片
                textAttachment.image= [UIImage imageNamed:face[i][@"png"]];
                
                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                
                textAttachment.bounds=CGRectMake(0, -8, textAttachment.image.size.width, textAttachment.image.size.height);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString*imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary*imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                
                [imageDic setObject:imageStr forKey:@"image"];
                
                [imageDic setObject:[NSValue valueWithRange:range]forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
                
            }
        }
    }
    
    
    for(int i = (int)imageArray.count-1; i >=0; i--) {
        
        NSRange range;
        
        [imageArray[i][@"range"]getValue:&range];
        
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    return attributeString;
}





//将带有emoji表情的字符串分割，判断是否是emoji 是改成表情
+(NSString *)stringWithUnicodeToEmoji:(NSString *)mutableString {
    if (mutableString==nil) {
        return @"";
    }
    NSMutableArray *loc = @[].mutableCopy;
    NSMutableArray *end = @[].mutableCopy;
    
    NSRange range = [mutableString rangeOfString:@"[emoji:"];
    if(range.location == NSNotFound){
        return  mutableString;
    }
    
    //记录每一个emoji里面：后面的起点和]的位置
    for (NSUInteger i=0; i<mutableString.length - 7; i++) {
        NSString *s = [mutableString substringWithRange:NSMakeRange(i, 7)];
        if ([s isEqualToString:@"[emoji:"]) {
            //                NSLog(@"%d",i);
            [loc addObject:[NSNumber numberWithUnsignedInteger:i + 7]];
        }
    }
    for (int i=0; i<mutableString.length ; i++) {
        NSString *s = [mutableString substringWithRange:NSMakeRange(i, 1)];
        if ([s isEqualToString:@"]"]) {
            [end addObject:[NSNumber numberWithUnsignedInteger:i]];
            //            NSLog(@"%d",i);
        }
    }
    
    
    //删除多余不匹配的后缀
    if ([end count] != [loc count]) {
        for (int i = 0; i < [loc count]; i++) {
            for (int j = i+1; j < [end count]; j++) {
                if ([[loc safeObjectAtIndex:i] unsignedIntegerValue] < [[end safeObjectAtIndex:j] unsignedIntegerValue] && [[loc safeObjectAtIndex:i+1] unsignedIntegerValue] > [[end safeObjectAtIndex:j] unsignedIntegerValue]) {
                    [end removeObjectAtIndex:j];
                    j--;
                }
            }
        }
    }
    
    //删除多余的前缀
    if ([end count] != [loc count]) {
        for(int i = 0; i < [loc count]; i++){
            if(([[loc safeObjectAtIndex:i] unsignedIntegerValue] + 8) < [mutableString length]){
                NSRange range1 = NSMakeRange([[loc safeObjectAtIndex:i] unsignedIntegerValue] + 8, 1);
                NSString *str1 = [mutableString substringWithRange:range1];
                if (![str1 isEqualToString:@"]"]) {
                    [loc removeObjectAtIndex:i];
                }
            }else{
                [loc removeObjectAtIndex:i];
            }
        }
    }
    
    //将需要变化的编码加入到初始字符串，然后分割为四个长度并插入\\ud的字符串，最好再合成对应的字符串
    NSMutableArray *initialRepleaceStr = @[].mutableCopy;
    NSMutableArray *divisionRepleaceStr = @[].mutableCopy;
    NSMutableArray *finalRepleaceStr = @[].mutableCopy;
    
    for (int  i= 0; i<loc.count; i++) {
        NSRange range = NSMakeRange([[loc safeObjectAtIndex:i] unsignedIntegerValue],[[end safeObjectAtIndex:i] unsignedIntegerValue]- [[loc safeObjectAtIndex:i] unsignedIntegerValue]);
        NSString *str = [mutableString substringWithRange:range];
        //每隔四个插入一个\\u
        for (int i = 0 ; i < [str length]/4; i++) {
            int loc = i*4;
            NSString *temp = [str substringWithRange:NSMakeRange(loc, 4)];
            NSString *str = [NSString stringWithFormat:@"\\u%@",temp];
            
            [divisionRepleaceStr addObject:str];
        }
        [initialRepleaceStr addObject:str];
        
    }
    //将分割之后的字符串合并
    NSString *strEmoji = [[NSString alloc]init];
    int tag = 0;
    for (int i = 0; i < [divisionRepleaceStr count]; i++) {
        
        unsigned long countOfElement= [[initialRepleaceStr safeObjectAtIndex:tag] length];
        tag++;
        
        for (int j = 0; j < countOfElement/4; j++) {
            if (j == 0) {
                strEmoji = [NSString stringWithFormat:@"%@",[divisionRepleaceStr safeObjectAtIndex:i]];
            }else{
                strEmoji = [strEmoji stringByAppendingString:[divisionRepleaceStr safeObjectAtIndex:i+j]];
            }
        }
        i += countOfElement/4 - 1;
        [finalRepleaceStr addObject:strEmoji];
        strEmoji = @"";
        
    }
    
    //将合并之后的字符串数组进行emoji变化
    unsigned long  sum = 0;
    NSRange specifiedRange;
    for (int i =0; i<loc.count; i++) {
        NSString *emojiStr =  [self stringToEmoji:[finalRepleaceStr safeObjectAtIndex:i]];
        if (emojiStr == nil) {
            continue;
        }
        
        specifiedRange = NSMakeRange([[loc safeObjectAtIndex:i] integerValue] - 7 - sum , [[initialRepleaceStr safeObjectAtIndex:i] length]  + 8);
        sum += [[initialRepleaceStr safeObjectAtIndex:i] length]  + 8 - ([[initialRepleaceStr safeObjectAtIndex:i] length]/4);
        
        mutableString = [mutableString stringByReplacingCharactersInRange:specifiedRange withString:emojiStr];
        
    }
    return mutableString;
}


//unicode转成emoji
+(NSString *)stringToEmoji:(NSString *) string{
    
    if (string.length==0) {
        return nil;
    }
    NSString *emoji = [NSString stringWithCString:[string cStringUsingEncoding:NSUTF8StringEncoding]encoding:NSNonLossyASCIIStringEncoding];
    return emoji;
    
}

//emoji表情转成unicode
+(NSString *)emojiToString:(NSString *) string{
    NSData *dataForEmoji = [string dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *encodevalue = [[NSString alloc]initWithData:dataForEmoji encoding:NSUTF8StringEncoding];
    encodevalue = [encodevalue stringByReplacingOccurrencesOfString:@"\\u" withString:@""];
    NSString *prexEmoji = @"[emoji:";
    encodevalue = [prexEmoji stringByAppendingString:encodevalue];
    encodevalue = [encodevalue stringByAppendingString:@"]"];
    
    return encodevalue;
}

//将带有emoji表情的字符串分割，判断是否是emoji 是生成unicode
+(NSString *)stringWithEmojiToUnicode:(NSString *)string {
    NSMutableString *resultString = [[NSMutableString alloc]init];
    for (int i = 0 ; i < [string length] ; i++) {
        NSRange rangeIndex = [string rangeOfComposedCharacterSequenceAtIndex:i ];
        i += rangeIndex.length - 1;
        NSString *substring = [string substringWithRange:rangeIndex];
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;                  if (0x1d000 <= uc && uc <= 0x1f77f) {
                    [resultString appendString:[self emojiToString:substring]];
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                [resultString appendString:[self emojiToString:substring]];
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                [resultString appendString:[self emojiToString:substring]];
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                [resultString appendString:[self emojiToString:substring]];
            } else if (0x2934 <= hs && hs <= 0x2935) {
                [resultString appendString:[self emojiToString:substring]];
            } else if (0x3297 <= hs && hs <= 0x3299) {
                [resultString appendString:[self emojiToString:substring]];
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                [resultString appendString:[self emojiToString:substring]];
            }
            [resultString appendString:substring];
            
        }
        
    }
    //    NSLog(@"resultString %@",resultString);
    return resultString;
}




#pragma mark - 正则表达式
//验证手机号码
- (BOOL)isValidateTelephoneNumber {
    //电话号码正则表达式（支持手机号码，3-4位区号，7-8位直播号码，1－4位分机号）
    NSString *teleRegr1 = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    //    NSString *teleRegr2 = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    //    NSArray *tele = [telephoneNumber componentsSeparatedByString:NSLocalizedString(@"-", nil)];
    //    if (tele.count == 2) {
    NSPredicate *telePhoneNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", teleRegr1];
    return [telePhoneNumberTest evaluateWithObject:self];
    //    }
    //    if (tele.count == 3) {
    //        NSPredicate *telePhoneNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", teleRegr2];
    //        return [telePhoneNumberTest evaluateWithObject:telephoneNumber];
    //    }
    return  NO;
}

//验证手机号合法性
- (BOOL)isMobileNumber {
    
    if (self.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//获取字符长度 中文=2个字符
- (int)convertToInt {
    
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0 ; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}




#pragma mark - size
- (CGFloat)getHeightOfFont:(UIFont *)textFont width:(CGFloat)textWidth
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    //[paragraphStyle setLineSpacing:3];
    NSDictionary *attributes = @{NSFontAttributeName:textFont, NSParagraphStyleAttributeName:paragraphStyle};
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                  attributes:attributes
                                     context:nil];
    CGSize requiredSize = rect.size;
    
    return ceilf(requiredSize.height);
}

- (CGFloat)getWidthOfFont:(UIFont *)textFont height:(CGFloat)textHeight
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{NSFontAttributeName:textFont, NSParagraphStyleAttributeName:paragraphStyle};
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, textHeight)
                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                  attributes:attributes
                                     context:nil];
    CGSize requiredSize = rect.size;
    
    return ceilf(requiredSize.width);
}

- (CGFloat)getHeightOfFont:(UIFont *)textFont width:(CGFloat)textWidth LineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setLineSpacing:lineSpacing];
    NSDictionary *attributes = @{NSFontAttributeName:textFont, NSParagraphStyleAttributeName:paragraphStyle};
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                  attributes:attributes
                                     context:nil];
    CGSize requiredSize = rect.size;
    
    return ceilf(requiredSize.height);
}




#pragma mark - NONil
+ (NSString *)noNilWithString:(NSString *)string
{
    if(!string)
    {
        return @"";
    }
    
    //    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

+ (NSInteger)noIntegerWithString:(NSString *)string;
{
    NSInteger value = [string integerValue];
    if(!string)
    {
        return 0;
    }
    return value;
}

+ (CGFloat)noFloatWithString:(NSString *)string
{
    CGFloat value = [string floatValue];
    if(!string)
    {
        return 0;
    }
    return value;
}

+ (NSString *)isObjectDic:(NSDictionary*)objDic contentTheKey:(NSString*)objKey_
{
    if(objDic && [objDic isKindOfClass:[NSDictionary class]])
    {
        if ([[objDic allKeys] containsObject:objKey_])
        {
            NSString *objc_ = [objDic objectForKey:objKey_];
            if (objc_ && ![objc_ isEqual:[NSNull null]])
            {
                NSString *result = [NSString stringWithFormat:@"%@",objc_];
                return result;
            }
        }
    }
    return @"";
}

//银行卡号显示后四位
+ (NSString *)cardNumWithString:(NSString *)string
{
    NSString *cardNum = @"";
    if(string && ![string isEqual:[NSNull null]])
    {
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        long long num = [string longLongValue];
        cardNum = [NSString stringWithFormat:@"尾号 %d",(int)(num % 10000)];
    }
    return cardNum;
}

+ (NSString*)dateToObj:(NSString*)strTime
{
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat1 dateFromString:strTime];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormat stringFromDate:date];
    
    return dateStr;
}

+ (NSString*)timeToObj:(NSString*)strTime
{
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat1 dateFromString:strTime];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    NSString *dateStr = [dateFormat stringFromDate:date];
    return dateStr;
}

+ (NSString*)currentTimeToObj:(NSString*)strTime
{
    NSString *dateStr = [NSString dateToObj:strTime];
    NSString *timeStr = [NSString timeToObj:strTime];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *todayStr = [dateFormat stringFromDate:[NSDate date]];
    if(dateStr && [dateStr isEqualToString:todayStr])
    {
        return timeStr;
    }
    else
    {
        return dateStr;
    }
}

+ (NSString*)phpDateToObj:(NSString*)strTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[strTime doubleValue] /1000];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormat stringFromDate:date];
    return dateStr;
}

+ (NSString*)phpTimeToObj:(NSString*)strTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[strTime doubleValue] /1000];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *dateStr = [dateFormat stringFromDate:date];
    return dateStr;
}

+ (NSString*)currentPhpTimeToObj:(NSString*)strTime
{
    NSString *dateStr = [NSString phpDateToObj:strTime];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *todayStr = [dateFormat stringFromDate:[NSDate date]];
    if(dateStr && [dateStr isEqualToString:todayStr])
    {
        return [NSString phpTimeToObj:strTime];
    }
    else
    {
        return dateStr;
    }
}

+ (NSString *)moneyWithString:(NSString *)string
{
    NSString *str=[string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSUInteger numl = [str length];
    
    if (numl>3 && numl<7)
    {
        return [NSString stringWithFormat:@"%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
    }
    else if (numl>6)
    {
        return [NSString stringWithFormat:@"%@,%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-6)],
                [str substringWithRange:NSMakeRange(numl-6,3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
    }
    else
    {
        return str;
    }
}

//浮点数处理并去掉多余的0
+ (NSString *)stringDisposeWithFloat:(float)floatValue
{
    NSString *str = [NSString stringWithFormat:@"%.2f",floatValue];
    NSInteger len = str.length;
    for (NSInteger i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        return [str substringToIndex:[str length]-1];//s.substring(0, len - i - 1);
    }
    else
    {
        return str;
    }
}

//几周前  几月前
+ (NSString *)prettyDateWithReference:(NSString *)strTime
{
    NSString *dateStr = [NSString phpDateToObj:strTime];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *todayStr = [dateFormat stringFromDate:[NSDate date]];
    if(dateStr && [dateStr isEqualToString:todayStr])
    {
        NSDate *reference = [NSDate dateWithTimeIntervalSince1970:[strTime doubleValue] /1000];
        
        NSString *suffix = @"后";
        
        float different = [reference timeIntervalSinceDate:[NSDate date]];
        
        if (different < 0) {
            different = -different;
            suffix = @"前";
        }
        
        // lower than 60 seconds
        if (different < 60)
        {
            return @"刚刚";
        }
        
        // lower than 120 seconds => one minute and lower than 60 seconds
        else if (different < 120)
        {
            return [NSString stringWithFormat:@"1分钟%@", suffix];
        }
        
        // lower than 60 minutes
        else if (different < 60 * 60)
        {
            return [NSString stringWithFormat:@"%d分钟%@", (int)floor(different / 60), suffix];
        }
        
        // lower than 60 * 2 minutes => one hour and lower than 60 minutes
        else if (different < 60 * 60 * 2)
        {
            return [NSString stringWithFormat:@"1小时%@", suffix];
        }
        
        // lower than one day
        else
        {
            return [NSString stringWithFormat:@"%d小时%@", (int)floor(different / 3600), suffix];
        }
    }
    else
    {
        return dateStr;
    }
}

+ (NSString *)prettyDateWithReference:(NSString *)strTime withTime:(NSInteger)timer
{
    NSString *dateStr = [NSString phpDateToObj:strTime];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *todayStr = [dateFormat stringFromDate:[NSDate date]];
    if(dateStr && [dateStr isEqualToString:todayStr])
    {
        NSString *timeStr = @"";
        
        if(timer == 1)
        {
            timeStr = @"9:00-11:00点";
        }
        else if(timer == 2)
        {
            timeStr = @"11:00-13:00点";
        }
        else if(timer == 3)
        {
            timeStr = @"13:00-15:00点";
        }
        else if(timer == 4)
        {
            timeStr = @"15:00-17:00点";
        }
        else if(timer == 5)
        {
            timeStr = @"17:00-19:00点";
        }
        else
        {
            timeStr = @"19:00-21:00点";
        }
        
        return timeStr;
    }
    else
    {
        return dateStr;
    }
}

@end
