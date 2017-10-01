#import "UILabel+FhcExtras.h"
#import "NSString+FhcExtras.h"
#import "UIView+FhcExtras.h"
#import "NSDate+Helper.h"
#import "NSDate+Utilities.h"
#import "UIDateTimePickerView.h"

@interface UIDateTimePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource> {
    PickerType pickStyle;
    NSInteger rowYear, rowMonth, rowDay, rowHour, rowMinute;
    NSMutableArray<NSString *> *arrYear, *arrMonth, *arrDay, *arrHour, *arrMinute;
    BOOL firstTimeLoad;
    NSDate *_selectedDate, *_minDate, *_maxDate;
    
    NSString *_year, *_month, *_day, *_hour, *_minute;
}

@end

@implementation UIDateTimePickerView

- (instancetype)initWithStyle:(PickerType)style width:(CGFloat)width{
    self = [[UIDateTimePickerView alloc]init];
    self.$width = width;
    firstTimeLoad = YES;
    pickStyle = style;
   
    return self;
}

- (NSDate *)getSelectedDate{
    return _selectedDate;
}

- (void)setMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate selectedDate:(NSDate *)selectedDate{
    
    if ([minDate isLaterThanDate:maxDate]) {
        _minDate = maxDate;
        _maxDate = minDate;
    }else{
        _minDate = minDate;
        _maxDate = maxDate;
    }
    BOOL isMin = NO;
    BOOL isMax = NO;
    if ([selectedDate isLaterThanDate:_maxDate]) {
        _selectedDate = _maxDate;
        isMax = YES;
    }else if ([selectedDate isEarlierThanDate:_minDate]) {
        _selectedDate = _minDate;
        isMin = YES;
    }else{
        _selectedDate = selectedDate;
    }

    if (pickStyle == PickerYMDHM || pickStyle == PickerYMD) {
        arrYear = [[NSMutableArray alloc]init];
        for (NSUInteger i = [minDate year]; i <= [maxDate year]; i++) {
            [arrYear addObject:[NSString stringWithFormat:@"%lu",i]];
        }
        
        arrMonth = [[NSMutableArray alloc]init];
        if (arrYear.count == 1) {
            for (NSUInteger i = [minDate month]; i <= [maxDate month]; i++) {
                [arrMonth addObject:[NSString stringWithFormat:@"%02lu",i]];
            }
        }else{
            for (NSUInteger i = 1; i <= 12; i++) {
                [arrMonth addObject:[NSString stringWithFormat:@"%02lu",i]];
            }
        }
        
        arrDay = [[NSMutableArray alloc]init];
        if (arrMonth.count == 1) {
            for (NSUInteger i = [minDate day]; i <= [maxDate day]; i++) {
                [arrDay addObject:[NSString stringWithFormat:@"%02lu",i]];
            }
        }else{
            for (NSUInteger i = 1; i <= 31; i++) {
                [arrDay addObject:[NSString stringWithFormat:@"%02lu",i]];
            }
        }
        
        if (pickStyle == PickerYMDHM) {
            arrHour = [[NSMutableArray alloc]init];
            if (arrDay.count == 1) {
                for (NSUInteger i = [minDate hour]; i <= [maxDate hour]; i++) {
                    [arrHour addObject:[NSString stringWithFormat:@"%02lu",i]];
                }
            }else{
                for (NSUInteger i = 0; i <= 23; i++) {
                    [arrHour addObject:[NSString stringWithFormat:@"%02lu",i]];
                }
            }
            arrMinute = [[NSMutableArray alloc]init];
            if (arrHour.count == 1) {
                for (NSUInteger i = [minDate minute]; i <= [maxDate minute]; i++) {
                    [arrMinute addObject:[NSString stringWithFormat:@"%02lu",i]];
                }
            }else{
                for (NSUInteger i = 0; i <= 59; i++) {
                    [arrMinute addObject:[NSString stringWithFormat:@"%02lu",i]];
                }
            }
        }
    }else  if (pickStyle == PickerHM) {
        arrHour = [[NSMutableArray alloc]init];
        for (NSUInteger i = [minDate hour]; i <= [maxDate hour]; i++) {
            [arrHour addObject:[NSString stringWithFormat:@"%02lu",i]];
        }
        arrMinute = [[NSMutableArray alloc]init];
        if (arrHour.count == 1) {
            for (NSUInteger i = [minDate minute]; i <= [maxDate minute]; i++) {
                [arrMinute addObject:[NSString stringWithFormat:@"%02lu",i]];
            }
        }else{
            for (NSUInteger i = 0; i <= 59; i++) {
                [arrMinute addObject:[NSString stringWithFormat:@"%02lu",i]];
            }
        }
    }
    
    
    if (firstTimeLoad) {
        
    }
    self.delegate = self;
    self.dataSource = self;
    [self setSelectedDate:_selectedDate];
}

