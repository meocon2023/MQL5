//+---------------------------------------------------------------------+
//|                                             MeoConExpertAdvisor.mq5 |
//|                                  Copyright 2023, Meocon Stupid Ltd. |
//|                                       https://www.meoconstupid.com  |
//+---------------------------------------------------------------------+
#property description "MeoCon Stupid EA for EURUSD"

#include <Meocon\Strategy\MeoconSTG1.mqh>

#include<Trade\Trade.mqh>
#include<Trade\OrderInfo.mqh>

//+------------------------------------------------------------------+
//| Meocon Expert advisor inputs                                     |
//+------------------------------------------------------------------+ 
/*
input int   ma_trend_period            = 89; // MA trend period (21-34-89)
input int   ma_signal_1_period         = 13; // EMA short 1 signal period (13)
input int   ma_signal_2_period         = 21; // EMA short 2 signel perid (21)
input int   ma_signal_3_period         = 34; // EMA short 3 signel perid (34)


input int   rsi_period                 = 14; // RSI period
input int   rsi_ma_1_period            = 9;  // MA in RSI signal 1 period (9)
input int   rsi_ma_2_period            = 34; // MA in RSI signal 2 period (34)

input int   rsi_overbought             = 70; // RSI over bought value (90)
input int   rsi_oversold               = 30; // RSI over sold value (30)
input int   rsi_up_condition           = 40; // RSI value to buy (40)
input int   rsi_down_condition         = 60; // RSI value to sell

// Trade info
input double lot_size                  = 0.01; // Lot size
input int   maximum_pips_sl            = 15;   // Maximum Pips to SL //( 1pip : 1 lot = 10 usd, 0.01 = 0.1 usd => 15 pips vs 0.01 lot = 1.5 usd
input int   rr                         = 3;    // Risk: Reward ratio (6)

input Strategy  strategy  = S1;

*/

//+------------------------------------------------------------------+
//| Handles                                                          |
//+------------------------------------------------------------------+ 
int ma_trend_handle;
int ma_signal_1_handle;
int ma_signal_2_handle;
int ma_signal_3_handle;

int rsi_handle;
int rsi_ma_1_handle;
int rsi_ma_2_handle;

//+------------------------------------------------------------------+
//| Global variables                                                  |
//+------------------------------------------------------------------+ 
int barTotal;
RsiStat rsiStat = 0;
Position position = 0;

CandleSpecs candle_specs;

CTrade trade;
COrderInfo m_order;
MeoconSTG *meocon_stg;

const ulong MAGIC_NUM = 007;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

   trade.SetExpertMagicNumber(MAGIC_NUM);
   switch(strategy) {
      case S1:
      meocon_stg = new MeoconSTG1();
      break;
      case S2:
      break;
   }
   
   printf( "DG:%d",_Digits);

   printf("POINTTTT:%f", _Point);

   int subwindow=(int)ChartGetInteger(0,CHART_WINDOWS_TOTAL);
   rsi_handle = iRSI(_Symbol, PERIOD_CURRENT, rsi_period, PRICE_CLOSE);
   rsi_ma_1_handle = iMA(_Symbol, PERIOD_CURRENT, rsi_ma_1_period,0,MODE_EMA, rsi_handle);
   rsi_ma_2_handle = iMA(_Symbol, PERIOD_CURRENT, rsi_ma_2_period,0,MODE_EMA, rsi_handle);
   if (indicatorEnabled) {
      ChartIndicatorAdd(0, subwindow, rsi_handle);
      ChartIndicatorAdd(0, subwindow, rsi_ma_1_handle);
      ChartIndicatorAdd(0, subwindow, rsi_ma_2_handle);
   }
   
   ma_trend_handle = iMA(_Symbol, PERIOD_CURRENT, ma_trend_period, 0,MODE_SMA,PRICE_CLOSE);
   ma_signal_1_handle = iMA(_Symbol, PERIOD_CURRENT, ma_signal_1_period, 0, MODE_EMA, PRICE_CLOSE);
   ma_signal_2_handle = iMA(_Symbol, PERIOD_CURRENT, ma_signal_2_period, 0, MODE_EMA, PRICE_CLOSE);
   ma_signal_3_handle = iMA(_Symbol, PERIOD_CURRENT, ma_signal_3_period, 0, MODE_EMA, PRICE_CLOSE);

   if (indicatorEnabled) {
      ChartIndicatorAdd(0, 0, ma_trend_handle);
      ChartIndicatorAdd(0, 0, ma_signal_1_handle);
      ChartIndicatorAdd(0, 0, ma_signal_2_handle);
      ChartIndicatorAdd(0, 0, ma_signal_3_handle);
   }


   barTotal = iBars(_Symbol, PERIOD_CURRENT);

   candle_specs = BuildCandleSpecs(10000);
   printf("Candle Specs, Body:%f, High:%f, shadow:%f", candle_specs.body_standard_length, candle_specs.size_standard_length, candle_specs.shadow_stand_length);

   return(INIT_SUCCEEDED);
  }
