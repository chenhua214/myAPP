//
//  BSPowerBankDevice.m
//  JDKJAPP
//
//  Created by chen on 2026/1/13.
//

#import "BSPowerBankDevice.h"
#import "BSDeviceCRC.h"
#import "BSPowerBankBLE.h"
//#import "BSFridgeDevice+Utils.h"
@interface BSPowerBankDevice()

/// 写入指令时的倍数
@property (nonatomic, strong) NSDictionary *w_multipleDict;
/// 存放指令的数组
@property (nonatomic, strong) NSMutableArray <NSData *> *commandArray;
/// 指令队列定时器
@property (nonatomic, strong) dispatch_source_t commandTimer;
/// 销毁定时器时间
@property (nonatomic, assign) double cancelTimerTime;

@property (nonatomic, strong) NSArray <NSString *> *typecTypeArray;

@end


@implementation BSPowerBankDevice

- (void)dealloc {
    [self cancelCommandTimer];
}

- (void)cancelCommandTimer
{
    if (!self.commandTimer) return;
    dispatch_source_cancel(self.commandTimer);
    self.commandTimer = nil;
    NSLog(@"\n*\n* ⭐️ commandTimer 销毁 \n*");
}

#pragma mark- BSBaseusBLEDelegate

- (void)didUpdateValue:(NSData *)value
{
    NSLog(@"⭐️ didUpdateValue  ： %@   sn====%@",value,self.identifier);
    if (![self commandDataCRCFitBill:value]) {
        NSLog(@"⚠️ 数据返回错误，CRC校验失败");
//        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UInt8 *command = (UInt8 *)[value bytes];
        [self didUpdateCommand:command value:value];
    });
    
//    aa12
//    0214
//    6414
//    0100
//    0a00
//    0000 0000
//    0000 0000
//    840c 0000
//    0001 3c55
    
    
}

- (void)didUpdateCommand:(UInt8 *)command value:(NSData *)value {
   
    if (command[1] == 0x02 && value.length >= 7) {
        [self readValueReturnCommand:command blockDataRange:k_Range2_3 value:value];
    } else if (command[2] == 0x10 && value.length == 9) {
//        [self writeValueReturnCommand:command responseBlockDataRange:k_Range2_3 value:value];
    }
    else {
        
    }
    
//    aa12
//    020a
//    
//    6414
//    0200
//    0a00
//    0000
//    0000
//    
//    a255
    
}

- (void)readValueReturnCommand:(UInt8 *)command blockDataRange:(NSString *)range value:(NSData *)value
{
    NSData *dataD = [value subdataWithRange:NSRangeFromString(range)];
    BSBLEResponse *response = [self responseWithCommandByte:dataD];
    short multiple = command[6];
    long  result = command[7] << 8 | command[8];
    id number = @(result / (float)multiple);
    UInt8 command4 = command[4];
    NSLog(@"⭐️ command4  ： %hhu   Value====%@",command4,number);
    
#pragma mark : 实际温度-100℃，不需放大，单位℃
//    if ([self command:command4 isEqual:BSPowerBankCmdBatteryT]) {
//        number = @([number floatValue] - 100);
//        self.deviceTemp = [number floatValue];
//        self.deviceTempStr = [NSString stringWithFormat:@"%ld",(long)self.deviceTemp] ;
//    }
    
    if (response && response.commandBlock) {
        response.commandBlock(YES,number);
    }
    if (self.dataDidChangedBlock) {
        self.dataDidChangedBlock(YES);
    }
}


/// 读取 BSEnergyCommand 信息
- (void)readValueWithCommand:(BSPowerBankCommand)command block:(BSResponseBlock)block
{
    NSString *commandStr = [NSString stringWithFormat:@"%04lx",command];
    commandStr = [NSString stringWithFormat:@"%@%@%@",@"AAAA03",commandStr,@"0001"];
    [self writeCommand:commandStr end:nil responseBlockDataRange:k_Range2_3 block:block];
}

