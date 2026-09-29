//
//  BSPowerBankDevice.h
//  JDKJAPP
//
//  Created by chen on 2026/1/13.
//

#import "BSCommonDevice.h"

NS_ASSUME_NONNULL_BEGIN
#define k_Range2_3  @"2,3"
#define k_Range2_2  @"2,2"
typedef NS_ENUM(NSInteger, BSPowerBankCommand) {
    ///< 放电
    BSPowerBankCmdTypeC1_R_OutputA_L       =  0,     ///<  0x0000  *   TypeC1电流 低字节（毫安）
    BSPowerBankCmdTypeC1_R_OutputA_H       =  1,     ///<  0x0001  *   TypeC1电流 高字节 （毫安）
    BSPowerBankCmdTypeC1_R_OutputV_L       =  2,     ///<  0x0002  *   TypeC1电压 低字节 （毫伏）
    BSPowerBankCmdTypeC1_R_OutputV_H       =  3,     ///<  0x0003  *   TypeC1电压 高字节 （毫伏）
    BSPowerBankCmdTypeC1_R_OutputW_L       =  4,     ///<  0x0004  *   TypeC1功率 低字节（W）
    BSPowerBankCmdTypeC1_R_OutputW_H       =  5,     ///<  0x0005  *   TypeC1功率 高字节（W）
    ///<
    BSPowerBankCmdTypeC2_R_OutputA_L       =  6,     ///<  0x0006  *   TypeC2电流 低字节（毫安）
    BSPowerBankCmdTypeC2_R_OutputA_H       =  7,     ///<  0x0007  *   TypeC2电流 高字节 （毫安）
    BSPowerBankCmdTypeC2_R_OutputV_L       =  8,     ///<  0x0008  *   TypeC2电压 低字节 （毫伏）
    BSPowerBankCmdTypeC2_R_OutputV_H       =  9,     ///<  0x0009  *   TypeC2电压 高字节 （毫伏）
    BSPowerBankCmdTypeC2_R_OutputW_L       =  10,    ///<  0x000A  *   TypeC2功率 低字节（W）
    BSPowerBankCmdTypeC2_R_OutputW_H       =  11,    ///<  0x000B  *   TypeC2功率 高字节（W）
    BSPowerBankCmdCharge_C1_TCP_Read       =  12,    ///<  0x000C  *   设备C1口协议     BSPowerBankTypecType类别
    BSPowerBankCmdCharge_C2_TCP_Read       =  13,    ///<  0x000D  *   设备C2口协议    BSPowerBankTypecType类别
  
    BSPowerBankCmdTypeUSBA_R_OutputA_L     =  14,     ///<  0x000E  *   USBA 电流 低字节（毫安）
    BSPowerBankCmdTypeUSBA_R_OutputA_H     =  15,     ///<  0x000F  *   USBA 电流 高字节 （毫安）
    BSPowerBankCmdTypeUSBA_R_OutputV_L     =  16,     ///<  0x0010  *   USBA 电压 低字节 （毫伏）
    BSPowerBankCmdTypeUSBA_R_OutputV_H     =  17,     ///<  0x0011  *   USBA 电压 高字节 （毫伏）
    BSPowerBankCmdTypeUSBA_R_OutputW       =  18,     ///<  0x0012  *   USBA功率 （W）（不分高低字节）
    BSPowerBankCmdCharge_USBA_TCP_Read     =  19,     ///<  0x0013  *   USBA协议    BSPowerBankTypecType类别
    
    BSPowerBankCmdDevice_state_Read             =  21,    ///<  0x0015  *   设备状态寄存器       详情见备注2
    BSPowerBankCmdBatteryNumber_Read            =  22,    ///<  0x0016  *   电池电量   （0-100%）
    BSPowerBankCmdBatteryT_Read                 =  23,    ///<  0x0017  *   电池温度    单位：°C
    
    BSPowerBankCmdBattery_V_L_Read              =  24,    ///<  0x0018  *   电池电压低节（毫伏）
    BSPowerBankCmdBattery_V_H_Read              =  25,    ///<  0x0019  *   电池电压高节（毫伏）
    BSPowerBankCmdBattery_A_L_Read              =  26,    ///<  0x001A  *   电池电流低节（毫安）
    BSPowerBankCmdBattery_A_H_Read              =  27,    ///<  0x001B  *   电池电流高节（毫按）
    ///<
    BSPowerBankCmdBattery_LoopNum_L_Read        =  28,    ///<  0x001C  *   电池循环次数低字节（次）
    BSPowerBankCmdBattery_LoopNum_H_Read        =  29,    ///<  0x001D  *   电池循环次数高字节（次）
    BSPowerBankCmdBattery_State_Read            =  30,    ///<  0x001E  *   电池健康度   0-100%
    ///< 充电‘’
    BSPowerBankCmd_Input_Time_L_Read            =  31,     ///<  0x001F  *   充电剩余时间低字节（分钟）
    BSPowerBankCmd_Input_Time_H_Read            =  32,     ///<  0x0020  *   充电剩余时间高字节（分钟）
    BSPowerBankCmd_Output_Time_L_Read           =  33,     ///<  0x0021  *   放电剩余时间低字节（分钟）
    BSPowerBankCmd_Output_Time_H_Read           =  34,     ///<  0x0022  *   放电剩余时间高字节（分钟）
    ///< 电芯1电压
    BSPowerBankCmdCELL1V_L_Read                 =  35,    ///<  0x0023  *   Cell  1电压低字节（毫伏）
    BSPowerBankCmdCELL1V_H_Read                 =  36,    ///<  0x0024  *   电芯1电压
    BSPowerBankCmdCELL2V_L_Read                 =  37,    ///<  0x0025  *   电芯2电压
    BSPowerBankCmdCELL2V_H_Read                 =  38,    ///<  0x0026  *   电芯2电压
    BSPowerBankCmdCELL3V_L_Read                 =  39,    ///<  0x0027  *   电芯3电压
    BSPowerBankCmdCELL3V_H_Read                 =  40,    ///<  0x0028  *   电芯3电压
    BSPowerBankCmdCELL4V_L_Read                 =  41,    ///<  0x0029  *   电芯4电压
    BSPowerBankCmdCELL4V_H_Read                 =  42,    ///<  0x002A  *   电芯4电压
    BSPowerBankCmdCELL5V_L_Read                 =  43,    ///<  0x002B  *   电芯5电压
    BSPowerBankCmdCELL5V_H_Read                 =  44,    ///<  0x002C  *   电芯5电压
    BSPowerBankCmdCELL6V_L_Read                 =  45,    ///<  0x002D  *   电芯6电压
    BSPowerBankCmdCELL6V_H_Read                 =  46,    ///<  0x002E  *   电芯6电压
    BSPowerBankCmdCELL7V_L_Read                 =  48,    ///<  0x0030  *   电芯7电压
    BSPowerBankCmdCELL7V_H_Read                 =  49,    ///<  0x0031  *   电芯7电压
    ///<  Read  and Write
    BSPowerBankCmdTypeC1_RW_OutputW        =  50,     ///<  0x0032  *  C1 输出功率设置（w）
    BSPowerBankCmdTypeC2_RW_OutputW        =  51,     ///<  0x0033  *  C2 输出功率设置（w）
    BSPowerBankCmdClock_RW_open            =  52,     ///<  0x0034  *  小电流模式设置 0：关闭小电流模式   1：开启小电流模式
    BSPowerBankCmdClock_RW_Time_L          =  53,     ///<  0x0035  *   小电流时间限制低字节（分钟）
    BSPowerBankCmdClock_RW_Time_H          =  54,     ///<  0x0036  *   小电流时间限制高字节（分钟）
    ///<
    BSPowerBankCmdBattery_RW_T_H           =  55,     ///<  0x0037  *  高温保护阈值设置（°C）
    BSPowerBankCmdBattery_RW_T_L           =  56,     ///<  0x0038  *   低温保护阈值设置（°C）
    BSPowerBankCmdBattery_R_state1         =  57,     ///<  0x0039  *   电池状态1   根据AFE分类
    BSPowerBankCmdBattery_R_state2         =  58,     ///<  0x003A  *   电池状态2   根据AFE分类
    BSPowerBankCmdInputType_RW_state_C1    =  59,     ///<  0x003B  * C1充电模式   0：智能模式；1 idle模式； 2 自定义模式（32H生效）
    BSPowerBankCmdInputType_RW_state_C2    =  60,     ///<  0x003C  * C2充电模式   0：智能模式；1 idle模式； 2 自定义模式（32H生效）

    BSPowerBankCmdSttingDevice_W_state     =  61,     ///<  0x003D  *  0xFF恢复出厂设置
    ///<  Bit0 显示时间 1 on/ 0 off    Bit1 成就互动开关1 on/ 0 off  Bit2-3 文字颜色设置 2 浅色/1 深色，0 默认
    BSPowerBankCmdLcdSetting_RW_state      =  62,     ///<  0x003E  *   Lcd 设置
    ///<
    ///<
    BSPowerBankCmdBattery_R_Time_L         =  64,     ///<  0x0040  *   累计放电时长低字节,低8位数据，单位分钟
    BSPowerBankCmdBattery_R_Time_H         =  65,     ///<  0x0041  *   累计放电时长高字节,高8位数据，单位分钟
    BSPowerBankCmdBattery_R_Sum_L          =  66,     ///<  0x0042  *   累计放电量低字节,低8位数据，单位mAH
    BSPowerBankCmdBattery_R_Sum_H          =  67,     ///<  0x0043  *   累计放电量高字节,高8位数据，单位mAH
    ///<
    ///<
    ///<  Bit7 电池充电电压异常
    ///<  Bit6 电池温读异常
    ///<  Bit5 电池异常禁用
    ///<  Bit4 电池欠压异常
    ///<  Bit3 电池过压
    ///<  Bit2-0   没有定义
    BSPowerBankCmdDevice_R_LOG             =  68,     ///<  0x0044  *   设备异常LOG状态
    ///<
    BSPowerBankCmdBattery_R_Number_L       =  69,     ///<  0x0045 *   剩余电量低字节（mAH）
    BSPowerBankCmdBattery_R_Number_H       =  70,     ///<  0x0046  *   剩余电量高字节（mAH）
    ///<
    ///<
    BSPowerBankCmdBlock_Return_state       =  150,     ///<  0x0096  *   从机事件ACK 1个byte数据，0：ok/ 1：err（每条主机的事件和写指令都需要从机回复）
    ///<
    ///<   事件 2个bytes数据，低位在前，高位在后，bit15是使能位，bit0~bit14 定时时间（分钟）
    BSPowerBankCmdClose_E_Time             =  192,     ///<  0x00C0  *   定时关机
    ///<   事件 2个bytes数据，低位在前，高位在后，bit15是使能位，bit0~bit14 定时时间（分钟）
    BSPowerBankCmdClock_E_Time             =  193,     ///<  0x00C1  *   定时提醒
    BSPowerBankCmdSetting_E_Text           =  194,     ///<  0x00C2  *   自定义文字   32bytes 字符串
    
    
    ///< 12bytes 数据一组， 共6组，没有异常以0补。每读一次D0H，读取异常log标号会顺序往下偏移。读取D1H后或者关机重启会清除偏移
    ///< 1 异常数据类型，一个byte；
    ///< 2 电池的编号，一个byte；（异常类型是0x1的时候有效）
    ///< 3 参数(电压，电流，温度等)；2个bytes
    ///< 4 时间戳  8个bytes
    BSPowerBankCmdDevice_R_Log_Data        =  208,     ///<  0x00D0  *   异常日志读取
    ///<  3个byte是数据，读取该寄存器，会清除D0H 异常日志读取地址偏移。
    ///<  异常禁用标志，一个byte；（1代表异常禁用）
    ///<  异常日志存储数量，2个bytes；
    BSPowerBankCmdDevice_R_Log_State       =  209,     ///<  0x00D1  *   异常日志存储状态
    ///<  Block类型 数据长度2bytes
    ///<  1 线材支持的最大电流；
    ///<  2 线材支持的最大功率 （c1 带线，不需要读取）
    BSPowerBankCmdWireRod_R_C1             =  210,     ///<  0x00D2  *   C1 线材信息
    BSPowerBankCmdMessage_R_C1             =  211,     ///<  0x00D3  *   C1 口设备信息  Block类型 数据长度32bytes，字符串类型
    ///<  Block类型 数据长度2bytes
    ///<  1 线材支持的最大电流；
    ///<  2 线材支持的最大功率 （c1 带线，不需要读取）
    BSPowerBankCmdWireRod_R_C2             =  212,     ///<  0x00D4  *   C2 线材信息
    BSPowerBankCmdMessage_R_C2             =  213,     ///<  0x00D5  *   C2 口设备信息  Block类型 数据长度32bytes，字符串类型
    ///< 设备信息  事件    最大32bytes字符串
    BSPowerBankCmdDeviceMessage_E_Model      =  240,     ///<  0x00F0  *   设备型号
    BSPowerBankCmdDeviceMessage_E_Number     =  241,     ///<  0x00F1  *   序列号
    BSPowerBankCmdDeviceMessage_E_Code       =  242,     ///<  0x00F2  *   生产批次
    BSPowerBankCmdDeviceMessage_E_Time       =  243,     ///<  0x00F3  *   生产日期
    BSPowerBankCmdDeviceMessage_E_Capacity   =  244,     ///<  0x00F4  *   额定容量
    BSPowerBankCmdDeviceMessage_E_Voltage    =  245,     ///<  0x00F5  *   标称电压
    BSPowerBankCmdDeviceMessage_E_Maker      =  246,     ///<  0x00F6  *   电池制造商信息
    BSPowerBankCmdDeviceMessage_E_Version    =  247,     ///<  0x00F7  *   版本号
    
    ///<
    ///<  0x0060  *  设置模式状态：0x00标准模式；0x01时间模式；0x02：天气模式；0x03歌词模式；0x04微信模式；0x05 图片投影模式； 0x06 心情模式
    BSPowerBankCmdSetting_RW_Model             =  96,
    ///<  0x0061  *   模式状态：0x00标准模式；0x01时间模式；0x02：天气模式；0x03歌词模式；0x04微信模式；0x05 图片投影模式； 0x06 心情模式
    BSPowerBankCmdSetting_R_Model              =  97,


};

