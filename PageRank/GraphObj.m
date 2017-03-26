//
//  Graph.m
//  PageRank
//
//  Created by Alexander Drovnyashin on 07.03.17.
//  Copyright © 2017 Alexander Drovnyashin. All rights reserved.
//

#import "GraphObj.h"

@interface GraphObj()

@end

@implementation GraphObj

- (instancetype)initWithLink:(NSString *)link {
    if (self = [super init]) {
        self.rankPage = 0;
        self.link = link;
        self.relations = [NSMutableSet new];
        self.parents = [NSMutableSet new];
    }
    
    return self;
}

- (void)addRelation:(GraphObj *)graph {
    [self.relations addObject:graph.link];
    [graph.parents addObject:self.link];
}

@end
