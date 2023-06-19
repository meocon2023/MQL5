//+------------------------------------------------------------------+
//|                                               ConditionsImpl.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "..\Condition.mqh"
#include "..\..\..\Util\CandleUtils.mqh"
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
//+------------------------------------------------------------------+

class PriceCrossMAChecker : public BaseCondition {
   private:
                     int      m_ma_handle;
                     ENUM_TIMEFRAMES m_time_frame;
                     int      m_shift;
                     CrossType m_cross_type;
                       
   protected:
   
   public:
                     PriceCrossMAChecker(int ma_handle,ENUM_TIMEFRAMES time_frame, int shift, CrossType cross_type);
                    ~PriceCrossMAChecker();
                    bool IsConditionPassed(ExecutionData &data);
};

PriceCrossMAChecker::PriceCrossMAChecker(int ma_handle,ENUM_TIMEFRAMES time_frame, int shift, CrossType cross_type) {
   m_ma_handle = ma_handle;
   m_time_frame = time_frame;
   m_shift = shift;
   m_cross_type = cross_type;
}

PriceCrossMAChecker::~PriceCrossMAChecker() {}

bool PriceCrossMAChecker::IsConditionPassed(ExecutionData &data) {
      double ma_buf[];
      if (CopyBuffer(m_ma_handle,0,m_shift,1,ma_buf) <= 0) {
         printf("[ERROR][CandleCrossMAChecker][CopyBuffer] could not copybuffer handle:%d", m_ma_handle);
         return false;
      }
      double ma_val = ma_buf[0];
      CandleStruct cs = GetCandleStruct(m_time_frame, 1);
      if (m_cross_type == CROSS_UP) {
         return cs.rates.low <= ma_val && cs.rates.close > ma_val;
      } else {
         return cs.rates.high >= ma_val && cs.rates.close < ma_val;
      }

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

class IndicatorCrossChecker : public BaseCondition {
   private:
                     int      m_crossHandle;
                     int      m_crossedHandle;
                     int      m_shift;
                     CrossType    m_cross_type;
                       
   protected:
   
   public:
                     IndicatorCrossChecker(int crossHandle, int crossedHandle , int shift, CrossType cross_type);
                    ~IndicatorCrossChecker();
                    bool IsConditionPassed(ExecutionData &data);
};

IndicatorCrossChecker::IndicatorCrossChecker(int crossHandle, int crossedHandle , int shift, CrossType cross_type) {
   m_crossHandle = crossHandle;
   m_crossedHandle = crossedHandle;
   m_shift = shift;
   m_cross_type = cross_type;
}

IndicatorCrossChecker::~IndicatorCrossChecker() {}

bool IndicatorCrossChecker::IsConditionPassed(ExecutionData &data) {
      double cross_val[];
      double crossed_val[];
      if (CopyBuffer(m_crossHandle,0,m_shift,2,cross_val) <= 0) {
         printf("[ERROR][IndicatorRangeValueComparator][CopyBuffer] could not copybuffer handle:%d", m_crossHandle);
         return false;
      }
      
      if (CopyBuffer(m_crossedHandle,0,m_shift,2,crossed_val) <= 0) {
         printf("[ERROR][IndicatorRangeValueComparator][CopyBuffer] could not copybuffer handle:%d", m_crossedHandle);
         return false;
      }

      if (m_cross_type == CROSS_UP) {
         return cross_val[0] <= crossed_val[0] && cross_val[1] >= crossed_val[1];
      } else if (m_cross_type == CROSS_DOWN) {
         return cross_val[0] >= crossed_val[0] && cross_val[1] <= crossed_val[1];
      }

      return false;
}



