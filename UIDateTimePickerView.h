
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PickerType) {
    PickerYMD,
    PickerYMDHM,
    PickerHM
};

@interface UIDateTimePickerView: UIPickerView

@property (nonatomic,copy) void(^dateTimeChangeBlock)(UIDateTimePickerView *pickView, NSDate *date);

- (instancetype)initWithStyle:(PickerType)style  width:(CGFloat)width;
- (void)setMinDate:(NSDate *)date maxDate:(NSDate *)maxDate  selectedDate:(NSDate *)selectedDate;
- (NSDate *)getSelectedDate;
@end
