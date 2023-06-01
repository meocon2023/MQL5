//+------------------------------------------------------------------+
//|                                                  CandleUtils.mqh |
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

#include "..\Common\Commons.mqh"

/*
CandleStick RecognizeCandleStick(ENUM_TIMEFRAMES time_frame, int shift) {

   NormalizedCandle normalized_candle = BuildNormalizedCandle(time_frame, shift, 1000);
   CandleStick candle;
   
   MqlRates rates[];
   CopyRates(_Symbol, time_frame, shift, 1, rates);
   candle.rates = rates[0];
   return candle;

}
*/

NormalizedCandle BuildNormalizedCandle(ENUM_TIMEFRAMES time_frame, int shift, int num) {

   MqlRates rates[];
   int count = CopyRates(_Symbol, time_frame, shift, num, rates);
   double avg_body = 0, avg_length = 0, avg_shadow_top = 0, avg_shadow_bottom = 0;
   for (int i = 0; i < count; i++) {
      avg_body += MathAbs(rates[i].close - rates[i].open);
      avg_length += MathAbs(rates[i].high - rates[i].low);
      if (rates[i].close > rates[i].open) {
         avg_shadow_top += MathAbs(rates[i].high - rates[i].close);
         avg_shadow_bottom += MathAbs(rates[i].low - rates[i].open);
      } else {
         avg_shadow_top += MathAbs(rates[i].high - rates[i].open);
         avg_shadow_bottom += MathAbs(rates[i].low - rates[i].close);      
      }
      
   }
   avg_body = avg_body / count;
   avg_length = avg_length / count;
   avg_shadow_top = avg_shadow_top / count;
   avg_shadow_bottom = avg_shadow_bottom / count;
   
   NormalizedCandle normalized_candle = {{avg_body,avg_length}, {avg_length,avg_length + avg_body}, avg_length, avg_shadow_top, avg_body, avg_shadow_bottom};
   
   return normalized_candle;
}


CandleStruct GetCandleStruct(ENUM_TIMEFRAMES time_frame, int shift) {
   MqlRates rates[];
   CopyRates(_Symbol, time_frame,shift,1, rates);
   
   
   CandleStruct c;
   c.rates = rates[0];
   c.body = MathAbs(c.rates.close - c.rates.open);
   c.length  = MathAbs(c.rates.high - c.rates.low);
   c.candle_color = c.rates.close > c.rates.open ? BLUE: RED;
   if (c.candle_color == BLUE) {
        c.shadow_top = MathAbs(c.rates.high - c.rates.close);
        c.shadow_bottom = MathAbs(c.rates.low - c.rates.open);
   } else {
        c.shadow_top = MathAbs(c.rates.high - c.rates.open);
        c.shadow_bottom = MathAbs(c.rates.low - c.rates.close);
   }
   
   return c;
   
}