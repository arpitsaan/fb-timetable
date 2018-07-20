//
//  FBTestModels.m
//  fb-timetableTests
//
//  Created by Arpit Agarwal on 20/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FBModelObject.h"

@interface FBTestModels : XCTestCase

@end

@implementation FBTestModels

- (void)testFBModelObjectGetStringForKeyReturnsDummyString {
    FBModelObject *modelObj = [[FBModelObject alloc] init];
    
    NSDictionary *dict = @{@"dummyStringKey":@"dummyStringValue"};
    
    NSString *tempString = [modelObj getStringForKey:@"dummyStringKey" fromDictionary:dict withInitialValue:@""];
    
    XCTAssertTrue([tempString isEqualToString:@"dummyStringValue"]);
}

- (void)testFBModelObjectGetStringForKeyReturnsSpecialCharactersString {
    FBModelObject *modelObj = [[FBModelObject alloc] init];
    
    NSDictionary *dict = @{@"randomCharactersString":@"69MjF[C'dX#<N~>t[?vj&=DE.Av{p,=pe7MTT~Uj2x/~GD[dR^UK`CzB:nB-^&63Ld)VPB;PUAp=M#>}Wj$tZ3SbQ&*<AbE,8Dzn$X"};
    
    NSString *tempString = [modelObj getStringForKey:@"randomCharactersString" fromDictionary:dict withInitialValue:@""];
    
    XCTAssertTrue([tempString isEqualToString:@"69MjF[C'dX#<N~>t[?vj&=DE.Av{p,=pe7MTT~Uj2x/~GD[dR^UK`CzB:nB-^&63Ld)VPB;PUAp=M#>}Wj$tZ3SbQ&*<AbE,8Dzn$X"]);
}

- (void)testFBModelObjectGetStringForKeyReturnsEmptyStringInitialValue {
    FBModelObject *modelObj = [[FBModelObject alloc] init];
    
    NSString *tempString = [modelObj getStringForKey:nil fromDictionary:nil withInitialValue:@""];
    
    XCTAssertTrue([tempString isEqualToString:@""]);
}

- (void)testFBModelObjectGetNumberForKeyReturnsInitialValue {
    FBModelObject *modelObj = [[FBModelObject alloc] init];
    
    NSNumber *tempNumber = [modelObj getNumberForKey:nil fromDictionary:nil withInitialValue:@(1234)];
    
    XCTAssertTrue(tempNumber.integerValue == 1234);
}

- (void)testFBModelObjectGetNumberForKeyReturnsLargeNumber {
    FBModelObject *modelObj = [[FBModelObject alloc] init];
    
    NSDictionary *dict = @{@"largeNumberKey":@"12387623475198348109238409182351862359172309512834012834127364817234698123749812374891236489123742314.1234"};
    
    NSNumber *tempNumber = [modelObj getNumberForKey:@"largeNumberKey" fromDictionary:dict withInitialValue:@(0)];
    
    XCTAssertTrue([tempNumber isEqual:@(12387623475198348109238409182351862359172309512834012834127364817234698123749812374891236489123742314.1234)]);
}

- (void)testFBModelObjectGetNumberForKeyReturnsNegative {
    FBModelObject *modelObj = [[FBModelObject alloc] init];
    
    NSDictionary *dict = @{@"negativeNumberKey":@"-987987"};
    
    NSNumber *tempNumber = [modelObj getNumberForKey:@"negativeNumberKey" fromDictionary:dict withInitialValue:@(0)];
    
    XCTAssertTrue([tempNumber isEqual:@(-987987)]);
}


- (void)testFBModelAPIRetryCountIsMoreThan1 {
    NSInteger count = [FBModelObject getRetryCount];
    
    XCTAssertTrue(count > 1);
}

@end
