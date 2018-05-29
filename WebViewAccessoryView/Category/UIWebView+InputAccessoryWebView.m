//
//  UIWebView+InputAccessoryWebView.m
//  WebViewKeyboard
//
//  Created by CF on 2018/5/29.
//  Copyright © 2018年 klone. All rights reserved.
//

#import "UIWebView+InputAccessoryWebView.h"
#import <objc/runtime.h>

static const char * const hackishFixClassName = "UIWebBrowserViewMinusAccessoryView";
static Class hackishFixClass = Nil;

@implementation UIWebView (InputAccessoryWebView)
@dynamic k_AccessoryView;

- (void)setK_AccessoryView:(UIView *)k_AccessoryView {
    objc_setAssociatedObject(self, @selector(k_AccessoryView), k_AccessoryView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self changeAccessoryView];
}

- (UIView *)k_AccessoryView {
    return objc_getAssociatedObject(self, @selector(k_AccessoryView));
}

- (UIView *)findBrowserView {
    UIScrollView *scrollView = self.scrollView;
    
    UIView *browserView = nil;
    for (UIView *subview in scrollView.subviews) {
        if ([NSStringFromClass([subview class]) hasPrefix:@"UIWebBrowserView"]) {
            browserView = subview;
            break;
        }
    }
    return browserView;
}

- (void)ensureHackishSubclassExistsOfBrowserViewClass:(Class)browserViewClass {
    // Checking if we already registered the new hacking class.
    if (!hackishFixClass) {
        Class newClass = objc_allocateClassPair(browserViewClass, hackishFixClassName, 0);
        objc_registerClassPair(newClass);
        hackishFixClass = newClass;
    }
    
    // Always replace the imp of the method.
    UIView * toolbar = self.k_AccessoryView;
    id block = ^{
        return toolbar;
    };
    IMP blockImp = imp_implementationWithBlock(block);
    class_replaceMethod(hackishFixClass, @selector(inputAccessoryView), blockImp, "@@:");
}

- (void)changeAccessoryView {
    UIView *browserView = [self findBrowserView];
    if (browserView == nil) {
        return;
    }
    
    [self ensureHackishSubclassExistsOfBrowserViewClass:[browserView class]];
    
    object_setClass(browserView, hackishFixClass);
    [browserView reloadInputViews];
}

@end