/// 0x0C、0x0D  0x13 设备快充协议寄存器    C1和C2口的协议类型
typedef NS_ENUM(NSInteger, BSPowerBankTypecType) {
    ///< 放电
    BSPowerBankTypecType_IDLE           = 0 ,
    BSPowerBankTypecType_PD             = 1 ,
    BSPowerBankTypecType_QC             = 2 ,
    BSPowerBankTypecType_SCP            = 3 ,
};


///  设备的工作状态
typedef NS_ENUM(NSInteger, BSPowerBankTypeCWork) {
    ///< 放电
    BSPowerBankTypeCWorkNULL               = 0 ,    // C1、C2 都空载
    BSPowerBankTypeCWorkOutput             = 1 ,    // 放电
    BSPowerBankTypeCWorkInput              = 2 ,    // 充电
};


///     备注 2
///     Register  0x0015  *   设备状态寄存器
///     Bit
///     0~7 bit为  设备状态寄存器，
///
///     TypeC1端口异常   Bit
///     0     C1 连接状态
///     1     C2  连接状态保留
///     2     C1  充电1   /    放电 0
///     3     C2  充电1  /    放电 0
///     4     C1  异常
///     5     C2  异常
///     6     C2  Usba连接状态
///     7     C2  小电流模式




@interface BSCommonTypeByteModel : NSObject
///
@property (nonatomic, assign) Byte typeByte_L;
@property (nonatomic, assign) Byte typeByte_H;
@property (nonatomic, assign) NSInteger typeValue;

