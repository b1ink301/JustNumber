//
//  SpamManager.m
//  JustNumber
//
//  Created by evan on 2017. 6. 12..
//  Copyright © 2017년 evan. All rights reserved.
//

#import "JustNumber-Bridging-Header.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

#define RANDOM_SEED() srandom((unsigned)time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

@implementation SpamManager

- (NSString *) phoneNumber {
    long r = RANDOM_INT(33456789, 98765432);
    return [NSString stringWithFormat:@"010%ld", r];
}

- (char*) encodeWithData:(unsigned char[])in off:(int)iOff length:(int)iLen {
    NSLog(@"whoau: %s", __FUNCTION__);
    
    char *map = malloc(64);
    
    int i=0;
    for (char c='A'; c<='Z'; c++) map[i++] = c;
    for (char c='a'; c<='z'; c++) map[i++] = c;
    for (char c='0'; c<='9'; c++) map[i++] = c;
    map[i++] = '+'; map[i++] = '/';
    
    int oDataLen = (iLen*4+2)/3;       // output length without padding
    int oLen = ((iLen+2)/3)*4;         // output length including padding
    char *out = malloc(oLen);
    
    int ip = iOff;
    int iEnd = iOff + iLen;
    int op = 0;
    
    while (ip < iEnd) {
        int i0 = in[ip++] & 0xff;
        int i1 = ip < iEnd ? in[ip++] & 0xff : 0;
        int i2 = ip < iEnd ? in[ip++] & 0xff : 0;
        int o0 = (unsigned int)i0 >> 2;
        int o1 = ((i0 &   3) << 4) | (unsigned int)(i1 >> 4);
        int o2 = ((i1 & 0xf) << 2) | (unsigned int)(i2 >> 6);
        int o3 = i2 & 0x3F;
        out[op++] = map[o0];
        out[op++] = map[o1];
        out[op] = op < oDataLen ? map[o2] : '='; op++;
        out[op] = op < oDataLen ? map[o3] : '='; op++;
    }
    
    free(map);
    
    return out;
    
}

- (char *)AES128EncryptWithKey:(NSString *)key withData:(NSData*)data{
    
        NSLog(@"whoau: %s", __FUNCTION__);
        
        // 'key' should be 32 bytes for AES256,
        // 16 bytes for AES256, will be null-padded otherwise
        char keyPtr[kCCKeySizeAES128 + [key length]]; // room for terminator (unused)
        bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
        
        // insert key in char array
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        
        NSUInteger dataLength = [data length];
        size_t bufferSize = dataLength + kCCKeySizeAES128;
        void *buffer = malloc(bufferSize);
        
        size_t numBytesEncrypted = 0;
        
        // the encryption method, use always same attributes in android and iPhone (f.e. PKCS7Padding)
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding,
                                              keyPtr,
                                              kCCKeySizeAES128,
                                              NULL                      /* initialization vector (optional) */,
                                              [data bytes], dataLength, /* input */
                                              buffer, bufferSize,       /* output */
                                              &numBytesEncrypted);
        if (cryptStatus == kCCSuccess) {
            return [self encodeWithData:buffer off:0 length:(int)numBytesEncrypted];
        }
        
        free(buffer);

    return nil;
}

