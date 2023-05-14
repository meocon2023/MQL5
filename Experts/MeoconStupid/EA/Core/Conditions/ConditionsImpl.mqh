//+------------------------------------------------------------------+
//|                                               ConditionsImpl.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "..\Condition.mqh"
class IndicatorsComparator: public BaseCondition
  {
private:
      int m_minus_handle;
      int m_subtrahend_handle;
      Range m_range;
      int m_shift;

public:
                     IndicatorsComparator(int minus_handle, int subtrahend_handle, int shift, Range &range);
                    ~IndicatorsComparator();
                    bool IsConditionPassed(ExecutionData &data);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
IndicatorsComparator::IndicatorsComparator(int minus_handle, int subtrahend_handle, int shift, Range &range)
  {
      m_minus_handle = minus_handle;
      m_subtrahend_handle = subtrahend_handle;
      m_range = range;
      m_shift = shift;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
IndicatorsComparator::~IndicatorsComparator()
  {
  }
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IndicatorsComparator::IsConditionPassed(ExecutionData &data)
  {
  
      double minus_buf[], subtrahend_buf[];
      if (CopyBuffer(m_minus_handle,0,m_shift,1,minus_buf) <= 0) {
         printf("[ERROR][IndicatorsComparator][CopyBuffer] could not copybuffer handle:%d", m_minus_handle);
         return false;
      }
      if (CopyBuffer(m_subtrahend_handle,0,m_shift,1,subtrahend_buf) <= 0) {
         printf("[ERROR][IndicatorsComparator][CopyBuffer] could not copybuffer handle:%d", m_subtrahend_handle);
         return false;
      }
      
      double minus_val = minus_buf[0];
      double subtrahend_val = subtrahend_buf[0];
      double dx = minus_val - subtrahend_val;
      
      return dx >= m_range.min && dx <= m_range.max;
      
  }
//+------------------------------------------------------------------+

class MAClosePriceComparator : public BaseCondition {
   private:
                     int      m_ma_minus_handle;
                     ENUM_TIMEFRAMES m_time_frame_price;
                     int      m_shift;
                     Range    m_range;
                       
   protected:
   
   public:
                     MAClosePriceComparator(int ma_minus_handle,ENUM_TIMEFRAMES time_frame_price, int shift, Range &range);
                    ~MAClosePriceComparator();
                    bool IsConditionPassed(ExecutionData &data);
};

MAClosePriceComparator::MAClosePriceComparator(int ma_minus_handle,ENUM_TIMEFRAMES time_frame_price, int shift, Range &range) {
   m_ma_minus_handle = ma_minus_handle;
   m_time_frame_price = time_frame_price;
   m_shift = shift;
   m_range = range;
}

MAClosePriceComparator::~MAClosePriceComparator() {}

bool MAClosePriceComparator::IsConditionPassed(ExecutionData &data) {
      double minus_buf[];
      if (CopyBuffer(m_ma_minus_handle,0,m_shift,1,minus_buf) <= 0) {
         printf("[ERROR][MAClosePriceComparator][CopyBuffer] could not copybuffer handle:%d", m_ma_minus_handle);
         return false;
      }
      double close_price = iClose(_Symbol, m_time_frame_price, m_shift);
      double dx = minus_buf[0] - close_price;
      
      return dx >= m_range.min && dx <= m_range.max;
}

//+------------------------------------------------------------------+

class IndicatorRangeValueComparator : public BaseCondition {
   private:
                     int      m_handle;
                     int      m_shift;
                     Range    m_range;
                       
   protected:
   
   public:
                     IndicatorRangeValueComparator(int handle, int shift, Range &range);
                    ~IndicatorRangeValueComparator();
                    bool IsConditionPassed(ExecutionData &data);
};

IndicatorRangeValueComparator::IndicatorRangeValueComparator(int handle, int shift, Range &range) {
   m_handle = handle;
   m_shift = shift;
   m_range = range;
}

IndicatorRangeValueComparator::~IndicatorRangeValueComparator() {}

bool IndicatorRangeValueComparator::IsConditionPassed(ExecutionData &data) {
      double buf[];
      if (CopyBuffer(m_handle,0,m_shift,1,buf) <= 0) {
         printf("[ERROR][IndicatorRangeValueComparator][CopyBuffer] could not copybuffer handle:%d", m_handle);
         return false;
      }

      double val = buf[0];
      
      return val >= m_range.min && val <= m_range.max;
}


