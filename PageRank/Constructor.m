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

@property NSMutableArray *printArr;
@property NSInteger counter;
@end

@implementation Constructor

- (void)showMatrix {
    NSMutableArray *arrColumn = [NSMutableArray new];
    
    NSMutableArray *arrKeys = [NSMutableArray new];
    
    for (NSString *keyF in self.graph.objDict) {
        [arrKeys addObject:keyF];
        NSMutableArray *arrRow = [NSMutableArray new];
        for (NSString *keyS in self.graph.objDict) {
            [arrRow addObject:[self.graph.objDict[keyS].relations containsObject:keyF]? @"1" : @"0"];
        }
        [arrColumn addObject:arrRow];
    }
    

    
    [self nonParallelIterationPR];
    [self nonParallelPageRank];
    [self parallelEXPageRank];
    
    [self reloadData];
    NSLog(@"");
}


#pragma mark - FUNCs PR

- (void)nonParallelIterationPR {
    [self startPageRank];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    [self calPageRank];
    NSTimeInterval interval2 = [[NSDate date] timeIntervalSince1970];
    NSLog(@"NONE PARALLEL ITERATION = %f", interval2 - interval);
}

- (void)nonParallelPageRank {
    [self startPageRank];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    [self calExPageRank];
    NSTimeInterval interval2 = [[NSDate date] timeIntervalSince1970];
    NSLog(@"NONE PARALLEL = %f", interval2 - interval);
}

- (void)parallelEXPageRank {
    [self startPageRank];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    [self parallelEx];
    NSTimeInterval interval2 = [[NSDate date] timeIntervalSince1970];
    NSLog(@"PARALLEL EX = %f", interval2 - interval);
}


#pragma mark - FUNCs

- (void)parallelEx {
    NSArray *linksArr = self.graph.objDict.allKeys;
    
    NSInteger N = self.graph.objDict.count;
    NSDictionary *dict = self.graph.objDict;
    
    for (int k = 0; k < 100; k++) {
        dispatch_apply(N, dispatch_get_global_queue(0, 0), ^(size_t i){
            NSString *keyMain = linksArr[i];
            GraphObj *obj = dict[keyMain];
            double pageRank = 0;
            for (NSString *keyL in obj.parents) {
                GraphObj *obj2 = dict[keyL];
                pageRank += obj2.relations.count > 0 ? 1. / obj2.relations.count : 0 * obj2.rankPage;
            }
            obj.nextPageRank = pageRank;
        });
        [self normalizeGraph];
    }
}

- (void)calExPageRank {
    NSArray *linksArr = self.graph.objDict.allKeys;
    
    NSInteger N = self.graph.objDict.count;
    NSDictionary *dict = self.graph.objDict;
    
    for (int k = 0; k < 100; k++) {
        for (int i = 0; i < N; i++) {
            NSString *keyMain = linksArr[i];
            GraphObj *obj = dict[keyMain];
            double pageRank = 0;
            for (NSString *keyL in obj.parents) {
                GraphObj *obj2 = dict[keyL];
                pageRank += obj2.relations.count > 0 ? 1. / obj2.relations.count : 0 * obj2.rankPage;
            }
            obj.nextPageRank = pageRank;
        }
        [self normalizeGraph];
    }
}

- (void)normalizeGraph {
    for (NSString *key in self.graph.objDict) {
        GraphObj *obj = self.graph.objDict[key];
        obj.rankPage = obj.nextPageRank;
    }
}

- (void)printDate {
    [self printLine];
//    NSLog(@"%@", [NSDate date]);
    [self printLine];
}

- (void)printLine {
    NSLog(@"-------------");
}


- (void)startPageRank {
    [self printDate];
    for (NSString *key in self.graph.objDict) {
        GraphObj *obj = self.graph.objDict[key];
        obj.rankPage = 1 / self.graph.objDict.count;
    }
}

- (void)calPageRank {
    
    double d = 0.85;
    double N = self.graph.objDict.count;
    
    for (int i = 0; i < 100; i++) {
        for (NSString *key in self.graph.objDict) {
            GraphObj *obj = self.graph.objDict[key];
            double inbound = 0;
            for (NSString *key in obj.parents) {
                GraphObj *v2 = self.graph.objDict[key];
                double m = v2.relations.count;
                inbound += v2.rankPage / m;
            }
            obj.rankPage = (1 - d) / N + d*inbound;
        }
    }
}

- (void)reloadData {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    NSMutableArray *arr = [NSMutableArray new];
    
    double max = 0;
    NSString *less = @"";
    for (NSString *key in self.graph.objDict) {
        GraphObj *obj = self.graph.objDict[key];
        [dict setObject:@(obj.rankPage) forKey:obj.link];
//        NSLog(@"%@ : %f", obj.link, obj.rankPage);
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.printArr = arr;
        self.vc.arrS = [arr copy];
        [self.vc.tableView reloadData];
    });
}

- (void)prettyPrint:(NSMutableArray *)arrPrint arrG:(NSMutableArray *)arrKeys {
    
    NSString *mainStr = @"";
    NSInteger jj = 0;
    for (NSArray *arr in arrPrint) {
        NSString *printStr = @"";
        for (NSString *str in arr) {
            printStr = [printStr stringByAppendingFormat:@"%@", str];
        }
        printStr = [printStr stringByAppendingString:@""];
        mainStr = [mainStr stringByAppendingFormat:@"%@ %@\n", printStr, arrKeys[jj]];
        jj++;
    }
    
    NSLog(@"");
}

- (void)fillGraph {
    self.graph = [Graph new];
    self.printArr = [NSMutableArray new];
    self.counter = 0;
    
//    [self.execArr addObject:baseURL];
    [self fillWithLink:baseURL];
    
    while (1) {
        NSString *link = [self.graph getLinkNeedDownl];
        if (link == nil) {
            break;
        }
        if ([link containsString:baseURL]) {
            if (link) {
                [self fillWithLink:link];
            }
        }
    }
    
    [self showMatrix];
}

- (void)fillWithLink:(NSString *)mainLink {
    NSArray *arrLinks = [NetworkManager executeTask:mainLink];
    self.graph.objDict[mainLink].downlFlag = YES;
    for (NSString *strLink in arrLinks)
        if ([strLink containsString:baseURL])
            [self.graph objKey:mainLink addRelationWithLink:strLink];
}



@end
