//+------------------------------------------------------------------+
//|                                         CandleConditionsImpl.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "..\Condition.mqh"
#include "..\..\..\Util\CandleUtils.mqh"


class CandleTypeChecker: public BaseCondition
  {
private:
                  ENUM_TIMEFRAMES m_time_frame;
                  int m_shift;
                  CandleTypeDef m_candle_type_check;

public:
                     CandleTypeChecker(ENUM_TIMEFRAMES time_frame, int shift, CandleTypeDef &candle_type_check);
                    ~CandleTypeChecker();
                    bool IsConditionPassed(ExecutionData &data);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleTypeChecker::CandleTypeChecker(ENUM_TIMEFRAMES time_frame, int shift, CandleTypeDef &candle_type_check)
  {
      m_time_frame = time_frame;
      m_shift = shift;
      m_candle_type_check = candle_type_check;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleTypeChecker::~CandleTypeChecker()
  {
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CandleTypeChecker::IsConditionPassed(ExecutionData &data)
  {
  
      CandleStruct cs = GetCandleStruct(m_time_frame, m_shift);
      double body_percentage = cs.body *100 / cs.length;
      double shadow_top_percentage = cs.shadow_top * 100/ cs.length;
      double shadow_bottom_percentage = cs.shadow_bottom * 100/ cs.length;
      
      
      return false;
  }
//+------------------------------------------------------------------+