@end


@interface BSCommonDeviceTypeModel: NSObject
///  接口名称
@property (nonatomic, copy)   NSString* typeName;
///  、电流 （毫安）
@property(nonatomic, strong) BSCommonTypeByteModel *typeModelA;
///  、电压 （毫伏）
@property(nonatomic, strong) BSCommonTypeByteModel *typeModelV;
///  、功率 （W）
@property(nonatomic, strong) BSCommonTypeByteModel *typeModelW;

/// 接口协议类型
@property (nonatomic, assign) BSPowerBankTypecType typeCType;
/// 接口材料
@property (nonatomic, copy)   NSString* typeCMessageName;
/// 接口设备类型
@property (nonatomic, copy)   NSString* typeCTypeMessageDeviceName;
/// 接口材料   最大电流
@property (nonatomic, assign) NSInteger typeCMessageMaxA;
/// 接口材料 最大功率
@property (nonatomic, assign) NSInteger typeCMessageMaxW;

/// 充电1   /    放电 0
@property (nonatomic, assign) NSInteger typeState;
/// 连接1 / 未连接 0
@property (nonatomic, assign) NSInteger typeConnect;
///  异常1 / 未有异常 0
@property (nonatomic, assign) NSInteger typeAlert;
///  输出功率设置 W
@property (nonatomic, assign) NSInteger outputSetW;

