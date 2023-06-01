//+------------------------------------------------------------------+
//|                                                    DrawUtils.mqh |
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

void DrawArrowDown(MqlRates &rate) {
      double h = rate.high;
      h += h/2000;
      ObjectCreate(0,"obj_arrow_down" + string(rate.time),OBJ_ARROW_DOWN,0,rate.time, h);
}

void DrawArrowUp(MqlRates &rate) {
      double l = rate.low;
      l -= l/2000;
      ObjectCreate(0,"obj_arrow_up" + string(rate.time),OBJ_ARROW_UP,0,rate.time, l);
}
