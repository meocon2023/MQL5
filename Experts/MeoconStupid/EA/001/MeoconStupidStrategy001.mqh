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
      
   protected:
                     void BuildBuyConditions();
                     void BuildSellCondition();
      

   public:
                     //MeoconStupidStrategy001(BaseCondition &buy_condition, BaseCondition &sell_condition);
                     MeoconStupidStrategy001(int ma_signal_trend_handle, int ma_signal_1_handle, int ma_signal_2_handle, int ma_signal_3_handle, int ma_trend_handle,       int rsi_handle, int ma_rsi_signal_1_handle, int ma_rsi_signal_2_handle, int ma_rsi_signal_3_handle, int ma_rsi_trend_handle);
                    ~MeoconStupidStrategy001();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*MeoconStupidStrategy001::MeoconStupidStrategy001(BaseCondition &buy_condition, BaseCondition &sell_condition) : BaseStrategy(buy_condition, sell_condition)
  {
  }
  */
  
  MeoconStupidStrategy001::MeoconStupidStrategy001(int ma_signal_trend_handle, int ma_signal_1_handle, int ma_signal_2_handle, int ma_signal_3_handle, int ma_trend_handle,       int rsi_handle, int ma_rsi_signal_1_handle, int ma_rsi_signal_2_handle, int ma_rsi_signal_3_handle, int ma_rsi_trend_handle) 
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
      m_ma_rsi_trend_handle = ma_rsi_trend_handle;


      

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MeoconStupidStrategy001::~MeoconStupidStrategy001()
  {
  }
//+------------------------------------------------------------------+

void MeoconStupidStrategy001::BuildBuyConditions() {
      CArrayObj *buy_conditions = new CArrayObj;
      //Range range={-1,1};
      //buy_conditions.Add(new IndicatorsComparator(m_ma_signal_2_handle, m_ma_signal_3_handle,1, range ));
      
      // Setup RSI buy conditions
      
      // ma_rsi_signal 2
      Range ma_rsi_signal_2_vs_rsi_trend_range = {0.1, 5};
      buy_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_2_handle, m_ma_rsi_trend_handle,1, ma_rsi_signal_2_vs_rsi_trend_range));
      
      // ma_rsi_signal 3
      Range ma_rsi_signal_3_vs_rsi_trend_range = {0.1, 3};
      buy_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_3_handle, m_ma_rsi_trend_handle,1, ma_rsi_signal_3_vs_rsi_trend_range));
      
      //ma_rsi_signal 1 vs ma_rsi_signal 2/3
       Range ma_rsi_signal_1_vs_ma_rsi_signal_2_3_range = {0.1, 100};
      buy_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_1_handle, m_ma_rsi_signal_2_handle,1, ma_rsi_signal_1_vs_ma_rsi_signal_2_3_range));
      buy_conditions.Add(new IndicatorsComparator(m_ma_rsi_signal_1_handle, m_ma_rsi_signal_3_handle,1, ma_rsi_signal_1_vs_ma_rsi_signal_2_3_range));
      
      
      m_buy_condition = new AndCondition(buy_conditions);
}
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