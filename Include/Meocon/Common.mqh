//+------------------------------------------------------------------+
//|                                                       Common.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

struct IndicatorRates {
   double ma_trend_val, ma_signal_1_val, ma_signal_2_val, ma_signal_3_val;
   double rsi_val, rsi_ma_1_val, rsi_ma_2_val;
};

enum Strategy  // enumeration of named constants
{
      S1,
      S2,
      S3
};

enum Position {
   Unknow,
   Long,
   Short
};

enum RsiStat {
   Unknow,
   TouchOverSold,
   TouchOverBough,
};

