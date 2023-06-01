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
      //double shadow_bottom_percentage = cs.shadow_bottom * 100/ cs.length;
      
      return shadow_top_percentage >= m_candle_type_check.shadow_top_percentage_range.min && shadow_top_percentage <= m_candle_type_check.shadow_top_percentage_range.max
            && body_percentage >= m_candle_type_check.body_percentage_range.min && body_percentage <= m_candle_type_check.body_percentage_range.max;
  }
//+------------------------------------------------------------------+


class CandleLengthChecker: public BaseCondition
  {
private:
                  ENUM_TIMEFRAMES m_time_frame;
                  int m_shift;
                  Range m_avg_length_percentage_range_check;
                  bool is_check_color;
                  CandleColor m_color_check;

public:
                     CandleLengthChecker(ENUM_TIMEFRAMES time_frame, int shift, Range &avg_length_percentage_range_check);
                     CandleLengthChecker(ENUM_TIMEFRAMES time_frame, int shift, Range &avg_length_percentage_range_check, CandleColor color_check);
                    ~CandleLengthChecker();
                    bool IsConditionPassed(ExecutionData &data);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleLengthChecker::CandleLengthChecker(ENUM_TIMEFRAMES time_frame, int shift, Range &avg_length_percentage_range_check)
  {
      m_time_frame = time_frame;
      m_shift = shift;
      m_avg_length_percentage_range_check = avg_length_percentage_range_check;
      is_check_color = false;
  }
  
CandleLengthChecker::CandleLengthChecker(ENUM_TIMEFRAMES time_frame, int shift, Range &avg_length_percentage_range_check, CandleColor color_check)
  {
      m_time_frame = time_frame;
      m_shift = shift;
      m_avg_length_percentage_range_check = avg_length_percentage_range_check;
      is_check_color = true;
      m_color_check = color_check;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleLengthChecker::~CandleLengthChecker()
  {
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CandleLengthChecker::IsConditionPassed(ExecutionData &data)
  {
  
      CandleStruct cs = GetCandleStruct(m_time_frame, m_shift);
      double min_length = (m_avg_length_percentage_range_check.min * data.normalized_candle.avg_length) / 100.0;
      double max_length = (m_avg_length_percentage_range_check.max * data.normalized_candle.avg_length) / 100.0;
      bool result = cs.length >= min_length && cs.length <= max_length;
      if (is_check_color) {
         result = result && cs.candle_color == m_color_check;
      }
      
      return result;
  }
//+------------------------------------------------------------------+
