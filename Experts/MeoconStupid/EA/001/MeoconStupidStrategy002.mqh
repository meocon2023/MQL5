//+------------------------------------------------------------------+
//|                                      MeoconStupidStrategy002.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "..\Core\BaseStrategy.mqh"
#include "..\Core\Conditions\ConditionsImpl.mqh"
#include "..\Core\Conditions\CandleConditionsImpl.mqh"

class MeoconStupidStrategy002 : public BaseStrategy
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
                     MeoconStupidStrategy002(int ma_signal_trend_handle, int ma_signal_1_handle, int ma_signal_2_handle, int ma_signal_3_handle, int ma_trend_handle, int rsi_handle, int ma_rsi_signal_1_handle, int ma_rsi_signal_2_handle, int ma_rsi_signal_3_handle, int rsi_h1_handle, int ma_rsi_signal_1_h1_handle, ENUM_TIMEFRAMES time_frame);
                    ~MeoconStupidStrategy002();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*MeoconStupidStrategy002::MeoconStupidStrategy002(BaseCondition &buy_condition, BaseCondition &sell_condition) : BaseStrategy(buy_condition, sell_condition)
  {
  }
  */
  
  MeoconStupidStrategy002::MeoconStupidStrategy002(int ma_signal_trend_handle, int ma_signal_1_handle, int ma_signal_2_handle, int ma_signal_3_handle, int ma_trend_handle, int rsi_handle, int ma_rsi_signal_1_handle, int ma_rsi_signal_2_handle, int ma_rsi_signal_3_handle, int rsi_h1_handle, int ma_rsi_signal_1_h1_handle, ENUM_TIMEFRAMES time_frame) 
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
MeoconStupidStrategy002::~MeoconStupidStrategy002()
  {
  }
//+------------------------------------------------------------------+

void MeoconStupidStrategy002::BuildOrderConditions() {
      CArrayObj *buy_conditions = new CArrayObj;
      
      CArrayObj *sell_conditions = new CArrayObj;
      
      BuildRSIConditions(buy_conditions, sell_conditions);
      BuildH1RSIConditions(buy_conditions, sell_conditions);
      BuildCandleConditions(buy_conditions, sell_conditions);
      BuildMAConditions(buy_conditions, sell_conditions);
      
      m_buy_condition = new AndCondition(buy_conditions);
      m_sell_condition = new AndCondition(sell_conditions);
}

void MeoconStupidStrategy002::BuildRSIConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions) {

      Range ma_rsi_34_buy_range = {35, 100};
      
      buy_conditions.Add(new IndicatorRangeValueComparator(m_ma_rsi_signal_3_handle, 1, ma_rsi_34_buy_range));
      Range ma_rsi_34_sell_range = {0, 65};
      sell_conditions.Add(new IndicatorRangeValueComparator(m_ma_rsi_signal_3_handle, 1, ma_rsi_34_sell_range));
   
      //
      
      Range ma_rsi_signal_1_vs_3_range = {-5, 5};
      buy_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_1_handle, m_ma_rsi_signal_3_handle,1, ma_rsi_signal_1_vs_3_range));
      sell_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_3_handle, m_ma_rsi_signal_1_handle,1, ma_rsi_signal_1_vs_3_range));
      
      
      
      CArrayObj *buy_or_conditions = new CArrayObj;
      Range range1 = {0, 5};
      buy_or_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_1_handle, m_ma_rsi_signal_3_handle,1, range1));
      Range range2 = {-1.5, 1.5};
      buy_or_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_1_handle, m_ma_rsi_signal_3_handle,1, range2));
      
      OrCondition *or_buys = new OrCondition(buy_or_conditions);
      buy_conditions.Add(or_buys);
      
      
          CArrayObj *sell_or_conditions = new CArrayObj;
      Range range11 = {-5, 0};
      sell_or_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_1_handle, m_ma_rsi_signal_3_handle,1, range11));
      Range range22 = {1.5, -1.5};
      sell_or_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_1_handle, m_ma_rsi_signal_3_handle,1, range22));
      
      OrCondition *or_sells = new OrCondition(sell_or_conditions);
      sell_conditions.Add(or_sells);
      

      

}

void MeoconStupidStrategy002::BuildH1RSIConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions) {

/*
      Range h1_rsi_range = {-5, 10};
      buy_conditions.Add(new IndicatorsComparator(m_rsi_h1_handle, m_ma_rsi_signal_1_h1_handle,1, h1_rsi_range));
      sell_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_1_h1_handle , m_rsi_h1_handle,1, h1_rsi_range));
      */
      
      

}

void MeoconStupidStrategy002::BuildMAConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions) {
      //+------------------------------------------------------------------+
      //| Setup MAs                                                        |
      //+------------------------------------------------------------------+
      
      
      buy_conditions.Add(new PriceCrossMAChecker(m_ma_signal_1_handle, m_time_frame,1, CROSS_UP));
      buy_conditions.Add(new PriceCrossMAChecker(m_ma_signal_2_handle, m_time_frame,1, CROSS_UP));
      buy_conditions.Add(new PriceCrossMAChecker(m_ma_signal_3_handle, m_time_frame,1, CROSS_UP));
      
      sell_conditions.Add(new PriceCrossMAChecker(m_ma_signal_1_handle, m_time_frame,1, CROSS_DOWN));
      sell_conditions.Add(new PriceCrossMAChecker(m_ma_signal_2_handle, m_time_frame,1, CROSS_DOWN));
      sell_conditions.Add(new PriceCrossMAChecker(m_ma_signal_3_handle, m_time_frame,1, CROSS_DOWN));
      
      Range ma_21_vs_close_price_buy = {-100000, 0};
      buy_conditions.Add(new MAClosePriceComparator(m_ma_signal_trend_handle, m_time_frame, 1, ma_21_vs_close_price_buy));
      Range ma_21_vs_close_price_sell = {0, 100000};
      sell_conditions.Add(new MAClosePriceComparator(m_ma_signal_trend_handle, m_time_frame, 1, ma_21_vs_close_price_sell));      

}
void MeoconStupidStrategy002::BuildCandleConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions) {
      //+------------------------------------------------------------------+
      //| Setup Candle patterns conditions                                 |
      //+------------------------------------------------------------------+
      //candle length
      Range candle_length_percentage_range = {50, 200};
      //buy_conditions.Add(new CandleLengthChecker(m_time_frame, 1, candle_length_percentage_range));
     // sell_conditions.Add(new CandleLengthChecker(m_time_frame, 1, candle_length_percentage_range));
      
      
      
      /*
      
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
      */
}
