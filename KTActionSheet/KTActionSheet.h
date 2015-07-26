//  Created by Kelvin Tong on 15/7/26.
//  Copyright (c) 2015年 com.thongbin. All rights reserved.

#import <UIKit/UIKit.h>
@class KTActionSheet;
typedef void(^ItemSelectedBlock)(KTActionSheet *sheet, NSInteger index);

@interface KTActionSheet : UIView<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    UITableView *view;
    NSArray *listData;
}
-(id)initWithlist:(NSArray *)list height:(CGFloat)height inView:(UIViewController*)supView ItemSelectedBlock:(ItemSelectedBlock)selectedBlock;
- (void)show;
//@property(nonatomic,assign) id <DownSheetDelegate> delegate;
@property(nonatomic,strong)UIViewController *supViewController;
@property(nonatomic,copy)ItemSelectedBlock itemSelectedBlock;
@end


#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
@interface KTActionSheetCell : UITableViewCell{
    UIImageView *leftView;
    UILabel *InfoLabel;
    UIView *backgroundView;
}
-(void)setItemTitle:(NSString*)title;
@end