-(void)reloadByMinMaxDate{
    if (pickStyle == PickerYMDHM || pickStyle == PickerYMD) {
        [self reloadComponent:0];
        [self reloadComponent:1];
        [self reloadComponent:2];
        [self reloadComponent:3];
        [self reloadComponent:4];
    }else if (pickStyle == PickerYMD) {
        [self reloadComponent:0];
        [self reloadComponent:1];
        [self reloadComponent:2];
    }else  if (pickStyle == PickerHM) {
        [self reloadComponent:0];
        [self reloadComponent:1];
    }
}

- (void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    
    
    // Get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    _year = [NSString stringWithFormat:@"%@", [formatter stringFromDate:_selectedDate]];
    // Get Current  Month
    [formatter setDateFormat:@"MM"];
    _month= [NSString stringWithFormat:@"%@",[formatter stringFromDate:_selectedDate]];
    
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    _day = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_selectedDate]];
    
    // Get Current  Hour
    [formatter setDateFormat:@"HH"];
    _hour = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_selectedDate]];
    
    // Get Current  Minutes
    [formatter setDateFormat:@"mm"];
    _minute = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_selectedDate]];
    
    
    
    rowYear = [arrYear indexOfObject:_year];
    [self reArrayMonth];
    rowMonth = [arrMonth indexOfObject:_month];
    [self reArrayDay];
    rowDay = [arrDay indexOfObject:_day];
    [self reArrayHour];
    rowHour = [arrHour indexOfObject:_hour];
    [self reArrayMinute];
    
    rowMinute = [arrMinute indexOfObject:_minute];
 
    if (pickStyle == PickerYMDHM || pickStyle == PickerYMD) {
        [self selectRow:rowYear inComponent:0 animated:YES];
        [self selectRow:rowMonth inComponent:1 animated:YES];
        [self selectRow:rowDay inComponent:2 animated:YES];
    }
    
    if (pickStyle == PickerYMDHM) {
        [self selectRow:rowHour inComponent:3 animated:YES];
        [self selectRow:rowMinute inComponent:4 animated:YES];
    }else if (pickStyle == PickerHM) {
        [self selectRow:rowHour inComponent:0 animated:YES];
        [self selectRow:rowMinute inComponent:1 animated:YES];
    }
    
    NSLog(@"setSelectedDate   %@-%@-%@-%@-%@",_year,_month,_day,_hour,_minute);
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //年月时不管如何reload，分钟是不reload，其他若极限值reload
    if (pickStyle == PickerYMDHM || pickStyle == PickerYMD) {
        if (component == 0){
            rowYear = row;
            _year = arrYear[rowYear];
            [self reArrayMonth];
            [self reArrayDay];
            [self reArrayHour];
            [self reArrayMinute];
        }else if (component == 1){
            rowMonth= row;
            _month = arrMonth[rowMonth];
            [self reArrayDay];
            [self reArrayHour];
            [self reArrayMinute];
        }else if (component == 2){
            rowDay= row;
            _day = arrDay[rowDay];
            [self reArrayHour];
            [self reArrayMinute];
        }else if (component == 3){
            rowHour= row;
            _hour = arrHour[rowHour];
            [self reArrayMinute];
        }else if (component == 4){
            rowMinute= row;
            _minute = arrMinute[rowMinute];
        }
    }else if (pickStyle == PickerYMD) {
        if (component == 0){
            rowYear = row;
            _year = arrYear[rowYear];
            [self reArrayMonth];
            [self reArrayDay];
        }else if (component == 1){
            rowMonth= row;
            _month = arrMonth[rowMonth];
            [self reArrayDay];
        }else if (component == 2){
            rowDay= row;
            _day = arrDay[rowDay];
        }
    }else if (pickStyle == PickerHM) {
        if (component == 0){
            rowHour= row;
            _hour = arrHour[rowHour];
            [self reArrayMinute];
        }else if (component == 1){
            rowMinute= row;
            _minute = arrMinute[rowMinute];
        }
    }
   
    
    if (_dateTimeChangeBlock) {
        //yyyy-MM-dd HH:mm:ss
        NSString *hour = arrHour[rowHour];
        NSDate *date;
        if (pickStyle == PickerYMDHM) {
            date = [NSDate dateFromString:[NSString stringWithFormat:@"%@-%@-%@ %@:%@", arrYear[rowYear], arrMonth[rowMonth], arrDay[rowDay], hour, arrMinute[rowMinute]]];
            _dateTimeChangeBlock(self, date);
        }else if (pickStyle == PickerYMD) {
            date = [NSDate dateFromString:[NSString stringWithFormat:@"%@-%@-%@", arrYear[rowYear], arrMonth[rowMonth], arrDay[rowDay]]];
            _dateTimeChangeBlock(self, date);
        }else if (pickStyle == PickerHM) {
            date = [NSDate dateFromString:[NSString stringWithFormat:@"%@:%@", hour, arrMinute[rowMinute]]];
            _dateTimeChangeBlock(self, date);
        }
    }
    NSLog(@"didSelectRow  %@-%@-%@-%@-%@",_year,_month,_day,_hour,_minute);
}