void OnTick() {
   double buff[];
   int bars = iBars(_Symbol, PERIOD_CURRENT);
   CopyBuffer(rsi_handle,0,0,1, buff);
  
   double rsi_val = buff[0];
   
   if (rsi_val < rsi_oversold) {
      rsiStat =  TouchOverSold;
    } else if (rsi_val > rsi_overbought) {
      rsiStat = TouchOverBough;
    }
   


   if (bars > barTotal) {
      barTotal = bars;
      DeleteAfterNBars(cancel_order_after_num_candles);
      MqlRates rates[];
      CopyRates(_Symbol,PERIOD_CURRENT,1,1, rates);
      printf("Process new bar of symbol:%s, time:%s, ", _Symbol, string(rates[0].time));
      bool hasPositionOpened = HasPosition(_Symbol);
      
      
      switch(Decide()) {
         case 0:
         break;
         case 1:
            DrawArrowUp(rates[0]);
            if (!hasPositionOpened) {
               Buy(rates[0]);  
               candle_specs = BuildCandleSpecs(10000);
            }
                      
         break;
         case -1:
            DrawArrowDown(rates[0]);
            if (!hasPositionOpened) {
               Sell(rates[0]);
               candle_specs = BuildCandleSpecs(10000);
            }    
         break;
      }

   }
}

int Decide() {
   
   IndicatorRates indicatorRates = ToIndicatorRates(1);
   MqlRates rates[];
   CopyRates(_Symbol,PERIOD_CURRENT,1,1, rates);
   Candle candle = BuildCandle( candle_specs,rates[0]);
   //MarkCandle(candle);
   
   MqlRates prevRates[];
   CopyRates(_Symbol,PERIOD_CURRENT,2,1, prevRates);
     
   if (rates[0].tick_volume * 5 < prevRates[0].tick_volume) {
     return 0;
   }
   return meocon_stg.Execute(candle, indicatorRates);
   
}


void OnDeinit(const int reason) {
   if (indicatorEnabled) {
         DeleteIndicators();
   }

   IndicatorRelease(ma_trend_handle);
   IndicatorRelease(ma_signal_1_handle);
   IndicatorRelease(ma_signal_2_handle);
   IndicatorRelease(ma_signal_3_handle);
   IndicatorRelease(rsi_ma_1_handle);
   IndicatorRelease(rsi_ma_2_handle);
   IndicatorRelease(rsi_handle);

   
}

bool HasPosition(string checkedSymbol) {
   int cnt = 0;
   /*
   for(int i = 0; i < PositionsTotal(); i++) {
      string symbol = PositionGetSymbol(i);
      //PositionSe
      if (StringCompare(checkedSymbol, symbol, false) == 0) {
         cnt++;
      }
   }
   */
   for(int v = PositionsTotal() - 1; v >= 0; v--)
     {
       ulong positionticket = PositionGetTicket(v);
       ulong  magic=PositionGetInteger(POSITION_MAGIC);
      
      if(PositionSelectByTicket(positionticket))
        {
         if(magic ==MAGIC_NUM )
           {
            
            cnt ++ ;
           }
        }
     }   

   int ordersCnt = 0;
   for(int i=OrdersTotal()-1; i>=0; i--) // returns the number of current orders
   {
         if(m_order.SelectByIndex(i))     // selects the pending order by index for further access to its properties
         {
            if(m_order.Symbol()==_Symbol && m_order.Magic()==MAGIC_NUM) 
            
            {
               ordersCnt++;
            }
         
         }
   }

   printf("Symbol:%s, Magic Number: %s, Positions:%d, Pending Orders:%d", _Symbol, string(MAGIC_NUM), cnt, ordersCnt);
   

   return cnt > 0;

}

//+------------------------------------------------------------------+
//| Delete After N Bars                                              |
//+------------------------------------------------------------------+
void DeleteAfterNBars(const int bars)
  {
   if(bars<1)
      return;
   MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int start_pos=0,count=bars+1;
   if(CopyRates(_Symbol, PERIOD_CURRENT,start_pos,count,rates)!=count)
      return;
//---
   for(int i=OrdersTotal()-1; i>=0; i--) // returns the number of current orders
      if(m_order.SelectByIndex(i))     // selects the pending order by index for further access to its properties
         if(m_order.Symbol()==_Symbol/* && m_order.Magic()==InpMagic*/)
            if(m_order.TimeSetup()<=rates[count-1].time)
               if(!trade.OrderDelete(m_order.Ticket()))
                     Print(__FILE__," ",__FUNCTION__,", ERROR: ","CTrade.OrderDelete ",m_order.Ticket());
  }

void Buy(MqlRates &rate) {
   //trade.Buy(lot_size, _Symbol, rate.close, rate.close - 0.0001 * maximum_pips_sl, rate.close + 0.0001 * maximum_pips_sl * rr, "EA BUY");
   double avg = MathAbs(rate.close - rate.open) / 4;
   for (int i = 2; i <= rr; i+=2) {
     // trade.BuyLimit(lot_size,rate.close - avg, _Symbol,rate.close - 0.0001 * maximum_pips_sl, rate.close + 0.0001 * maximum_pips_sl * i,ORDER_TIME_DAY);
   }
   trade.BuyLimit(lot_size,rate.close - avg , _Symbol,rate.close - _Point * 10 * maximum_pips_sl, rate.close + _Point * 10 * maximum_pips_sl * rr,ORDER_TIME_DAY);


}