/// 读取 BSEnergyCommand 信息  
- (void)readValueWithCommand:(BSPowerBankCommand)command continuity:(BOOL)isContinuity length:(NSInteger)length block:(BSResponseBlock)block
{
    
    
//    NSString *commandStr2222 = [NSString stringWithFormat:@"%02lx",25];
//    NSString *commandStr22223 = [NSString stringWithFormat:@"%02x",258];
    /// 功能码
    NSString *commandStr = [NSString stringWithFormat:@"%02lx",command];
    /// 连续长度
    NSString *LngthStr = [NSString stringWithFormat:@"%02lx",length];
    /// 是否  连续操作：
    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
    /// Bit4  连续操作： 0x00：否  0x01：是
    if (isContinuity) {
        commandStr = [NSString stringWithFormat:@"%@%@%@",@"10",commandStr,LngthStr];
    }
    
   
    [self writeCommand:commandStr end:@"55" responseBlockDataRange:k_Range2_2 block:block];
}




/// 写入数据
- (void)writeData:(NSData *)data responseBlockData:(NSData *)blockData block:(BSResponseBlock)block
{
    [self addBleCommandByte:blockData responseBlock:block];
    [self addCommandData:data];
}

- (void)writeData:(NSInteger)data command:(BSPowerBankCommand)command block:(nonnull BSResponseBlock)block {
//    0xaa11
//    3202
//    1500
//    5a55
}

- (void)writeWithCommand:(BSPowerBankCommand)command continuity:(BOOL)isContinuity length:(NSInteger)length block:(BSResponseBlock)block;
{
    /// 功能码
    NSString *commandStr = [NSString stringWithFormat:@"%02lx",BSPowerBankCmdClock_RW_open];
    /// 连续长度
    NSString *LngthStr = [NSString stringWithFormat:@"%02x",1];
    /// 是否  连续操作：
    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
    /// Bit4  连续操作： 0x00：否  0x01：是
    if (isContinuity) {
        commandStr = [NSString stringWithFormat:@"%@%@%@01",@"21",commandStr,LngthStr];
    }
    
//    0xaa11150035025d55
    
   
    [self writeCommand:commandStr end:@"55" responseBlockDataRange:k_Range2_2 block:block];
}

//// 设置屏保文字
- (void)writeThemeTextData:(NSString *)textStr block:(BSResponseBlock)block
{
//    NSString *commandStr = [NSString stringWithFormat:@"%04lx",BSPowerBankCmdTheme_text];
//    commandStr = @"0030" ;
//    NSData *dataenc = [textStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *dateLength = [NSString stringWithFormat:@"%02lx",dataenc.length];
//    NSString *writeStr = [NSString stringWithFormat:@"9AAA1000300001%@01",dateLength];
//    
//    NSMutableData *data = [writeStr convertHexStrToData:writeStr];
//    [data appendData:dataenc];
//    
//    uint16_t crc = [self crcWithData:data];
//    Byte byte[] = {((uint8_t)(crc >> 8)&0xFF),((uint8_t)(crc)&0xFF)};
//    [data appendData:[NSData dataWithBytes:byte length:2]];
//    
//    NSData *dataD = [data subdataWithRange:NSRangeFromString(k_Range2_3)];
//    [self writeData:data responseBlockData:dataD block:block];
//    
}

#pragma mark - TOOLS

- (void)writeCommand:(NSString *)str end:(NSString *)end responseBlockDataRange:(NSString *)range block:(BSResponseBlock)block
{
    
    NSMutableData *headData = [str convertHexStrToData:@"AA"];
   
    NSMutableData *data = [str convertHexStrToData:str];
    ///  校验码 = SUM (指令码 - 数据域)
    NSString* sumStr = [self sumWithData:data];
    data = [str convertHexStrToData:str];
    NSData *dataSum = [sumStr convertHexStrToData:sumStr];
    [data appendData:dataSum];
//    uint16_t crc = [self crcWithData:data];
//    Byte byte[] = {((uint8_t)(crc >> 8)&0xFF),((uint8_t)(crc)&0xFF)};
//    Byte byte[] = {((uint8_t)(crc)&0xFF)};
//    [data appendData:[NSData dataWithBytes:byte length:1]];
    if (end) {
        NSData *endData = [end convertHexStrToData:end];
        [data appendData:endData];
    }
    [headData appendData:data];
    NSData *dataD = [headData subdataWithRange:NSRangeFromString(range)];
    [self writeData:headData responseBlockData:dataD block:block];
}


#pragma mark -+++++++ 队列写入指令 Start +++++++

- (void)addCommandData:(NSData *)data
{
    @synchronized (self.commandArray) {
        [self.commandArray addObject:data];
    }
    [self creatCommandTimer];
}