#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
        pickerLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        pickerLabel.textColor = [UIColor redColor];
        
    }
    
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    NSString *str;
    if (component == 0){
        if (pickStyle == PickerYMDHM || pickStyle == PickerYMD) {
            pickerLabel.textAlignment = NSTextAlignmentRight;
            str =[NSString stringWithFormat:@"%@年", [arrYear objectAtIndex:row]] ;
        }else if (pickStyle == PickerHM) {
            str =[NSString stringWithFormat:@"%@时",  [arrHour objectAtIndex:row]];
        }
    }else if (component == 1){
        if (pickStyle == PickerYMDHM || pickStyle == PickerYMD) {
            str = [NSString stringWithFormat:@"%@月", [arrMonth objectAtIndex:row]];
        }else if (pickStyle == PickerHM) {
            str =[NSString stringWithFormat:@"%@分",  [arrMinute objectAtIndex:row]];
        }
    }else if (component == 2){
        str = [NSString stringWithFormat:@"%@日", [arrDay objectAtIndex:row]];
    }else if (component == 3){
        str =[NSString stringWithFormat:@"%@时",  [arrHour objectAtIndex:row]];
    }else if (component == 4){
        str =[NSString stringWithFormat:@"%@分",  [arrMinute objectAtIndex:row]];
        
        pickerLabel.textAlignment = NSTextAlignmentLeft;
    }
    pickerLabel.text =  str; // Year
    return pickerLabel;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (pickStyle == PickerYMDHM) {
        CGFloat ww = self.frame.size.width;
        CGFloat percent = 2.0/11.0;
        CGFloat aa = (ww * percent);
        if(component==0){
            aa = aa + 10.0;
        }
        return aa;
    }else if (pickStyle == PickerYMD) {
        return self.frame.size.width/3;
    }else if (pickStyle == PickerHM) {
        return self.frame.size.width/2;
    }else{
        return 0;
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickStyle == PickerYMDHM) {
        return 5;
    }else if (pickStyle == PickerYMD) {
        return 3;
    }else if (pickStyle == PickerHM) {
        return 2;
    }else{
        return 0;
    }
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSUInteger rows = 0;
    if (component == 0){
        if (pickStyle == PickerYMDHM || pickStyle == PickerYMD) {
            rows = [arrYear count];
        }else if (pickStyle == PickerHM) {
            rows = [arrHour count];
        }
    }else if (component == 1) {
        if (pickStyle == PickerYMDHM || pickStyle == PickerYMD) {
            rows = [arrMonth count];
        }else if (pickStyle == PickerHM) {
            rows = [arrMinute count];
        }
    }else if (component == 2) { // day
        rows = arrDay.count;
    }else if (component == 3){ // hour
        rows =  arrHour.count;
    }else if (component == 4){ // min
        rows =  arrMinute.count;
    }
    return rows ;
}

