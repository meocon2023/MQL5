//+------------------------------------------------------------------+
//|                                      MeoconStupidStrategy001.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "..\Core\BaseStrategy.mqh"
#include "..\Core\Conditions\ConditionsImpl.mqh"
#include "..\Core\Conditions\CandleConditionsImpl.mqh"

class MeoconStupidStrategy001 : public BaseStrategy
  {
   private:
                     int m_ma_signal_trend_handle;
                     int m_ma_signal_1_handle;
                     int m_ma_signal_2_handle;
                     int m_ma_signal_3_handle;
                     int m_ma_trend_handle;
                     
                     int m_rsi_handle;
                     int m_ma_rsi_signal_1_handle;
                     int m_ma_rsi_signal_2_handle;
                     int m_ma_rsi_signal_3_handle;
                     int m_ma_rsi_trend_handle;
                     
                     // H1 handle
                     int m_rsi_h1_handle;
                     int m_ma_rsi_signal_1_h1_handle;
                     ENUM_TIMEFRAMES m_time_frame;
      
   protected:
                     void BuildOrderConditions();
                     void BuildRSIConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions);
                     void BuildH1RSIConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions);
                     void BuildMAConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions);
                     void BuildCandleConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions);
      

   public:
                     //MeoconStupidStrategy001(BaseCondition &buy_condition, BaseCondition &sell_condition);
                     MeoconStupidStrategy001(int ma_signal_trend_handle, int ma_signal_1_handle, int ma_signal_2_handle, int ma_signal_3_handle, int ma_trend_handle, int rsi_handle, int ma_rsi_signal_1_handle, int ma_rsi_signal_2_handle, int ma_rsi_signal_3_handle, int rsi_h1_handle, int ma_rsi_signal_1_h1_handle, ENUM_TIMEFRAMES time_frame);
                    ~MeoconStupidStrategy001();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*MeoconStupidStrategy001::MeoconStupidStrategy001(BaseCondition &buy_condition, BaseCondition &sell_condition) : BaseStrategy(buy_condition, sell_condition)
  {
  }
  */
  
  MeoconStupidStrategy001::MeoconStupidStrategy001(int ma_signal_trend_handle, int ma_signal_1_handle, int ma_signal_2_handle, int ma_signal_3_handle, int ma_trend_handle, int rsi_handle, int ma_rsi_signal_1_handle, int ma_rsi_signal_2_handle, int ma_rsi_signal_3_handle, int rsi_h1_handle, int ma_rsi_signal_1_h1_handle, ENUM_TIMEFRAMES time_frame) 
  {
      m_ma_signal_trend_handle = ma_signal_trend_handle;
      m_ma_signal_1_handle = ma_signal_1_handle;
      m_ma_signal_2_handle = ma_signal_2_handle;
      m_ma_signal_3_handle = ma_signal_3_handle;
      m_ma_trend_handle = ma_trend_handle;
      
      m_rsi_handle = rsi_handle;
      m_ma_rsi_signal_1_handle = ma_rsi_signal_1_handle;
      m_ma_rsi_signal_2_handle = ma_rsi_signal_2_handle;
      m_ma_rsi_signal_3_handle = ma_rsi_signal_3_handle;
      //m_ma_rsi_trend_handle = ma_rsi_trend_handle;
      
      // H1
      m_rsi_h1_handle = rsi_h1_handle;
      m_ma_rsi_signal_1_h1_handle = ma_rsi_signal_1_h1_handle;
      
      m_time_frame = time_frame;      

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MeoconStupidStrategy001::~MeoconStupidStrategy001()
  {
  }
//+------------------------------------------------------------------+

void MeoconStupidStrategy001::BuildOrderConditions() {
      CArrayObj *buy_conditions = new CArrayObj;
      
      CArrayObj *sell_conditions = new CArrayObj;
      
      BuildRSIConditions(buy_conditions, sell_conditions);
      BuildH1RSIConditions(buy_conditions, sell_conditions);
      BuildCandleConditions(buy_conditions, sell_conditions);
      BuildMAConditions(buy_conditions, sell_conditions);
      

      // SETUP MA CONDITIONS
      
   

      

      //+------------------------------------------------------------------+

      
      m_buy_condition = new AndCondition(buy_conditions);
      m_sell_condition = new AndCondition(sell_conditions);
}

void MeoconStupidStrategy001::BuildRSIConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions) {

      Range ma_rsi_signal_1_vs_ma_rsi_signal_3_range = {0.5, 10};
      buy_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_1_handle, m_ma_rsi_signal_3_handle,1, ma_rsi_signal_1_vs_ma_rsi_signal_3_range));
      sell_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_3_handle, m_ma_rsi_signal_1_handle,1, ma_rsi_signal_1_vs_ma_rsi_signal_3_range));

      Range ma_rsi_signal_2_vs_ma_rsi_signal_3_range = {0.5, 10};
      buy_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_2_handle, m_ma_rsi_signal_3_handle,1, ma_rsi_signal_2_vs_ma_rsi_signal_3_range));
      sell_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_3_handle, m_ma_rsi_signal_2_handle,1, ma_rsi_signal_2_vs_ma_rsi_signal_3_range));
}