- (void)creatCommandTimer
{
    if (self.commandTimer) return;
    NSLog(@"⭐️ commandTimer 初始化完成 ");
    double num = 0.120;
    self.commandTimer = [self creatCommandTimerWithInterval:num block:^{
        
        @synchronized (self.commandArray) {
            [self writeCommandData];
        }
        self.cancelTimerTime += num;
        if (self.cancelTimerTime > 2.0) { // 如果没有指令写入，2秒之后销毁定时器
            [self cancelCommandTimer];
            if (!self.isConnected) [self.commandArray removeAllObjects];
        }
    }];
}

- (void)writeCommandData
{
    if (self.commandArray.count == 0) return;
    self.cancelTimerTime = 0; // 有指令写入，销毁定时器时间归零
    NSData *data = [self.commandArray firstObject];
    BSPowerBankBLE *bleDevice  = (BSPowerBankBLE *)self.bleDevice;
    NSLog(@"\n*\n* ⭐️ write data : %@ \n*",data);
    [bleDevice writeCommand:data];
    [self.commandArray removeObject:data];
}


- (dispatch_source_t)creatCommandTimerWithInterval:(double)interval block:(dispatch_block_t)handler
{
    // 在线程执行
    // dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建一个定时器
    // Dispatch Source Timer 是间隔定时器，也就是说每隔一段时间间隔定时器就会触发。在 NSTimer 中要做到同样的效果需要手动把 repeats 设置为 YES。
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 开始执行时间
    // dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_time_t start = dispatch_walltime(NULL, 0);
    /**
     * 设置时间
     *
     * 第二个参数，当我们使用dispatch_time 或者 DISPATCH_TIME_NOW 时，系统会使用默认时钟来进行计时。然而当系统休眠的时候，默认时钟是不走的，也就会导致计时器停止。
     * 使用 dispatch_walltime 可以让计时器按照真实时间间隔进行计时。
     *
     * 第四个参数 leeway 指的是一个期望的容忍时间，将它设置为 1 秒，意味着系统有可能在定时器时间到达的前 1 秒或者后 1 秒才真正触发定时器。
     * 在调用时推荐设置一个合理的 leeway 值。需要注意，就算指定 leeway 值为 0，系统也无法保证完全精确的触发时间，只是会尽可能满足这个需求。
     */
    dispatch_source_set_timer(timer, start, interval * NSEC_PER_SEC, 0.010 * NSEC_PER_SEC);
    // 设置回调
    // 这个函数在执行完之后，block 会立马执行一遍，后面隔一定时间间隔再执行一次。而 NSTimer 第一次执行是到计时器触发之后。这也是和 NSTimer 之间的一个显著区别。
    dispatch_source_set_event_handler(timer, handler);
    // 启动定时器
    dispatch_resume(timer);
    
    return timer;
}

- (NSString*)sumWithData:(NSData *)data
{
    return [BSDeviceCRC sumOfData:data];
}

// CRC校验
- (UInt16)crcWithData:(NSData *)data
{
    return [[self class] energyCrcWithData:data];
}

/// CRC校验
+ (UInt16)energyCrcWithData:(NSData *)data
{
    return [BSDeviceCRC crcWithData:data];
}




#pragma mark 校验CRC

/// 返回数据校验CRC是否正确
/// BSEnergyCommand 数据返回末尾不带 "20" 结束符
/// BSEnergyOTACommand 、 BSEnergyLogCommand 返回数据带 "20" 结束符
- (BOOL)commandDataCRCFitBill:(NSData *)data
{
    if (!data || data.length < 4) return NO;
    UInt8 *byte = (UInt8 *)[data bytes];
    uint16_t commandCRC;
    uint16_t crc;
    if ([self isAACommand:byte])
    {
        commandCRC = [self crcWithData:[data subdataWithRange:NSMakeRange(1, data.length-3)]];
        UInt8 *crcData = (UInt8 *)[[data subdataWithRange:NSMakeRange(data.length-2,2)] bytes];
        crc = (crcData[0] << 8 | crcData[1]);
    }
    else {
        return NO;
    }
    return (crc == commandCRC);
}

- (BOOL)isAACommand:(UInt8 *)command
{
    return (command[0] == 0xAA );
}

- (NSMutableArray<NSData *> *)commandArray {
    if (!_commandArray) {
        _commandArray = [NSMutableArray array];
    }
    return _commandArray;
}


@end
