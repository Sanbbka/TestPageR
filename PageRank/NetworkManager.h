//
//  NetworkManager.h
//  PageRank
//
//  Created by Alexander Drovnyashin on 07.03.17.
//  Copyright © 2017 Alexander Drovnyashin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@interface NetworkManager : NSObject

+ (NSArray *)executeTask:(NSString *)urlPath;

@end