@end



@interface BSPowerBankDevice : BSCommonDevice
/// 接口状态
@property (nonatomic, assign) NSInteger typeConnectState;
/// TypeC1
@property(nonatomic, strong) BSCommonDeviceTypeModel *typeC1;
/// TypeC2
@property(nonatomic, strong) BSCommonDeviceTypeModel *typeC2;
/// USBA1
@property(nonatomic, strong) BSCommonDeviceTypeModel *USBA1;
/// 电池  0%-100%  power
//@property (nonatomic, assign) NSInteger batterySOC;
///设备温度  摄氏度
@property (nonatomic, assign) NSInteger deviceTemp;
@property (nonatomic, copy)   NSString* deviceTempStr;
/// 电池电压（毫伏）
@property(nonatomic, strong) BSCommonTypeByteModel *batteryModelV;
/// 电池电流（毫安）
@property(nonatomic, strong) BSCommonTypeByteModel *batteryModelA;
/// 电池循环次数
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCyclesModel;
///  剩余电量
@property(nonatomic, strong) BSCommonTypeByteModel *batterySOCModel;
/// 电池健康度  0-100%
@property (nonatomic, assign) NSInteger batteryState;
/// 充电剩余时间（分钟）
@property(nonatomic, strong) BSCommonTypeByteModel *inputTimeModel;
/// 放电剩余时间（分钟）
@property(nonatomic, strong) BSCommonTypeByteModel *outputTimeModel;
/// 累计放电时长 分钟
@property(nonatomic, strong) BSCommonTypeByteModel *outpuSumTimeModel;
/// 累计放电量 单位mAH
@property(nonatomic, strong) BSCommonTypeByteModel *outpuSumMAHModel;


