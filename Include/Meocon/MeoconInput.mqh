//+------------------------------------------------------------------+
//|                                                  MeoconInput.mqh |
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
#include <Meocon\Common.mqh>
#include <Meocon\Candle.mqh>

//+------------------------------------------------------------------+
//| Meocon Expert advisor inputs                                     |
//+------------------------------------------------------------------+ 
input int   ma_trend_period            = 89; // MA trend period (21-34-89)
input int   ma_signal_1_period         = 13; // EMA short 1 signal period (13)
input int   ma_signal_2_period         = 21; // EMA short 2 signel perid (21)
input int   ma_signal_3_period         = 34; // EMA short 3 signel perid (34)


input int   rsi_period                 = 14; // RSI period
input int   rsi_ma_1_period            = 9;  // MA in RSI signal 1 period (9)
input int   rsi_ma_2_period            = 34; // MA in RSI signal 2 period (34)

input int   rsi_overbought             = 70; // RSI over bought value (90)
input int   rsi_oversold               = 30; // RSI over sold value (30)
input int   rsi_up_condition           = 40; // RSI value to buy (40)
input int   rsi_down_condition         = 60; // RSI value to sell

// Trade info
input double lot_size                  = 0.01; // Lot size
input int   maximum_pips_sl            = 15;   // Maximum Pips to SL //( 1pip : 1 lot = 10 usd, 0.01 = 0.1 usd => 15 pips vs 0.01 lot = 1.5 usd
input int   rr                         = 3;    // Risk: Reward ratio (6)
input int   cancel_order_after_num_candles = 5; // Cancel pending orders after candles

input Strategy  strategy  = S1;
