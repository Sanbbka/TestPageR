//
//  Graph.h
//  PageRank
//
//  Created by Alexander Drovnyashin on 07.03.17.
//  Copyright © 2017 Alexander Drovnyashin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphObj.h"

@interface Graph : NSObject

@property (atomic, strong) NSMutableDictionary <NSString *, GraphObj*> *objDict;

- (void)objKey:(NSString *)firstLink addRelationWithLink:(NSString *)secondLink;
- (GraphObj *)getObjectForLink:(NSString *)link;

@end
