//+------------------------------------------------------------------+
//|                                                   MeoconSTG1.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Meocon\Strategy\MeoconSTG.mqh>
class MeoconSTG1 : public MeoconSTG
  {
private:

public:
                     MeoconSTG1();
                    ~MeoconSTG1();
                     int Execute(Candle &candle, IndicatorRates &indicatorRats);
                     
                     bool IsUpTrend(IndicatorRates &rates);
                     bool IsDownTrend(IndicatorRates &rates);
                     bool IsCloseHigherMATrend(Candle &candle, IndicatorRates &rates);
                     bool IsCloseLowerMATrend(Candle &candle, IndicatorRates &rates);
                     bool IsRsiUp(IndicatorRates &rates);
                     bool IsRsiDown(IndicatorRates &rates);
                     bool IsCandleCrossupAllMaSignals(Candle &candle, IndicatorRates &indicatorRates);
                     bool IsCandleCrossdownAllMaSignals(Candle &candle, IndicatorRates &indicatorRates);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MeoconSTG1::MeoconSTG1()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MeoconSTG1::~MeoconSTG1()
  {
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
int MeoconSTG1::Execute(Candle &candle, IndicatorRates &indicatorRates) {
   if ((
   candle.size_type == TooShort
    ||
    candle.size_type == TooLong
   )) {
      return 0;
   }
   

   if (
      IsCandleCrossupAllMaSignals(candle, indicatorRates)
      && IsRsiUp(indicatorRates) 
      // && IsUpTrend(indicatorRates)
      &&IsCloseHigherMATrend(candle, indicatorRates)
    //  && candle.candleColor == RED
    ) {
      return 1;
   }
   
   if (
      IsCandleCrossdownAllMaSignals(candle, indicatorRates) 
      && IsRsiDown(indicatorRates) 
      &&IsCloseLowerMATrend(candle, indicatorRates)
  // && IsDownTrend(indicatorRates)
     // && candle.candleColor == BLUE
   ) {
      return -1;
   }
   return 0;
}

//+------------------------------------------------------------------+


bool MeoconSTG1::IsUpTrend(IndicatorRates &rates) {
   if (rates.ma_signal_1_val > rates.ma_trend_val) {
      return true;
   }
   return false;
}

bool MeoconSTG1::IsDownTrend(IndicatorRates &rates) {
   if (rates.ma_signal_1_val < rates.ma_trend_val) {
      return true;
   }
   return false;
}

bool MeoconSTG1::IsCloseHigherMATrend(Candle &candle, IndicatorRates &rates) {
   return 
   //true &&
   candle.close >= rates.ma_trend_val 
   //&& candle.low < rates.ma_trend_val
   ;
}

bool MeoconSTG1::IsCloseLowerMATrend(Candle &candle, IndicatorRates &rates) {

   return candle.close <= rates.ma_trend_val 
  // &&candle.high > rates.ma_trend_val
  ;
}
bool MeoconSTG1::IsRsiUp(IndicatorRates &rates) {
   if (
   MathAbs(rates.rsi_ma_1_val - rates.rsi_ma_2_val) < 5 
   && rates.rsi_ma_2_val > rsi_up_condition
   //&& rsiStat == TouchOverSold
   ) {
      if(rates.rsi_ma_1_val < rates.rsi_ma_2_val &&  MathAbs(rates.rsi_ma_1_val - rates.rsi_ma_2_val) > 1.5 ) {
        return false;
      }
      return true;
   }
   
   return false;
}

bool MeoconSTG1::IsRsiDown(IndicatorRates &rates) {
   if (
   MathAbs(rates.rsi_ma_1_val - rates.rsi_ma_2_val) < 5  
   && rates.rsi_ma_2_val < rsi_down_condition
  // && rsiStat == TouchOverBough
   ) {
      if (rates.rsi_ma_1_val > rates.rsi_ma_2_val && MathAbs(rates.rsi_ma_1_val - rates.rsi_ma_2_val) > 1.5) {
         return false;
      }
      return true;
   }
   
   return false;
}
bool MeoconSTG1::IsCandleCrossupAllMaSignals(Candle &candle, IndicatorRates &indicatorRates) {
   if (
      candle.low < indicatorRates.ma_signal_1_val
   && candle.low < indicatorRates.ma_signal_2_val
   && candle.low < indicatorRates.ma_signal_3_val
   
   && candle.close > indicatorRates.ma_signal_1_val
   && candle.close > indicatorRates.ma_signal_2_val
   && candle.close > indicatorRates.ma_signal_3_val
   ) {
      return true;
   }
   
   return false;
   
}

bool MeoconSTG1::IsCandleCrossdownAllMaSignals(Candle &candle, IndicatorRates &indicatorRates) {
   if (
      candle.high > indicatorRates.ma_signal_1_val
   && candle.high > indicatorRates.ma_signal_2_val
   && candle.high > indicatorRates.ma_signal_3_val
   
   && candle.close < indicatorRates.ma_signal_1_val
   && candle.close < indicatorRates.ma_signal_2_val
   && candle.close < indicatorRates.ma_signal_3_val
   ) {
      return true;
   }
   
   return false;
}

