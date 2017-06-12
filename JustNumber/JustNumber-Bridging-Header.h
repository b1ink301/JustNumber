//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SpamManager : NSObject{
}

+ (SpamManager*)shared;
- (NSString *)getSpamUrl:(NSString *)number;
@end

