//+------------------------------------------------------------------+
//|                                                 BaseDecision.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "..\..\Common\Commons.mqh"
#include <Arrays\ArrayObj.mqh>
class BaseCondition : public CObject
  {
      public:
                     BaseCondition() {}
                     ~BaseCondition() {}
                     virtual bool IsConditionPassed(ExecutionData &data) { return false;}
  };

class CompoundCondition : public BaseCondition 
{
   protected:
                     CArrayObj *m_conditions;
   public: 
                     virtual bool IsConditionPassed(ExecutionData &data) { return false;} 
};


class OrCondition: public CompoundCondition
{
   public:
                     OrCondition(CArrayObj *conditionArr);
                     ~OrCondition() {}
                     bool IsConditionPassed(ExecutionData &data);
};

OrCondition::OrCondition(CArrayObj *conditions) {
   m_conditions = conditions;
}

bool OrCondition::IsConditionPassed(ExecutionData &data) {
   for (int i = 0; i < m_conditions.Total(); i++) {
      BaseCondition  *condition = (BaseCondition*) m_conditions.At(i);
      bool isPassed = condition.IsConditionPassed(data);
      if (isPassed) {
         return true;
      }
   }
   return false;
}


class AndCondition: public CompoundCondition
{
   public:
                     AndCondition(CArrayObj *conditionArr);
                     ~AndCondition() {}
                     bool IsConditionPassed(ExecutionData &data);
};

AndCondition::AndCondition(CArrayObj *conditions) {
   m_conditions = conditions;
}

bool AndCondition::IsConditionPassed(ExecutionData &data) {
   bool isPassed = false;
   for (int i = 0; i < m_conditions.Total(); i++) {
      BaseCondition  *condition = (BaseCondition*) m_conditions.At(i);
      isPassed = condition.IsConditionPassed(data);
      if (!isPassed) {
         return false;
      }
   }
   return isPassed;
}


