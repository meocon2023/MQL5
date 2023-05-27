//+------------------------------------------------------------------+
//|                                      MeoconStupidLongTimeFrameStrategy.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "..\Core\BaseStrategy.mqh"
#include "..\Core\Conditions\ConditionsImpl.mqh"
#include "..\Core\Conditions\CandleConditionsImpl.mqh"

class MeoconStupidLongTimeFrameStrategy : public BaseStrategy
  {
   private:
                     int m_ma_signal_handle;
                     int m_ma_trend_handle;

                     ENUM_TIMEFRAMES m_time_frame;
      
   protected:
                     void BuildOrderConditions();

                     void BuildMAConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions);
      

   public:

                     MeoconStupidLongTimeFrameStrategy(int ma_signal_handle, int ma_trend_handle, ENUM_TIMEFRAMES time_frame);
                    ~MeoconStupidLongTimeFrameStrategy();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

  
  MeoconStupidLongTimeFrameStrategy::MeoconStupidLongTimeFrameStrategy(int ma_signal_handle, int ma_trend_handle, ENUM_TIMEFRAMES time_frame)
  {
      m_ma_signal_handle = ma_signal_handle;
      m_ma_trend_handle = ma_trend_handle;
      m_time_frame = time_frame;      

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MeoconStupidLongTimeFrameStrategy::~MeoconStupidLongTimeFrameStrategy()
  {
  }
//+------------------------------------------------------------------+

void MeoconStupidLongTimeFrameStrategy::BuildOrderConditions() {
      CArrayObj *buy_conditions = new CArrayObj;
      
      CArrayObj *sell_conditions = new CArrayObj;

      BuildMAConditions(buy_conditions, sell_conditions);
      

      // SETUP MA CONDITIONS
      
   

      

      //+------------------------------------------------------------------+

      
      m_buy_condition = new AndCondition(buy_conditions);
      m_sell_condition = new AndCondition(sell_conditions);
}




void MeoconStupidLongTimeFrameStrategy::BuildMAConditions(CArrayObj &buy_conditions, CArrayObj &sell_conditions) {
      //+------------------------------------------------------------------+
      //| Setup MAs                                                        |
      //+------------------------------------------------------------------+
      Range ma_range = {0, 10000};
      buy_conditions.Add(new IndicatorsComparator(m_ma_signal_handle, m_ma_trend_handle, 0, ma_range));

      
      sell_conditions.Add(new IndicatorsComparator(m_ma_trend_handle, m_ma_signal_handle, 0, ma_range));


}



