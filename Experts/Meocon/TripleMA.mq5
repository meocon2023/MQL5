//+------------------------------------------------------------------+
//|                                                     TripleMA.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade/Trade.mqh>
#include "Person.mqh"

CTrade trade;
// Parameter
int handleFastMa;
int handleMiddleMa;
int handleSlowMa;
int barsTotal;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   barsTotal = iBars(_Symbol, PERIOD_CURRENT);
   handleFastMa = iMA(_Symbol, PERIOD_CURRENT, 10, 0, MODE_SMA, PRICE_CLOSE);
   handleMiddleMa = iMA(_Symbol, PERIOD_CURRENT, 50, 0, MODE_SMA, PRICE_CLOSE);
   handleSlowMa = iMA(_Symbol, PERIOD_CURRENT, 100, 0, MODE_SMA,PRICE_CLOSE);
  
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   IndicatorRelease(handleFastMa);
   IndicatorRelease(handleMiddleMa);
   IndicatorRelease(handleSlowMa);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
     CPerson person ;
     person.SetName("Chuong");
     string name = person.GetName();
     Print("Myname:", name);
     

     int bars = iBars(_Symbol, PERIOD_CURRENT);
     if (barsTotal < bars) 
     {
      barsTotal = bars;
      if (PositionsTotal() > 0) {
         return;
      }
      double fastMa[], middleMa[], slowMa[];
      CopyBuffer(handleFastMa,MAIN_LINE,1,2, fastMa);
      CopyBuffer(handleMiddleMa,MAIN_LINE,1,2, middleMa);
      CopyBuffer(handleSlowMa,MAIN_LINE,1,2, slowMa);
      double close1 = iClose(_Symbol, PERIOD_CURRENT,1);
      double close2 = iClose(_Symbol, PERIOD_CURRENT,2);
      
      if (fastMa[1] > middleMa[1]&& middleMa[1] > slowMa[1])
      {
         if (close1 > fastMa[1] && close2 < fastMa[0]) 
         {
            Print("Buy signal... you should trade");
            double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            ask = NormalizeDouble(ask, _Digits);
            double sl = NormalizeDouble(middleMa[1], _Digits);
            double tp = ask + (ask - sl) * 0.5;
            tp = NormalizeDouble(tp, _Digits);
            trade.Buy(0.1, _Symbol,ask,sl, tp,"MeoCon Signal");

         }
      }
      
      if (fastMa[1] < middleMa[1]&& middleMa[1] < slowMa[1])
      {
         if (close1 < fastMa[1] && close2 > fastMa[0]) 
         {
            Print("Sell signal... you should trade");
            double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            bid = NormalizeDouble(bid, _Digits);
            double sl = NormalizeDouble(middleMa[1], _Digits);
            double tp = bid - (sl - bid) * 0.5;
            tp = NormalizeDouble(tp, _Digits);            
            trade.Sell(0.1, _Symbol, bid,sl, tp, "MeoCon Sell");
         }
      }
      
      Comment(
      "fastMa:", DoubleToString(fastMa[0], _Digits),
      ",midma:", DoubleToString(middleMa[0], _Digits),
      ",slowMa:", DoubleToString(slowMa[0], _Digits)
      );
     }

  }
  