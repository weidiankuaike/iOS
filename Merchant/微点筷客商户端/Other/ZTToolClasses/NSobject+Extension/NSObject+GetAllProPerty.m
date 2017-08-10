//
//  NSObject+GetAllProPerty.m
//  merchantClient
//
//  Created by Skyer God on 2017/7/19.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "NSObject+GetAllProPerty.h"

@implementation NSObject (GetAllProPerty)
- (void)printAllProperty{
    unsigned int numIvars; //成员变量个数
    Ivar *vars = class_copyIvarList(NSClassFromString(@"UIView"), &numIvars);
    //Ivar *vars = class_copyIvarList([UIView class], &numIvars);

    NSString *key=nil;
    for(int i = 0; i < numIvars; i++) {

        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  //获取成员变量的名字
        ZTLog(@"variable name :%@", key);
        key = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]; //获取成员变量的数据类型
        ZTLog(@"variable type :%@", key);
    }
    free(vars);

    u_int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);

    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        const char *attributes = property_getAttributes(properties[i]);
        NSString *str = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        NSString *attributesStr = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
        ZTLog(@"propertyName : %@", str);
        ZTLog(@"attributesStr : %@", attributesStr);
    }
}
- (void)printAllFunctions{
    unsigned int numIvars; //成员变量个数
    Method *meth = class_copyMethodList(NSClassFromString(@"UIView"), &numIvars);
    //Method *meth = class_copyMethodList([UIView class], &numIvars);

    for(int i = 0; i < numIvars; i++) {
        Method thisIvar = meth[i];

        SEL sel = method_getName(thisIvar);
        const char *name = sel_getName(sel);

        ZTLog(@"zp method :%s", name);
    }
    free(meth);
}
/** 修改变量 */
- (id)updateVariable
{
    //获取当前类
    id theClass = [self class];
    //初始化
    id otherClass = [[theClass alloc] init];

    unsigned int count = 0;
    //获取属性列表
    Ivar *members = class_copyIvarList([otherClass class], &count);

    //遍历属性列表
    for (int i = 0 ; i < count; i++) {
        Ivar var = members[i];
        //获取变量名称
        const char *memberName = ivar_getName(var);
        //获取变量类型
        const char *memberType = ivar_getTypeEncoding(var);

        NSLog(@"%s----%s", memberName, memberType);

        Ivar ivar = class_getInstanceVariable([otherClass class], memberName);

        NSString *typeStr = [NSString stringWithCString:memberType encoding:NSUTF8StringEncoding];
        //判断类型
        if ([typeStr isEqualToString:@"@\"NSString\""]) {
            //修改值
            object_setIvar(otherClass, ivar, @"abc");
        }else{
            object_setIvar(otherClass, ivar, [NSNumber numberWithInt:99]);
        }
    }
    return otherClass;
}
@end