void MeoconStupidStrategy001::BuildH1RSIConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions) {

      Range h1_rsi_range = {0.1, 10};
      buy_conditions.Add(new IndicatorsComparator(m_rsi_h1_handle, m_ma_rsi_signal_1_h1_handle,1, h1_rsi_range));
      sell_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_1_h1_handle , m_rsi_h1_handle,1, h1_rsi_range));

}

void MeoconStupidStrategy001::BuildMAConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions) {
      //+------------------------------------------------------------------+
      //| Setup MAs                                                        |
      //+------------------------------------------------------------------+
      buy_conditions.Add(new PriceCrossMAChecker(m_ma_signal_1_handle, m_time_frame,1, CROSS_UP));
      buy_conditions.Add(new PriceCrossMAChecker(m_ma_signal_2_handle, m_time_frame,1, CROSS_UP));
      buy_conditions.Add(new PriceCrossMAChecker(m_ma_signal_trend_handle, m_time_frame,1, CROSS_UP));
      
      sell_conditions.Add(new PriceCrossMAChecker(m_ma_signal_1_handle, m_time_frame,1, CROSS_DOWN));
      sell_conditions.Add(new PriceCrossMAChecker(m_ma_signal_2_handle, m_time_frame,1, CROSS_DOWN));
      sell_conditions.Add(new PriceCrossMAChecker(m_ma_signal_trend_handle, m_time_frame,1, CROSS_DOWN));

}
void MeoconStupidStrategy001::BuildCandleConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions) {
      //+------------------------------------------------------------------+
      //| Setup Candle patterns conditions                                 |
      //+------------------------------------------------------------------+
      // Blue candle
      Range candle_length_percentage_range = {50, 200};
      buy_conditions.Add(new CandleLengthChecker(m_time_frame, 1, candle_length_percentage_range, BLUE));
      
      // Candle Types
      CArrayObj *candle_types_or_conditions = new CArrayObj;
      candle_types_or_conditions.Add(new CandleTypeChecker(m_time_frame, 1, CANDLE_STRONG_DEF));
      candle_types_or_conditions.Add(new CandleTypeChecker(m_time_frame, 1, CANDLE_HAMMER_DEF));
      candle_types_or_conditions.Add(new CandleTypeChecker(m_time_frame, 1, CANDLE_INVERTED_HAMMER_DEF));
      OrCondition *rsiOrConditions = new OrCondition(candle_types_or_conditions);
      buy_conditions.Add(rsiOrConditions);
      
      
      sell_conditions.Add(new CandleLengthChecker(m_time_frame, 1, candle_length_percentage_range, RED));
      
      // Candle Types
      CArrayObj *candle_types_or_sell_conditions = new CArrayObj;
      candle_types_or_sell_conditions.Add(new CandleTypeChecker(m_time_frame, 1, CANDLE_STRONG_DEF));
      candle_types_or_sell_conditions.Add(new CandleTypeChecker(m_time_frame, 1, CANDLE_HAMMER_DEF));
      candle_types_or_sell_conditions.Add(new CandleTypeChecker(m_time_frame, 1, CANDLE_INVERTED_HAMMER_DEF));
      OrCondition *rsiOrSellConditions = new OrCondition(candle_types_or_sell_conditions);
      sell_conditions.Add(rsiOrSellConditions);
}




/*
void MeoconStupidStrategy001::BuildSellCondition() {
      CArrayObj *sell_conditions = new CArrayObj;

      //Range range={-1,1};
      //buy_conditions.Add(new IndicatorsComparator(m_ma_signal_2_handle, m_ma_signal_3_handle,1, range ));
      
      // Setup RSI buy conditions
      
      // ma_rsi_signal 2
      Range ma_rsi_signal_2_vs_rsi_trend_range = {-5, -0.1};
      sell_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_2_handle, m_ma_rsi_trend_handle,1, ma_rsi_signal_2_vs_rsi_trend_range));
      
      // ma_rsi_signal 3
      Range ma_rsi_signal_3_vs_rsi_trend_range = {-3, -0.1};
      sell_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_3_handle, m_ma_rsi_trend_handle,1, ma_rsi_signal_3_vs_rsi_trend_range));
      
      //ma_rsi_signal 1 vs ma_rsi_signal 2/3
       Range ma_rsi_signal_1_vs_ma_rsi_signal_2_3_range = {-100, -0.1};
      sell_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_1_handle, m_ma_rsi_signal_2_handle,1, ma_rsi_signal_1_vs_ma_rsi_signal_2_3_range));
      sell_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_1_handle, m_ma_rsi_signal_3_handle,1, ma_rsi_signal_1_vs_ma_rsi_signal_2_3_range));
      
      m_sell_condition = new AndCondition(sell_conditions);
}
*/