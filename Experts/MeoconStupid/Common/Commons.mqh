//+------------------------------------------------------------------+
//|                                                    Constants.mqh |
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

enum Decision {
   NONE,
   BUY,
   SELL
};

struct Range {
   double min;
   double max;
};


enum CandleType {
   NONE_CANDLE,
   HAMMER,
   INVERTED_HAMMER
};

enum CandleColor {
   BLUE,
   RED
};

enum CrossType {
   CROSS_UP,
   CROSS_DOWN
};

struct CandleTypeDef {
   CandleType candle_type;
   Range shadow_top_percentage_range;
   Range body_percentage_range;
   //Range shadow_bottom_percentage_range;

};

struct CandleStruct {
   double body;
   double length;
   double shadow_top;
   double shadow_bottom;
   MqlRates rates;
   CandleColor candle_color;
};

/*
struct CandleStick {
   CandleType candle_type;
   CandleColor candle_color;
   double body;
   double length;
   double shadow_top;
   double shadow_bottom;
   MqlRates rates;
} ;
*/

struct NormalizedCandle {
   Range body_range;
   Range length_range;
   double avg_length;
   double avb_shadow_top;
   double avg_body;
   double avg_shadow_bottom;
};

struct ExecutionData {
   NormalizedCandle normalized_candle;
};

// Candle type definitions
CandleTypeDef CANDLE_HAMMER_DEF = { HAMMER, {0,5}, {5,10}};
CandleTypeDef CANDLE_INVERTED_HAMMER_DEF = { HAMMER, {90,95}, {5,10}};