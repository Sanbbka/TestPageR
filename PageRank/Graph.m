//
//  Graph.m
//  PageRank
//
//  Created by Alexander Drovnyashin on 07.03.17.
//  Copyright © 2017 Alexander Drovnyashin. All rights reserved.
//

#import "Graph.h"

@interface Graph ()



@end

@implementation Graph

- (instancetype)init {
    if (self = [super init]) {
        self.objDict = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)objKey:(NSString *)firstLink addRelationWithLink:(NSString *)secondLink {
    GraphObj *firstObj = [self getObjectForLink:firstLink];
    GraphObj *secondObj = [self getObjectForLink:secondLink];
    
    [firstObj addRelation:secondObj];
}

- (GraphObj *)getObjectForLink:(NSString *)link {
    GraphObj *obj = self.objDict[link];
    
    if (obj == nil) {
        obj = [[GraphObj alloc] initWithLink:link];
        [self.objDict setObject:obj forKey:obj.link];
    }
    
    return obj;
}

@end
