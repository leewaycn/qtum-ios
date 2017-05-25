//
//  ContractManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 16.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "ContractManager.h"
#import "InterfaceInputFormModel.h"
#import "ContractFileManager.h"
#import "ContractArgumentsInterpretator.h"
#import "ResultTokenInputsModel.h"
#import "AbiinterfaceItem.h"
#import "NSString+SHA3.h"
#import "NSString+Extension.h"

@implementation ContractManager

+ (instancetype)sharedInstance {
    
    static ContractManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    
    self = [super init];
    
    if (self != nil) {

    }
    return self;
}


- (InterfaceInputFormModel*)getTokenInterfaceWithTemplate:(NSString*)templateName {
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[ContractFileManager getAbiFromBundleWithTemplate:templateName]];
    return interphase;
}

- (NSData*)getTokenBitecodeWithTemplate:(NSString*)templateName andParam:(NSDictionary*) args{
    
    NSMutableData* contractSource = [[ContractFileManager getBitcodeFromBundleWithTemplate:templateName] mutableCopy];
    [contractSource appendData:[ContractArgumentsInterpretator contactArgumentsFromDictionary:args]];
    return [contractSource copy];
}

- (NSData*)getTokenBitecodeWithTemplate:(NSString*)templateName andArray:(NSArray*) args{
    
    NSMutableData* contractSource = [[ContractFileManager getBitcodeFromBundleWithTemplate:templateName] mutableCopy];
    [contractSource appendData:[ContractArgumentsInterpretator contactArgumentsFromArray:args]];
    return [contractSource copy];
}

- (NSString*)getStringHashOfFunction:(AbiinterfaceItem*) fuctionItem andParam:(NSArray<ResultTokenInputsModel*>*)inputs{
    
    NSMutableString* param = [NSMutableString new];
    for (int i = 0; i < fuctionItem.inputs.count; i++) {
        if (i != fuctionItem.inputs.count - 1) {
            [param appendFormat:@"%@,",fuctionItem.inputs[i].typeAsString];
        } else {
            [param appendString:fuctionItem.inputs[i].typeAsString];
        }
    }
    NSString* functionSignature = [NSString stringWithFormat:@"%@(%@)",fuctionItem.name,param];
    //        NSString* functionSignature = @"name()";
    
    
    return [[functionSignature sha3:256] substringToIndex:8];
}

- (NSData*)getHashOfFunction:(AbiinterfaceItem*) fuctionItem andParam:(NSArray<ResultTokenInputsModel*>*)inputs{
    
    return [NSString dataFromHexString:[self getStringHashOfFunction:fuctionItem andParam:inputs]];
}





@end