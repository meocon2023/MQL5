//+------------------------------------------------------------------+
//|                                                       Study1.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| Properties                                   |
//+------------------------------------------------------------------+
CTrade cTrade;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   Print("OnInit(s)=", _Symbol);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

   printf("OnDeinit", reason);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      double ema15 = iMA(_Symbol, PERIOD_CURRENT, 15 ,0,MODE_EMA, PRICE_CLOSE);
      Print("EMA 15 =", ema15);
  }
//+------------------------------------------------------------------+
