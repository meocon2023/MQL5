//+------------------------------------------------------------------+
//|                                            MeoconStupidEA001.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "MeoconStupidStrategy001.mqh"
#include "MeoconStupidStrategy002.mqh"
#include "MeoconStupidLongTimeFrameStrategy.mqh"
#include "..\..\Util\DrawUtils.mqh"
#include "..\..\Util\CandleUtils.mqh"
#include "..\..\Util\OrderUtils.mqh"

//+------------------------------------------------------------------+
//| Expert inputs                                                    |
//+------------------------------------------------------------------+
input ENUM_TIMEFRAMES time_frame = PERIOD_M15;

input bool           indicatorEnabled = true;


input int           ma_signal_1_period = 13;
input int           ma_signal_2_period = 21;
input int           ma_signal_3_period = 34;
input int           ma_signal_trend_period = 21;

      
input int           rsi_period = 14;
input int           ma_rsi_signal_1_period = 9;
input int           ma_rsi_signal_2_period = 21;
input int           ma_rsi_signal_3_period = 34;

// Long Timeframe
input ENUM_TIMEFRAMES main_time_frame = PERIOD_H1;
input int h1_ma_signal_period = 34;
input int h1_ma_trend_period = 89;

input ulong MAGIC_NUM = 1988;
// order input
input int            pips_sl = 20;
input double         rr = 3;
input double         lot = 0.01;

input bool buy_enabled = true;
input bool sell_enabled = true;
input int pos_limited = 2;

input STRATYGE strategy = S1;




//+------------------------------------------------------------------+
//| Expert handles                                                   |
//+------------------------------------------------------------------+

// M15 Handle

int           ma_signal_trend_handle = -1;
int           ma_signal_1_handle = -1;
int           ma_signal_2_handle = -1;
int           ma_signal_3_handle = -1;
int           ma_trend_handle = -1;
      
int           rsi_handle = -1;
int           ma_rsi_signal_1_handle = -1;
int           ma_rsi_signal_2_handle = -1;
int           ma_rsi_signal_3_handle = -1;

// H1 Handle
int          rsi_h1_handle = -1;
int          ma_rsi_signal_1_h1_handle = -1;
int          h1_ma_signal_handle = -1;
int          h1_ma_trend_handle = -1;

