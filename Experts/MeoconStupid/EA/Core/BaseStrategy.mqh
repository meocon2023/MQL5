//+------------------------------------------------------------------+
//|                                                 BaseStrategy.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

 #include <Arrays\List.mqh>
 #include "Condition.mqh"
class BaseStrategy
  {
private:

protected:
                     BaseCondition *m_buy_condition;
                     BaseCondition *m_sell_condition;

public:
                     BaseStrategy(BaseCondition &buy_condition, BaseCondition &sell_condition);
                     BaseStrategy();
                    ~BaseStrategy();
                     Decision Execute();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaseStrategy::BaseStrategy(BaseCondition &buy_condition, BaseCondition &sell_condition)
  {
      m_buy_condition = buy_condition;
      m_sell_condition = sell_condition;
  }
  
  BaseStrategy::BaseStrategy()
  {
  }
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaseStrategy::~BaseStrategy()
  {
  }
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Decision BaseStrategy::Execute()
  {
      bool isBuyEligible = m_buy_condition.IsConditionPassed();
      
      bool isSellEligible = m_sell_condition.IsConditionPassed();
      
      if (isBuyEligible && isSellEligible) {
         printf("[ERROR LOGIC] Buy and sell condition are passed!!!!");
         return NONE;
      }
      
      if (isBuyEligible) {
         return BUY;
      }
      
      if (isSellEligible) {
         return SELL;
      }
      
      return NONE;
  }
//+------------------------------------------------------------------+
