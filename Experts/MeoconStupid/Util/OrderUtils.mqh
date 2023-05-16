//+------------------------------------------------------------------+
//|                                                   OrderUtils.mqh |
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
#include<Trade\Trade.mqh>

CTrade trade;
void MakeBuyLimit(MqlRates &rate,double lot, int pips_sl, double rr) {
   double ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double desired_buy_price = NormalizeDouble(rate.close - MathAbs(rate.high - rate.low) / 4, _Digits);

   if (desired_buy_price >= bid) {
      desired_buy_price = bid - 10 * _Point;
   }
   

   desired_buy_price = NormalizeDouble(desired_buy_price, _Digits);
   double sl_price = NormalizeDouble(rate.close - pips_sl * 10 * _Point, _Digits);
   double tp_price = NormalizeDouble(rate.close + rr * pips_sl * 10 * _Point, _Digits);
   
   if (sl_price >= desired_buy_price) {
      sl_price -= pips_sl * 10 * _Point;   
   }
   
   bool success = trade.BuyLimit(lot,desired_buy_price, _Symbol,sl_price, tp_price,ORDER_TIME_DAY);
   if (!success) {
      printf("[ERROR][BUY] symbol:%s, at price: %s, ask: %s, bid: %s", _Symbol, string(desired_buy_price), string(ask), string(bid));
   } else {
      printf("[SUCCESS][BUY] symbol:%s, at price: %s, ask: %s, bid: %s", _Symbol, string(desired_buy_price), string(ask), string(bid));
   }
}


void MakeSellLimit(MqlRates &rate,double lot, int pips_sl, double rr) {
   double ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double desired_buy_price = NormalizeDouble(rate.close + MathAbs(rate.high - rate.low) / 4, _Digits);

   if (desired_buy_price <= ask) {
      desired_buy_price = ask + 10 * _Point;
   }
   

   desired_buy_price = NormalizeDouble(desired_buy_price, _Digits);
   double sl_price = NormalizeDouble(rate.close + pips_sl * 10 * _Point, _Digits);
   double tp_price = NormalizeDouble(rate.close - rr * pips_sl * 10 * _Point, _Digits);
   if (sl_price <= desired_buy_price) {
      sl_price +=  pips_sl * 10 * _Point;
   }
   
   bool success = trade.SellLimit(lot,desired_buy_price, _Symbol,sl_price, tp_price,ORDER_TIME_DAY);
   if (!success) {
      printf("[ERROR][SELL] symbol:%s, at price: %s, ask: %s, bid: %s", _Symbol, string(desired_buy_price), string(ask), string(bid));
   } else {
      printf("[SUCCESS][SELL] symbol:%s, at price: %s, ask: %s, bid: %s", _Symbol, string(desired_buy_price), string(ask), string(bid));
   }
}