-(NSInteger) daysOfYear:(NSInteger)year month:(NSInteger)month{
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12){
        return 31;
    }else if (month == 2){
        int year = [[arrYear objectAtIndex:rowYear] intValue];
        if(((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)){
            return  29;
        }else{
            return 28;
        }
    } else{
        return 30;
    }
}

-(void)reArrayMonth{
    BOOL isFirstYear = (rowYear == 0) && _minDate;
    BOOL isLastYear = (rowYear == arrYear.count - 1) && _maxDate;
    //如果选择的是最早的year或者最迟的year
    [arrMonth removeAllObjects];
    if (isFirstYear || isLastYear) {
        //如果有多个year
        if (arrYear.count > 1) {
            if (isFirstYear) {
                for (NSUInteger i = [_minDate month]; i <= 12; i++) {
                    [arrMonth addObject:[NSString stringWithFormat:@"%02lu",i]];
                }
            }else if (isLastYear) {
                for (NSUInteger i = 1; i <= [_maxDate month]; i++) {
                    [arrMonth addObject:[NSString stringWithFormat:@"%02lu",i]];
                }
            }
        }else{
            //如果只有1个year
            for (NSUInteger i = [_minDate month]; i <=  [_maxDate month]; i++) {
                [arrMonth addObject:[NSString stringWithFormat:@"%02lu",i]];
            }
        }
    }else{
        for (NSUInteger i = 1; i <= 12; i++) {
            [arrMonth addObject:[NSString stringWithFormat:@"%02lu",i]];
        }
    }
    
    if (pickStyle == PickerYMDHM || pickStyle == PickerYMD) {
        rowMonth = [arrMonth indexOfObject:_month];
        if(rowMonth < 0 || rowMonth > arrMonth.count - 1){
            rowMonth = 0;
            _month = arrMonth[rowMonth];
        }
        [self reloadComponent:1];
        [self selectRow:rowMonth inComponent:1 animated:NO];
    }
}

-(void)reArrayDay{
    BOOL isFirstYearMonth = (rowYear == 0) && (rowMonth == 0) && _minDate;
    BOOL isLastYearMonth = (rowYear == arrYear.count - 1)  && (rowMonth == arrMonth.count - 1) && _maxDate;
    [arrDay removeAllObjects];
    //如果选择的是最早的yearMonth或者最迟的yearMonth
    if ( isFirstYearMonth || isLastYearMonth) {
        //如果有多个Month
        if (arrMonth.count > 1) {
            if (isFirstYearMonth) {
                NSInteger days = [self daysOfYear:[arrYear[rowYear] integerValue] month:[arrMonth[rowMonth] integerValue]];
                for (NSUInteger i = [_minDate day]; i <= days; i++) {
                    [arrDay addObject:[NSString stringWithFormat:@"%02lu",i]];
                }
            }else if (isLastYearMonth) {
                for (NSUInteger i = 1; i <= [_maxDate day]; i++) {
                    [arrDay addObject:[NSString stringWithFormat:@"%02lu",i]];
                }
            }
        }else{
            //如果只有1个Month
            for (NSUInteger i = [_minDate day]; i <=  [_maxDate day]; i++) {
                [arrDay addObject:[NSString stringWithFormat:@"%02lu",i]];
            }
        }
    }else{
        NSInteger days = [self daysOfYear:[arrYear[rowYear] integerValue] month:[arrMonth[rowMonth] integerValue]];
        for (NSUInteger i = 1; i <= days; i++) {
            [arrDay addObject:[NSString stringWithFormat:@"%02lu",i]];
        }
    }
    
    if (pickStyle == PickerYMDHM || pickStyle == PickerYMD) {
        rowDay = [arrDay indexOfObject:_day];
        if(rowDay < 0 || rowDay > arrDay.count - 1){
            rowDay = 0;
            _day = arrDay[rowDay];
        }
        [self reloadComponent:2];
        [self selectRow:rowDay inComponent:2 animated:NO];
    }
}