//+------------------------------------------------------------------+
//| Expert global parameters                                         |
//+------------------------------------------------------------------+
BaseStrategy *strategy1, *strategy2;
BaseStrategy *long_time_frame_strategy;
int barTotals;
NormalizedCandle normalized_candle;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
      trade.SetExpertMagicNumber(MAGIC_NUM);
      barTotals = iBars(_Symbol, time_frame);
      normalized_candle = BuildNormalizedCandle(time_frame, 1, 1000);
      
      int subwindow=(int)ChartGetInteger(0,CHART_WINDOWS_TOTAL);   
      
      rsi_handle = iRSI(_Symbol, time_frame, rsi_period, PRICE_CLOSE);
      ma_rsi_signal_1_handle = iMA(_Symbol, time_frame, ma_rsi_signal_1_period, 0,MODE_EMA, rsi_handle);
      ma_rsi_signal_2_handle = iMA(_Symbol, time_frame, ma_rsi_signal_2_period, 0,MODE_EMA, rsi_handle);
      ma_rsi_signal_3_handle = iMA(_Symbol, time_frame, ma_rsi_signal_3_period, 0,MODE_EMA, rsi_handle);
      
      // H1
     
      rsi_h1_handle = iRSI(_Symbol, main_time_frame, rsi_period, PRICE_CLOSE);
      ma_rsi_signal_1_h1_handle = iMA(_Symbol, main_time_frame, ma_rsi_signal_1_period, 0,MODE_EMA, rsi_h1_handle);
            
   if (indicatorEnabled) {
      //ChartIndicatorAdd(0, subwindow, rsi_handle);
      ChartIndicatorAdd(0, subwindow, ma_rsi_signal_1_handle);
      ChartIndicatorAdd(0, subwindow, ma_rsi_signal_2_handle);
      ChartIndicatorAdd(0, subwindow, ma_rsi_signal_3_handle);
      //ChartIndicatorAdd(0, subwindow, ma_rsi_trend_handle);
      ChartIndicatorAdd(0, subwindow, ma_rsi_signal_1_handle);
   }

      ma_signal_1_handle = iMA(_Symbol, time_frame, ma_signal_1_period,  0, MODE_EMA, PRICE_CLOSE);
      ma_signal_2_handle = iMA(_Symbol, time_frame, ma_signal_2_period,  0, MODE_EMA, PRICE_CLOSE);
      ma_signal_3_handle = iMA(_Symbol, time_frame, ma_signal_3_period,  0, MODE_EMA, PRICE_CLOSE);
      ma_signal_trend_handle = iMA(_Symbol, time_frame, ma_signal_trend_period,  0, MODE_SMA, PRICE_CLOSE);
      
      //ma_trend_handle = iMA(_Symbol, main_time_frame, 89,  0, MODE_EMA, PRICE_CLOSE);
      //h1_ma_signal_handle = iMA(_Symbol, main_time_frame, h1_ma_signal_period,  0, MODE_EMA, PRICE_CLOSE); 
      //h1_ma_trend_handle = iMA(_Symbol, main_time_frame, h1_ma_trend_period,  0, MODE_EMA, PRICE_CLOSE); 
      
   if (indicatorEnabled) {
      ChartIndicatorAdd(0, 0, ma_signal_1_handle);
      ChartIndicatorAdd(0, 0, ma_signal_2_handle);
      ChartIndicatorAdd(0, 0, ma_signal_3_handle);
      ChartIndicatorAdd(0, 0, ma_signal_trend_handle);
     //ChartIndicatorAdd(0, 0, ma_trend_handle);
      //ChartIndicatorAdd(0, 0, h1_ma_signal_handle);
      //ChartIndicatorAdd(0, 0, h1_ma_trend_handle);
     
   }
  
      strategy1 = new MeoconStupidStrategy001(ma_signal_trend_handle, ma_signal_1_handle, ma_signal_2_handle, ma_signal_3_handle, ma_trend_handle, rsi_handle, ma_rsi_signal_1_handle, ma_rsi_signal_2_handle, ma_rsi_signal_3_handle, rsi_h1_handle, ma_rsi_signal_1_h1_handle, time_frame);
      strategy2 = new MeoconStupidStrategy002(ma_signal_trend_handle, ma_signal_1_handle, ma_signal_2_handle, ma_signal_3_handle, ma_trend_handle, rsi_handle, ma_rsi_signal_1_handle, ma_rsi_signal_2_handle, ma_rsi_signal_3_handle, rsi_h1_handle, ma_rsi_signal_1_h1_handle, time_frame);

      //long_time_frame_strategy = new MeoconStupidLongTimeFrameStrategy(h1_ma_signal_handle, h1_ma_trend_handle, main_time_frame);
   return(INIT_SUCCEEDED);
  }
  
  
  void DeleteIndicators() {
   // delete indicator using the indicator handle
      int subwindows=ChartGetInteger(0,CHART_WINDOWS_TOTAL);

      for(int i=subwindows;i>=0;i--)
        {
         int indicators=ChartIndicatorsTotal(0,i);

         for(int j=indicators-1; j>=0; j--)
           {
            ChartIndicatorDelete(0,i,ChartIndicatorName(0,i,j));
           }
        }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  
   if (indicatorEnabled) {
         DeleteIndicators();
   }
   IndicatorRelease(ma_signal_trend_handle);
   IndicatorRelease(ma_signal_1_handle);
   IndicatorRelease(ma_signal_2_handle);
   IndicatorRelease(ma_signal_3_handle);
   IndicatorRelease(ma_trend_handle);
   IndicatorRelease(rsi_handle);
   IndicatorRelease(ma_rsi_signal_1_handle);
   IndicatorRelease(ma_rsi_signal_2_handle);
   IndicatorRelease(ma_rsi_signal_3_handle);
   //IndicatorRelease(ma_rsi_trend_handle);
   

   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      int bars = iBars(_Symbol, time_frame);
      if (bars <= barTotals)  {
         return;
      }
      
      // New bars
      barTotals = bars;
      if (barTotals % 100 == 0) {
         normalized_candle = BuildNormalizedCandle(time_frame, 1, 1000);
      }
      ExecutionData data;
      data.normalized_candle = normalized_candle;
      Decision decided = NONE;
      switch(strategy) {
         case S1:
         decided = strategy1.Execute(data);
         break;
         case S2:
         decided = strategy2.Execute(data);
         break;
         case AllStrategy:
         decided = strategy1.Execute(data);
         if (decided == NONE) {
            decided = strategy2.Execute(data);
         }
         break;
      }
      //Decision decided2 = strategy2.Execute(data);
      
      MqlRates rate_buf[];
      CopyRates(_Symbol, time_frame,1, 1, rate_buf);
      
      DrawSignalIndicator(rate_buf[0], decided);
      
      int pos_cnt = CountPosition(_Symbol, MAGIC_NUM);
      printf("POSSSS:%s, LIMIT:%s", string(pos_cnt), string(pos_limited));
      if (pos_cnt >= pos_limited) {
         return;
      }
      


      switch(decided) {
         case NONE:
         break;
         case BUY:
            if (buy_enabled) {
               MakeBuyLimit(rate_buf[0], lot, pips_sl, rr);
            }
         break;
         case SELL:
            if (sell_enabled) {
               MakeSellLimit(rate_buf[0], lot, pips_sl, rr);
            }
            
         break;
      }

  }
//+------------------------------------------------------------------+

void DrawSignalIndicator(MqlRates &atRates, Decision d) {
   switch(d) {
      case NONE:
      break;
      case BUY:
         DrawArrowUp(atRates);
      break;
      case SELL:
         DrawArrowDown(atRates);
      break;
   }
}