//+------------------------------------------------------------------+
//|                                            MeoconStupidEA001.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "MeoconStupidStrategy001.mqh"

//+------------------------------------------------------------------+
//| Expert inputs                                                    |
//+------------------------------------------------------------------+
input ENUM_TIMEFRAMES time_frame = PERIOD_M15;
input ENUM_TIMEFRAMES main_time_frame = PERIOD_H4;

input int           ma_signal_trend_period = 21;
input int           ma_signal_1_period = 13;
input int           ma_signal_2_period = 21;
input int           ma_signal_3_period = 34;
input int           ma_trend_period = 89;
      
input int           rsi_period = 14;
input int           ma_rsi_signal_1_period = 9;
input int           ma_rsi_signal_2_period = 21;
input int           ma_rsi_signal_3_period = 34;
input int           ma_rsi_trend_period = 89;



//+------------------------------------------------------------------+
//| Expert handles                                                   |
//+------------------------------------------------------------------+

int           ma_signal_trend_handle;
int           ma_signal_1_handle;
int           ma_signal_2_handle;
int           ma_signal_3_handle;
int           ma_trend_handle;
      
int           rsi_handle;
int           ma_rsi_signal_1_handle;
int           ma_rsi_signal_2_handle;
int           ma_rsi_signal_3_handle;
int           ma_rsi_trend_handle;

//+------------------------------------------------------------------+
//| Expert global parameters                                         |
//+------------------------------------------------------------------+
BaseStrategy *strategy;
int barTotals;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
      barTotals = iBars(_Symbol, time_frame);
      ma_signal_1_handle = iMA(_Symbol, time_frame, ma_signal_1_period,  0, MODE_EMA, PRICE_CLOSE);
      ma_signal_2_handle = iMA(_Symbol, time_frame, ma_signal_2_period,  0, MODE_EMA, PRICE_CLOSE);
      ma_signal_3_handle = iMA(_Symbol, time_frame, ma_signal_3_period,  0, MODE_EMA, PRICE_CLOSE);
      ma_signal_trend_handle = iMA(_Symbol, time_frame, ma_signal_trend_period,  0, MODE_SMA, PRICE_CLOSE);
      ma_trend_handle = iMA(_Symbol, main_time_frame, ma_trend_period,  0, MODE_EMA, PRICE_CLOSE);
      
      ChartIndicatorAdd(0, 0, ma_signal_1_handle);
  
      strategy = new MeoconStupidStrategy001(ma_signal_trend_handle, ma_signal_1_handle, ma_signal_2_handle, ma_signal_3_handle, ma_trend_handle, rsi_handle, ma_rsi_signal_1_handle, ma_rsi_signal_2_handle, ma_rsi_signal_3_handle, ma_rsi_trend_handle);

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      int bars = iBars(_Symbol, time_frame);
      if (bars <= barTotals)  {
         //return;
      }
      
      // New bars
      
      barTotals = bars;
      Decision decided = strategy.Execute();
      printf("Process new bar: %s", string(decided));
   
  }
//+------------------------------------------------------------------+
