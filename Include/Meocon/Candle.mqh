//+------------------------------------------------------------------+
//|                                                       Candle.mqh |
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

//+------------------------------------------------------------------+
//|   ENUM TYPE CANDLESTICK                                          |
//+------------------------------------------------------------------+
enum CandleType
{
   CAND_NONE,           //Unknown
   CAND_MARIBOZU,       //Maribozu
   CAND_MARIBOZU_LONG,  //Maribozu long
   CAND_DOJI,           //Doji
   CAND_SPIN_TOP,       //Spins
   CAND_HAMMER,         //Hammer
   CAND_INVERT_HAMMER,  //Inverted Hammer
   CAND_LONG,           //Long
   CAND_SHORT,          //Short
   CAND_STAR            //Star
};

enum CandleColor {
   NOCOLOR,
   RED,
   BLUE
};

enum CandleSizeType {
   None,
   TooShort,
   Standard,
   TooLong
};

struct CandleSpecs
{
   // Generic candle specification
   double body_standard_length, body_delta;
   double size_standard_length, size_delta;
   double shadow_stand_length, shadow_delta;
   
   // Long Candle


   CandleSpecs() {
      body_delta = 0;
      body_standard_length = 0;
      size_standard_length = 0;
      size_delta = 0;
      shadow_delta = 0;
      shadow_stand_length = 0;
   }

};


struct Candle 
{
   double open, close, high, low, body, size;
   CandleColor candleColor;
   long volume;
   datetime time;
   CandleSizeType size_type;
   CandleType candle_type;
   Candle() {
      open = 0;close = 0; high = 0; low = 0; body = 0; size = 0; volume = 0; time = 0;
      size_type = None;
      candle_type = CAND_NONE;
   }
};


CandleSpecs BuildCandleSpecs(int total) {
   int max = iBars(_Symbol, PERIOD_CURRENT);
   if (total > max) {
      total = max;
   }
   
   MqlRates rates[];
   CopyRates(_Symbol,PERIOD_CURRENT,0, total, rates);
   CandleSpecs specs;

   for (int i = 0; i < total; i++) {
      MqlRates rate = rates[i];
      double body = MathAbs(rate.close - rate.open);
      double size = MathAbs(rate.high - rate.low);
      specs.body_standard_length += body;
      specs.size_standard_length += size;
      specs.shadow_stand_length  += (size - body)/2;
   }
   specs.body_standard_length = specs.body_standard_length/total;
   specs.size_standard_length = specs.size_standard_length/total;
   specs.shadow_stand_length = specs.shadow_stand_length/total;
   
   return specs;
}



Candle  BuildCandle(CandleSpecs &specs, MqlRates &rates) {
   Candle c;
   c.close = rates.close;
   c.open = rates.open;
   c.high = rates.high;
   c.low = rates.low;
   c.volume = rates.tick_volume;
   c.time = rates.time;
   c.body = MathAbs(c.close - c.open);
   c.size = MathAbs(c.high - c.low);
   if (c.close > c.open) {
      c.candleColor = BLUE;
   } else {
      c.candleColor = RED;
   }

   if (c.body < specs.body_standard_length / 3 && c.size < specs.size_standard_length / 4) {
      c.size_type = TooShort;
   } else if(
      (c.body > specs.body_standard_length  && c.body < specs.body_standard_length * 2 )
      && ( c.size < specs.size_standard_length * 2)
   ) {
         double xx = specs.body_standard_length * (2/3) ;
      c.size_type = Standard;
   } else if(
      c.body > specs.body_standard_length * 2
      || c.size > specs.size_standard_length * 2
   ){
      c.size_type = TooLong;
   }
   return c;
}
