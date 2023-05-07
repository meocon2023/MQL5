//+------------------------------------------------------------------+
//|                                                   adx_signal.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade/Trade.mqh>
#include <Expert\Trailing\TrailingMA.mqh>

int adx_handle;
int ema_handle, ema_fast_handle, ema_signal_handle;
int rsi_handle, ema_rsi_handle;
int barsTotal;

CTrade trade;
CTrailingMA trailingMa;

input int                  adx_period=89;  
input int                  ema_period=89;  
input int                  ema_slow_period=34;  
input int                  ema_signal_period=13;  
input int rsi_period = 14;
input int ema_rsi_period = 34;
input double  TP_DELTA = 600;
input double  SL_DELTA = 300;
input double LOT = 0.01;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   barsTotal = Bars(_Symbol, PERIOD_CURRENT);
   adx_handle = iADX(_Symbol,PERIOD_CURRENT, adx_period);
   ema_handle = iMA(_Symbol, PERIOD_CURRENT,ema_period,0,MODE_EMA,PRICE_CLOSE);
   ema_fast_handle = iMA(_Symbol, PERIOD_CURRENT,ema_slow_period,0,MODE_EMA,PRICE_CLOSE);
   ema_signal_handle = iMA(_Symbol, PERIOD_CURRENT,ema_signal_period,0,MODE_EMA,PRICE_CLOSE);
   rsi_handle = iRSI(_Symbol, PERIOD_CURRENT, rsi_period, PRICE_CLOSE);
   ema_rsi_handle = iMA(_Symbol, PERIOD_CURRENT, ema_rsi_period,0, MODE_EMA, rsi_handle);

   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
      
      IndicatorRelease(adx_handle);
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

ema_rsi_handle = iMA(_Symbol, PERIOD_CURRENT, ema_rsi_period,0, MODE_EMA, rsi_handle);
      int bars = Bars(_Symbol, PERIOD_CURRENT);
      if (barsTotal >= bars) {
         return; // only trade if there is a new bar
      }
      barsTotal = bars;
      
      if (PositionsTotal() > 0) {
         return;
      }
      
      double adx_values[], plus_values[], minus_values[];
      double ema_values[], ema_fast_values[];
      CopyBuffer(adx_handle, 0, 1, 2, adx_values);
      CopyBuffer(adx_handle, 1, 1, 2, plus_values);
      CopyBuffer(adx_handle, 2, 1, 2, minus_values);

      CopyBuffer(ema_handle, 0, 1,2, ema_values);
      CopyBuffer(ema_fast_handle, 0, 1,2, ema_fast_values);
      
     
     /* if (adx_values[0] < 8) {
         //return;
      }
      
      double close1 = iClose(_Symbol, PERIOD_CURRENT,1);
      
      
      switch(TestCross(plus_values, minus_values)) {
         case 0:
            break;
         case 1:
            if (close1 > ema_values[0])
            {
               Buy();
            }
            
            break;
         case -1:
            if (close1 < ema_values[0]) {
               Sell();
            }
            
            break;
      }
      */
      
      // EMA cross
      switch(EMACross(ema_fast_values, ema_values)) {
         case 1:
            if(plus_values[0] > minus_values[0]) {
               Buy();
            }
            break;
            
         case -1: 
            if(plus_values[0] < minus_values[0]) {
               Sell();
            }
            break;
         
      }
 
   
  }
  
  int EMACross(const double &fast[], const double &trend[]) {
      if (fast[1] < trend[1] && fast[0] > trend[0]) {
         return -1;
      }
      
      if (fast[1] > trend[1] && fast[0] < trend[0]) {
         return 1;
      }
      
      return 0;
  }
  

void Sell() {
            Print("Buy signal... you should trade");
            double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            bid = NormalizeDouble(bid, _Digits);
            double sl = NormalizeDouble(bid + SL_DELTA, _Digits);
            double tp = NormalizeDouble(bid - TP_DELTA, _Digits);
            trade.Sell(LOT, _Symbol,bid,sl, tp,"MeoCon Signal Sell");
}

void Buy() {
            Print("Buy signal... you should trade");
            double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            ask = NormalizeDouble(ask, _Digits);
            double sl = NormalizeDouble(ask - SL_DELTA, _Digits);
            double tp = NormalizeDouble(ask + TP_DELTA, _Digits);
            trade.Buy(LOT, _Symbol,ask,sl, tp,"MeoCon Signal Buy");
}

int TestCross(const double &plus[], const double &minus[]) {
   if (plus[1] < minus[1] && plus[0] > minus[0]) {
      return 1;// D+ cross up
   }
   
   if (plus[1] > minus[1] && plus[0] < minus[0]) {
      return -1;// D+ cross up
   }
   
   return 0;
}
//+------------------------------------------------------------------+
