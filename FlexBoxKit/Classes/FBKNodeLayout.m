//
//  FBKNodeLayout.m
//  FlexBoxKit
//
//  Created by zym on 2018/12/16.
//

#import "FBKNodeLayout.h"
#import "FBKYogaUtilities.h"
#import "UIColor+FBKExtension.h"

#import <YogaKit/UIView+Yoga.h>
#import <YogaKit/YGLayout.h>

@implementation FBKNodeLayout

+ (UIView *)layoutWithNodeModel:(FBKNodeModel *)nodeModel {
    NSString *className = nodeModel.className;

    if (!className) return nil;

    Class cls = NSClassFromString(className);
    if (!cls) {
        NSLog(@"FlexBoxKit: class %@ is not found.", className);
        return nil;
    }

    UIView *nodeView = [[cls alloc] init];
    nodeView.backgroundColor = [UIColor fbk_randomColor];
    [nodeView configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
        layout.isEnabled = YES;
        for (FBKLayoutModel *layoutModel in nodeModel.layouts) {
            FBKSetYogaLayoutParam(layout, layoutModel.name, layoutModel.value);
        }
    }];
    if (nodeModel.children) {
        for (FBKNodeModel *childNodeLayout in nodeModel.children) {
            UIView *childNodeView = [self layoutWithNodeModel:childNodeLayout];
            if (childNodeView) [nodeView addSubview:childNodeView];
        }
    }
    return nodeView;
}

static YGValue FBKTransformYGValue(NSString *value) {
    if ([value isEqualToString:@"none"]) return YGValueUndefined;

    if ([value isEqualToString:@"auto"]) return YGValueAuto;

    if ([value hasSuffix:@"%"]) {
        NSString *realValue = [value stringByReplacingOccurrencesOfString:@"%" withString:@""];
        return YGPercentValue([realValue doubleValue]);
    }

    return YGPointValue([value doubleValue]);
}

static void FBKSetYogaLayoutParam(YGLayout *layout, NSString *key, NSString *value) {
#define FBK_SET_YG_ENUM(prop, table, type)           \
    if ([key isEqualToString:@(#prop)]) {            \
        layout.prop = (type)[table[value] intValue]; \
        return;                                      \
    }

#define FBK_SET_YG_VALUE(prop)                    \
    if ([key isEqualToString:@(#prop)]) {         \
        layout.prop = FBKTransformYGValue(value); \
        return;                                   \
    }

#define FBK_SET_YG_CGFloat_VALUE(prop)     \
    if ([key isEqualToString:@(#prop)]) {  \
        layout.prop = [value doubleValue]; \
        return;                            \
    }

    FBK_SET_YG_ENUM(direction, FBKYgDirection(), YGDirection);
    FBK_SET_YG_ENUM(flexDirection, FBKYgFlexDirection(), YGFlexDirection);
    FBK_SET_YG_ENUM(justifyContent, FBKYgJustify(), YGJustify);
    FBK_SET_YG_ENUM(alignContent, FBKYgAlign(), YGAlign);
    FBK_SET_YG_ENUM(alignItems, FBKYgAlign(), YGAlign);
    FBK_SET_YG_ENUM(alignSelf, FBKYgAlign(), YGAlign);
    FBK_SET_YG_ENUM(position, FBKYgPositionType(), YGPositionType);
    FBK_SET_YG_ENUM(flexWrap, FBKYgWrap(), YGWrap);
    FBK_SET_YG_ENUM(overflow, FBKYgOverflow(), YGOverflow);
    FBK_SET_YG_ENUM(display, FBKYgDisplay(), YGDisplay);

    FBK_SET_YG_CGFloat_VALUE(flexGrow);
    FBK_SET_YG_CGFloat_VALUE(flexShrink);
    FBK_SET_YG_VALUE(flexBasis);

    FBK_SET_YG_VALUE(left);
    FBK_SET_YG_VALUE(top);
    FBK_SET_YG_VALUE(right);
    FBK_SET_YG_VALUE(bottom);
    FBK_SET_YG_VALUE(start);
    FBK_SET_YG_VALUE(end);

    FBK_SET_YG_VALUE(marginLeft);
    FBK_SET_YG_VALUE(marginTop);
    FBK_SET_YG_VALUE(marginRight);
    FBK_SET_YG_VALUE(marginBottom);
    FBK_SET_YG_VALUE(marginStart);
    FBK_SET_YG_VALUE(marginEnd);
    FBK_SET_YG_VALUE(marginHorizontal);
    FBK_SET_YG_VALUE(marginVertical);
    FBK_SET_YG_VALUE(margin);

    FBK_SET_YG_VALUE(paddingLeft);
    FBK_SET_YG_VALUE(paddingTop);
    FBK_SET_YG_VALUE(paddingRight);
    FBK_SET_YG_VALUE(paddingBottom);
    FBK_SET_YG_VALUE(paddingStart);
    FBK_SET_YG_VALUE(paddingEnd);
    FBK_SET_YG_VALUE(paddingHorizontal);
    FBK_SET_YG_VALUE(paddingVertical);
    FBK_SET_YG_VALUE(padding);

    FBK_SET_YG_CGFloat_VALUE(borderLeftWidth);
    FBK_SET_YG_CGFloat_VALUE(borderTopWidth);
    FBK_SET_YG_CGFloat_VALUE(borderRightWidth);
    FBK_SET_YG_CGFloat_VALUE(borderBottomWidth);
    FBK_SET_YG_CGFloat_VALUE(borderStartWidth);
    FBK_SET_YG_CGFloat_VALUE(borderEndWidth);
    FBK_SET_YG_CGFloat_VALUE(borderWidth);
    FBK_SET_YG_CGFloat_VALUE(aspectRatio);

    FBK_SET_YG_VALUE(width);
    FBK_SET_YG_VALUE(height);
    FBK_SET_YG_VALUE(minWidth);
    FBK_SET_YG_VALUE(minHeight);
    FBK_SET_YG_VALUE(maxWidth);
    FBK_SET_YG_VALUE(maxHeight);

    NSLog(@"FlexBoxKit: not supported layout attributes - %@", key);
};

@end