-(void)reArrayHour{
    BOOL isFirstYearMonthDay = (rowYear == 0) && (rowMonth == 0) && (rowDay == 0) && _minDate;
    BOOL isLastYearMonthDay = (rowYear == arrYear.count - 1)  && (rowMonth == arrMonth.count - 1) && (rowDay == arrDay.count - 1) && _maxDate;
    [arrHour removeAllObjects];
    //如果选择的是最早的yearMonthDay或者最迟的yearMonthDay
    if (isFirstYearMonthDay || isLastYearMonthDay) {
        //如果有多个Day
        if (arrDay.count > 1) {
            if (isFirstYearMonthDay) {
                for (NSUInteger i = [_minDate hour]; i <= 23; i++) {
                    [arrHour addObject:[NSString stringWithFormat:@"%02lu",i]];
                }
            }else if (isLastYearMonthDay) {
                for (NSUInteger i = 1; i <= [_maxDate hour]; i++) {
                    [arrHour addObject:[NSString stringWithFormat:@"%02lu",i]];
                }
            }
        }else{
            //如果只有1个Day
            for (NSUInteger i = [_minDate hour]; i <=  [_maxDate hour]; i++) {
                [arrHour addObject:[NSString stringWithFormat:@"%02lu",i]];
            }
        }
    }else{
        for (NSUInteger i = 1; i <= 23; i++) {
            [arrHour addObject:[NSString stringWithFormat:@"%02lu",i]];
        }
    }
    
    rowHour = [arrHour indexOfObject:_hour];
    if(rowHour < 0 || rowHour > arrHour.count - 1){
        rowHour = 0;
        _hour = arrHour[rowHour];
    }
    if (pickStyle == PickerYMDHM ) {
        [self reloadComponent:3];
        [self selectRow:rowHour inComponent:3 animated:NO];
    }
}

-(void)reArrayMinute{
    BOOL isFirstYearMonthDayHour = (rowYear == 0) && (rowMonth == 0) && (rowDay == 0) && rowHour == 0 && _minDate;
    BOOL isLastYearMonthDayHour = (rowYear == arrYear.count - 1)  && (rowMonth == arrMonth.count - 1) && (rowDay == arrDay.count - 1)&& (rowHour == arrHour.count - 1) && _maxDate;
    [arrMinute removeAllObjects];
    //如果选择的是最早的yearMonthDay或者最迟的yearMonthDay
    if (isFirstYearMonthDayHour || isLastYearMonthDayHour) {
        //如果有多个Hour
        if (arrHour.count > 1) {
            if (isFirstYearMonthDayHour) {
                for (NSUInteger i = [_minDate minute]; i <= 59; i++) {
                    [arrMinute addObject:[NSString stringWithFormat:@"%02lu",i]];
                }
            }else if (isLastYearMonthDayHour) {
                for (NSUInteger i = 0; i <= [_maxDate minute]; i++) {
                    [arrMinute addObject:[NSString stringWithFormat:@"%02lu",i]];
                }
            }
        }else{
            //如果只有1个Hour
            for (NSUInteger i = [_minDate minute]; i <=  [_maxDate minute]; i++) {
                [arrMinute addObject:[NSString stringWithFormat:@"%02lu",i]];
            }
        }
    }else{
        for (NSUInteger i = 0; i <= 59; i++) {
            [arrMinute addObject:[NSString stringWithFormat:@"%02lu",i]];
        }
    }
    
    
    
    rowMinute = [arrMinute indexOfObject:_minute];
    if(rowMinute < 0 || rowMinute > arrMinute.count - 1){
        rowMinute = 0;
        _minute = arrMinute[rowMinute];
    }
    
    if (pickStyle == PickerYMDHM ) {
        [self reloadComponent:4];
        [self selectRow:rowMinute inComponent:4 animated:NO];
    }else  if (pickStyle == PickerHM ){
        [self reloadComponent:1];
        [self selectRow:rowMinute inComponent:4 animated:NO];
    }
}
@end