void Sell(MqlRates &rate) {
   //trade.Sell(lot_size,_Symbol, rate.close, rate.close + 0.0001 * maximum_pips_sl, rate.close - 0.0001 * maximum_pips_sl * rr, "EA SELL");
   double avg = MathAbs(rate.close - rate.open) / 4;
   for (int i = 3; i <= rr; i+=2) {
     // trade.SellLimit(lot_size,rate.close + avg, _Symbol,rate.close  + 0.0001 * maximum_pips_sl, rate.close - 0.0001 * maximum_pips_sl * i,ORDER_TIME_DAY);
   }
   trade.SellLimit(lot_size,rate.close + avg , _Symbol,rate.close  + _Point * 10 * maximum_pips_sl, rate.close - _Point * 10 * maximum_pips_sl * rr,ORDER_TIME_DAY);


}

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
void TraillingSL(MqlRates &rate) {

   // MODIFY SL AND TP OF BUY POSITIONS :
   for (int i=PositionsTotal()-1; i>=0; --i) {
      ulong ticket=PositionGetTicket(i);
		if (PositionGetSymbol(i)==Symbol() && PositionGetInteger(POSITION_TYPE)==0) {
		   double tp =PositionGetDouble(POSITION_TP);
		   double sl =PositionGetDouble(POSITION_SL);
		   double profit = rate.close - sl;
		   if (profit > maximum_pips_sl * 0.0001 * 2) {
            sl += maximum_pips_sl * 0.0001;
		      trade.PositionModify(ticket,sl,tp);
		   }

			
		}
	}

   // MODIFY SL AND TP OF SELL POSITIONS :
   for (int i=PositionsTotal()-1; i>=0; --i) {
      ulong ticket=PositionGetTicket(i);
		if (PositionGetSymbol(i)==Symbol() && PositionGetInteger(POSITION_TYPE)==1) {
		   double tp =PositionGetDouble(POSITION_TP);
		   double sl =PositionGetDouble(POSITION_SL);
		   double profit = sl - rate.close;
		   if (profit > maximum_pips_sl * 0.0001 * 2) {
		    //  printf("SELL MOVE SL, current:%f, new:%f", sl, newSL);
		      sl -= maximum_pips_sl * 0.0001 ;
		      trade.PositionModify(ticket,sl,tp);
		   }
			
		}
   }
}

void MarkCandle(Candle &c) {
   
   double price=iHigh(_Symbol,PERIOD_CURRENT,1);
   string id = "object_" + string(c.time);
   if (c.size_type == TooShort || c.size_type == TooLong || true) {
      ObjectCreate(0,id,OBJ_TEXT,0,c.time,c.close);
      ObjectSetString(0,id,OBJPROP_TEXT,string(c.size_type));   
   }

}

void DeleteIndicators() {
   // delete indicator using the indicator handle
      int subwindows=ChartGetInteger(0,CHART_WINDOWS_TOTAL);

      for(int i=subwindows;i>=0;i--)
        {
         int indicators=ChartIndicatorsTotal(0,i);

         for(int j=indicators-1; j>=0; j--)
           {
            ChartIndicatorDelete(0,i,ChartIndicatorName(0,i,j));
           }
        }
}


IndicatorRates ToIndicatorRates(int shift) {
   double  ma_trend_buff[], ma_signal_1_buff[], ma_signal_2_buff[], ma_signal_3_buff[];
   double rsi_buff[], rsi_ma_1_buff[], rsi_ma_2_buff[];
   

   CopyBuffer(ma_trend_handle       ,0, shift,1,ma_trend_buff);
   CopyBuffer(ma_signal_1_handle    ,0,shift,1,ma_signal_1_buff);
   CopyBuffer(ma_signal_2_handle    ,0,shift,1,ma_signal_2_buff);
   CopyBuffer(ma_signal_3_handle    ,0,shift,1,ma_signal_3_buff);
   
   CopyBuffer(rsi_handle            ,0,shift,1, rsi_buff);
   CopyBuffer(rsi_ma_1_handle       ,0,shift,1, rsi_ma_1_buff);
   CopyBuffer(rsi_ma_2_handle       ,0,shift,1, rsi_ma_2_buff);
   
   IndicatorRates rates;
   rates.ma_trend_val = ma_trend_buff[0];
   rates.ma_signal_1_val = ma_signal_1_buff[0];
   rates.ma_signal_2_val = ma_signal_2_buff[0];
   rates.ma_signal_3_val = ma_signal_3_buff[0];
   
   rates.rsi_val = rsi_buff[0];
   rates.rsi_ma_1_val = rsi_ma_1_buff[0];
   rates.rsi_ma_2_val = rsi_ma_2_buff[0];
   
   return rates;
}


  
  
  


