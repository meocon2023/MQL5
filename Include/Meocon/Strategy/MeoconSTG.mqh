//+------------------------------------------------------------------+
//|                                                    MeoconSTG.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Meocon\MeoconInput.mqh>

class MeoconSTG
  {
private:

public:
                     MeoconSTG();
                    ~MeoconSTG();
                     virtual int Execute(Candle &candle, IndicatorRates &indicatorRats) { return 0;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MeoconSTG::MeoconSTG()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MeoconSTG::~MeoconSTG()
  {
  }
//+------------------------------------------------------------------+
