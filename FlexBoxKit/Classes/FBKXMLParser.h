//
//  FbkXMLParser.h
//  FlexBoxKit
//
//  Created by zym on 2018/12/16.
//

#import <Foundation/Foundation.h>

#import "FBKNodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBKXMLParser : NSObject

- (FBKNodeModel *)parseWithXMLPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