///  小电流模式状态   0:未处在小电流模式; 1:处在小电流模式;
@property (nonatomic, assign) NSInteger smallAMPType;
/// 小电流时间限制（分钟）
@property(nonatomic, strong) BSCommonTypeByteModel *smallAMPTimeModel;
///设备高温设置保护  摄氏度
@property (nonatomic, assign) NSInteger deviceTempSet_H;
///设备低温设置保护  摄氏度
@property (nonatomic, assign) NSInteger deviceTempSet_L;
///电池状态1
@property (nonatomic, assign) NSInteger batterySOC_state1;
///电池状态2
@property (nonatomic, assign) NSInteger batterySOC_state2;
///模式设置
@property (nonatomic, assign) NSInteger setModel_state;

/// 电池Cell 电压（毫伏）
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_1;
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_2;
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_3;
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_4;
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_5;
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_6;
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_7;



//
///// 倒计时关机时间
//@property (nonatomic, assign) NSInteger typeC_CloseTime;
//@property (nonatomic, copy)   NSString* typeC_CloseTimeStr;
///// 计时时间
//@property (nonatomic, assign) NSInteger clock_CloseTime;
//@property (nonatomic, copy)   NSString* clock_CloseTimeStr;
//
///// 格式: 二进制字符串 eg: 二进制为 1110 1010 -> 倒序后的错误对应为 01010111
//@property (nonatomic, strong) NSArray *localErrorArrayStr;
///// localErrorArray 有值， 说明有异常存在
//@property (nonatomic, strong) NSMutableArray *localErrorArray;
//@property (nonatomic, strong) NSMutableDictionary *localErrorDict;
//@property (nonatomic, copy)   NSString *localErrorWebStr;    // 异常网页参数
///// 格式: 二进制字符串 eg: 二进制为 1110 1010 -> 倒序后的对应为 ["0","1","0","1","0",,"1","1","1"]
//@property (nonatomic, strong) NSString *typeCStateStr;
///// 端口协议
//@property (nonatomic, strong) NSString *typeCTypeStr;
//// param 数据发生变化

