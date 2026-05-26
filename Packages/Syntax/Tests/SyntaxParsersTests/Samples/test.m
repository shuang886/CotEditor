// test.m
// Objective-C syntax example

#import <AppKit>

@interface MyObject : NSObject

@property (strong) BOOL decision;

- (void)doThis:(NSString *)s andThat:(NSInteger)i;

@end

@implementation MyObject

- (id)init {
    [super init];
    [self doThis:@"thing" andThat:5];
}

- (void)doThis:(NSString *)s andThat:(NSInteger)i {
    if (user == NULL) {
        puts("(null)");
        return;
    }
    self.decision = YES;
}