+ (SpamManager *)shared {
    static SpamManager *sharedManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (id)init{
    if (self = [super init]) {
        RANDOM_SEED();
    }
    return self;
}


-(NSString*)encrypt:(NSString*)raw{
    NSLog(@"whoau: %s", __FUNCTION__);
    
    char* output = [self AES128EncryptWithKey:@"ktcs_5059t6gmgm1" withData:[raw dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *result = [[NSString alloc] initWithBytes:output length:24 encoding:NSUTF8StringEncoding];
    
    free(output);
    
    return result;
}

- (NSString *)getSpamUrl:(NSString *)number {
    NSLog(@"whoau: %s", __FUNCTION__);
    
    NSString* dst = [self encrypt:[self phoneNumber]];
    NSString* src = [self encrypt:number];
    
    NSLog(@"whoau : src = [%@] , dst = [%@]", src, dst);
    
    NSCharacterSet *allowedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"];
    
    src = [src stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    dst = [dst stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    NSString *params = [NSString stringWithFormat:@"I_USER_ID=&I_SCH_PH=%@&I_FAKE_PH=%@&I_USER_PH=%@&I_USER_PH_FLAG=N&I_CALL_TYPE=P&I_PH_BOOK_FLAG=N&I_RQ_TYPE=1&I_IN_OUT=I", src, src, dst];
    
    NSString *urlString = [NSString stringWithFormat:@"http://183.111.145.108:8114/whowho_app/p_app_scid_get_enc.jsp?%@", params];
    
    NSLog(@"whoau: urlStringd: %@", urlString);
    
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
//    [urlRequest setHTTPMethod:@"GET"];
//    [urlRequest setValue:@"Dalvik/1.6.0 (Linux; U; Android 4.1.2; IM-A870S Build/JZO54K)" forHTTPHeaderField: @"User-Agent"];
//    [urlRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    
    return urlString;
}


//{"O_BLOCK_PH":"3236","O_RET":"0","O_MNG_MSG":"","O_PRFL":"","O_ADDR_NM":"","O_PH_PUB_NM":"","O_SAFE_PH":"1","O_IMG_URL":"","O_BUSI_NM":"",
//"O_SCH_SPAM":"{\"TOTALCOUNT\":\"1751\",\"VALUES\":[{\"CODE\":5,\"COUNT\":1117},{\"CODE\":2,\"COUNT\":282},{\"CODE\":1,\"COUNT\":134}]}",
//"O_CHG_PH":"","O_CDR_SEQ":"","O_PUB_NM":"","O_SCH_SHARE":"[{\"REPT_PH\":\"6**3\",\"SHARE_INFO\":\"sk 핸드폰 판매전화\",\"EDIT_DT\":\"25-JUN-14\"},{\"REPT_PH\":\"4**2\",\"SHARE_INFO\":\"ㅈ^\\n\\nㆍ?ㅉㅉㅉㅉㅉㅉㅉㅉㅉㅉㅉㅉㅉ브ㅡㅡㅡㅡㅡ\",\"EDIT_DT\":\"25-JUN-14\"},{\"REPT_PH\":\"9**5\",\"SHARE_INFO\":\"SK 광고\",\"EDIT_DT\":\"25-JUN-14\"}]"}

//	{"O_BLOCK_PH":null,"O_RET":"11","O_MNG_MSG":null,"O_PRFL":null,"O_ADDR_NM":null,
//   "O_PH_PUB_NM":null,"O_IMG_URL":null,"O_SAFE_PH":null,"O_BUSI_NM":null,
//   "O_SCH_SPAM":null,"O_CHG_PH":null,"O_CDR_SEQ":null,"O_PUB_NM":null,"O_SCH_SHARE":null}
//"O_SCH_SPAM":"{\"TOTALCOUNT\":\"280\",\"VALUES\":[{\"CODE\":1,\"COUNT\":98},{\"CODE\":6,\"COUNT\":98},{\"CODE\":2,\"COUNT\":29}]}"

//    1 = "대출 권유";
//    2 = "텔레마케팅";
//    3 = "불법게임,도박";
//    4 = "성인관련,유흥업소";
//    5 = "휴대폰 판매";
//    6 = "보험 가입 권유";
//    7 = "전화유도";
//    8 = "보이스피싱";
//    9 = "대리운전";
//	0 = "기타 유형 스팸";

//-(NSString*)json2StringWithAddress:(NSString*)address{
//    
//    _request = [self createRequestForNumber:address];
//    
//    NSError *error = nil;
//    NSHTTPURLResponse *httpResponse;
//    NSData *data = [NSURLConnection sendSynchronousRequest:_request returningResponse:&httpResponse error:&error];
//    NSString *caller = @"알수없음";
//    
//    if([data length] > 0 && error==nil && [httpResponse statusCode]==200) {
//        
//        NSError *localError = nil;
//        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
//        
//        if(localError!=nil){
//            NSLog(@"whoau: Lookup request localError: %@", localError);
//            caller = @"알수없음 (에러#1)";
//        }
//        else{
//            NSString* name = [parsedObject objectForKey:@"O_PUB_NM"];
//            NSString* type = [parsedObject objectForKey:@"O_BUSI_NM"];
//            NSString* region = [parsedObject objectForKey:@"O_ADDR_NM"];
//            NSString* spams = [parsedObject objectForKey:@"O_SCH_SPAM"];
//            
//            parsedObject = [NSJSONSerialization JSONObjectWithData:[spams dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&localError];
//            
//            NSString* total_spam_count = [parsedObject objectForKey:@"TOTALCOUNT"];
//            NSMutableArray *jsonArray = [parsedObject objectForKey:@"VALUES"];
//            
//            NSLog(@"whoau: Lookup request returned: %@, %@, %@, %@", name, type, region, total_spam_count);
//            
//            if(name!=nil && [name length]>0){
//                caller = name;
//            }
//            else{
//                
//                if(jsonArray!=nil && [jsonArray count]>0){
//                    
//                    NSString* code_name;
//                    NSInteger code = -1;
//                    for(NSDictionary *item in jsonArray) {
//                        code = [[item objectForKey:@"CODE"] intValue];
//                        break;
//                    }
//                    
//                    switch (code) {
//                        case 1: code_name = @"대출권유 스팸"; break;
//                        case 2: code_name = @"텔레마케팅 스팸"; break;
//                        case 3: code_name = @"불법게임,도박 스팸"; break;
//                        case 4: code_name = @"성인관련,유흥업소 스팸"; break;
//                        case 5: code_name = @"휴대폰판매 스팸"; break;
//                        case 6: code_name = @"보험가입권유 스팸"; break;
//                        case 7: code_name = @"전화유도 스팸"; break;
//                        case 8: code_name = @"보이스피싱 스팸"; break;
//                        case 9: code_name = @"대리운전 스팸"; break;
//                        default: code_name = @"기타유형 스팸"; break;
//                    }
//                    
//                    caller = code_name;
//                }
//            }
//            
//            [self addCallLogWithName:caller type:type region:region address:address];
//            
//            if([total_spam_count length]>0)
//                caller = [NSString stringWithFormat:@"%@ (신고건수:%@건)", caller, total_spam_count];
//            
//        }
//    }
//    
//    if (error != nil) {
//        NSLog(@"whoau: Lookup request errored: %@", error);
//        caller = @"알수없음 (에러#2)";
//    }
//    
//    [self clear];
//    
//    return caller;
//}
//
//-(void)processCallLog:(NSMutableDictionary*)dic{
//    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:InCallServiceIdentifier]){
//
//        NSLog(@"whoau: %s", __FUNCTION__);
//
//        NSString* address = [dic objectForKey:@"a"];
//        NSString* name = [dic objectForKey:@"n"];
//        NSString* type = [dic objectForKey:@"t"];
//        NSString* region = [dic objectForKey:@"r"];
//
//        NSLog(@"whoau: processCallLog: %@, %@, %@, %@", address, name, type, region);
//
//        [[DBManager sharedManager] addCallLog:address name:name type:type region:region];
//    }
//}
//
//- (void)reqeustWithAddress:(NSString *)number label:(UILabel*)label{
//    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:InCallServiceIdentifier]){
//
//        NSLog(@"whoau: %s number = %@", __FUNCTION__, number);
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//            NSString* address = [[number componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
//
//            if(address==nil || address.length<3) return;
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [label setText:@"검색 중.."];
//            });
//
//            //            [NSThread sleepForTimeInterval:.5f];
//
//            CallLogItem* item = [[DBManager sharedManager] getCallLog:address];
//
//            if(item!=nil){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [label setText:item.name];
//                });
//
//                [self addCallLogWithName:item.name type:item.type region:item.region address:address];
//            }
//            else{
//
//                NSString *caller = [self json2StringWithAddress:address];
//
//                if(label!=nil){
//                    NSLog(@"whoau: setLabel = %@", caller);
//
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [label setText:caller];
//                    });
//                }
//            }
//        });
//    }
//
//}
@end
