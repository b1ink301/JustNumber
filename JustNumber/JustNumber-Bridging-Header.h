//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SpamManager : NSObject{
}

+ (SpamManager*)shared;
- (void)search:(NSString*)address completionHandler:(void (^)(NSData * data, NSURLResponse *response, NSError *error))handler;
@end