@property (nonatomic, copy  ) void (^dataDidChangedBlock)(BOOL success);
// param 数据发生变化
@property (nonatomic, copy  ) void (^dataDidChangedWithInfoBlock)(BOOL success);


/// 读取 BSEnergyCommand 信息
/// command ：开始的功能码（功能码）
/// isContinuity：是否连续
/// length：连续的长度
- (void)readValueWithCommand:(BSPowerBankCommand)command length:(NSInteger)length block:(BSResponseBlock)block;

- (void)readSingleValueWithCommand:(BSPowerBankCommand)command  block:(BSResponseBlock)block;


/// 读取 BSEnergyCommand 信息
/// startCommand ：开始的功能码（功能码）
/// ：是连续
/// endCommand ：结束的功能码（功能码）
- (void)readValueWithStartCommand:(BSPowerBankCommand)startCommand endCommand:(BSPowerBankCommand)endCommand  block:(BSResponseBlock)block;


/// 事件读取信息 BSEnergyCommand 信息
/// startCommand ：开始的功能码（功能码）
/// ：是连续
/// endCommand ：结束的功能码（功能码）
- (void)eventValueWithStartCommand:(BSPowerBankCommand)startCommand endCommand:(BSPowerBankCommand)endCommand  block:(BSResponseBlock)block;

- (void)writeThemeTextData:(NSString *)textStr block:(BSResponseBlock)block ;


///  设置写入单个 信息
/// command ：开始的功能码（功能码）
/// cmdValue：设置值
///
- (void)writeWithSingleCommand:(BSPowerBankCommand)command  cmdValue:(NSInteger)cmdValue block:(BSResponseBlock)block;


///  设置写入高低两个字节 信息
/// command ：开始的功能码（功能码）
/// cmdValue：设置值
- (void)writeWithTwoByteCommand:(BSPowerBankCommand)command  cmdValue:(NSInteger)cmdValue block:(BSResponseBlock)block;

/// command ：开始的功能码（功能码）
/// cmdValue：设置值
- (void)eventWithTwoByteCommand:(BSPowerBankCommand)command  cmdValue:(NSInteger)cmdValue block:(BSResponseBlock)block;


/// command ：读取 Block 事件 （功能码）
/// cmdValue：读取的长度值
- (void)readBlockWithTwoByteCommand:(BSPowerBankCommand)command  cmdValue:(NSInteger)cmdValue block:(BSResponseBlock)block;

/// 写入数据   Array 信息
/// command ：开始的功能码（功能码）
/// length：连续的长度
/// arrWriteData：写入的数据
- (void)writeWithArrayCommand:(BSPowerBankCommand)command length:(NSInteger)length array:(NSArray*)arrWriteData block:(BSResponseBlock)block;
@end

NS_ASSUME_NONNULL_END
