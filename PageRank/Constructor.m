//
//  Constructor.m
//  PageRank
//
//  Created by Alexander Drovnyashin on 07.03.17.
//  Copyright © 2017 Alexander Drovnyashin. All rights reserved.
//

#import "Constructor.h"

#import "Graph.h"
#import "NetworkManager.h"
#import "Constant.h"

@interface Constructor ()

@property Graph *graph;

@property NSMutableArray *execArr;

@end

@implementation Constructor

- (void)showMatrix {
    
    NSMutableArray *arrColumn = [NSMutableArray new];
    
    for (NSString *keyF in self.graph.objDict) {
        NSMutableArray *arrRow = [NSMutableArray new];
        for (NSString *keyS in self.graph.objDict) {
            [arrRow addObject:[self.graph.objDict[keyF].relations containsObject:keyS]? @"1" : @"0"];
        }
        [arrColumn addObject:arrRow];
    }
    [self prettyPrint:arrColumn];
    [self calPageRank];
    NSLog(@"");
}

- (void)calPageRank {
    
    double d = 0.85;
    double N = self.graph.objDict.count;
    
    for (NSString *key in self.graph.objDict) {
        GraphObj *obj = self.graph.objDict[key];
        obj.rankPage = 1./N;
    }
    
    NSLog(@"Number Of Vertices: %f", N);
    NSLog(@"*************************");
    
    for (int i = 0; i < 20; i++) {
        for (NSString *key in self.graph.objDict) {
            GraphObj *obj = self.graph.objDict[key];
            double inbound = 0;
            for (NSString *key in self.graph.objDict) {
                GraphObj *v2 = self.graph.objDict[key];
                double m = v2.relations.count;
                for (NSString *e in v2.relations) {
                    if ([e isEqualToString:obj.link]) {
                        inbound += [self.graph getObjectForLink:e].rankPage / m;
                    }
                }
            }
            obj.rankPage = (1 - d) / N + d*inbound;
        }
    }
    NSLog(@"Rank of Vertices");
    NSLog(@"*************************");
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    NSMutableArray *arr = [NSMutableArray new];
    
    double max = 0;
    NSString *less = @"";
    for (NSString *key in self.graph.objDict) {
        GraphObj *obj = self.graph.objDict[key];
        [dict setObject:@(obj.rankPage) forKey:obj.link];
        NSLog(@"%@ : %f", obj.link, obj.rankPage);
        [arr addObject:@{@"link" : obj.link, @"val" : @(obj.rankPage)}];
        if (obj.rankPage > max) {
            less = obj.link;
            max = obj.rankPage;
        }
    }
    
    [arr sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        if ([obj1[@"val"] doubleValue] > [obj2[@"val"] doubleValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    
    
    NSLog(@"%@", dict);
    NSLog(@"");
}

- (void)prettyPrint:(NSMutableArray *)arrPrint {
    
    NSString *mainStr = @"";
    for (NSArray *arr in arrPrint) {
        NSString *printStr = @"[";
        for (NSString *str in arr) {
            printStr = [printStr stringByAppendingFormat:@"%@, ", str];
        }
        printStr = [printStr stringByAppendingString:@"]"];
        
        mainStr = [mainStr stringByAppendingFormat:@"%@\n", printStr];
    }
    
    NSLog(@"");
}

- (void)fillGraph {
    self.graph = [Graph new];
    self.execArr = [NSMutableArray new];
    
    [self.execArr addObject:baseURL];
    
    while (self.graph.objDict.count < 100 && self.execArr.count != 0) {
        [self fillWithLink:self.execArr.firstObject];
    }
    
    [self showMatrix];
}

- (void)fillWithLink:(NSString *)mainLink {
    NSArray *arrLinks = [NetworkManager executeTask:mainLink];
    
    for (NSString *strLink in arrLinks) {
        [self.graph objKey:mainLink addRelationWithLink:strLink];
    }
    
    [self.execArr removeObject:mainLink];
    
    if (arrLinks) {
        [self.execArr addObjectsFromArray:arrLinks];
    }
}

@end
