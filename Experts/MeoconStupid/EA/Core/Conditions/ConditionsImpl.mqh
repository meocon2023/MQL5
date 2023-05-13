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
      int m_higher_handle;
      int m_lower_handle;
      double m_dx_limited;
      int m_shift;

public:
                     IndicatorsComparator(int higer_handle, int lower_handle, int shift, double dx);
                    ~IndicatorsComparator();
                    bool IsConditionPassed();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
IndicatorsComparator::IndicatorsComparator(int higer_handle, int lower_handle, int shift, double dx)
  {
      m_higher_handle = higer_handle;
      m_lower_handle = lower_handle;
      m_dx_limited = dx;
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
bool IndicatorsComparator::IsConditionPassed()
  {
  
      double higher_buf[], lower_buf[];
      if (CopyBuffer(m_higher_handle,0,m_shift,1,higher_buf) <= 0) {
         printf("[ERROR][IndicatorsComparator][CopyBuffer] could not copybuffer handle:%d", m_higher_handle);
         return false;
      }
      if (CopyBuffer(m_lower_handle,0,m_shift,1,lower_buf) <= 0) {
         printf("[ERROR][IndicatorsComparator][CopyBuffer] could not copybuffer handle:%d", m_lower_handle);
         return false;
      }
      
      double higher_val = higher_buf[0];
      double lower_val = lower_buf[0];
      if (higher_val <= lower_val) {
         return false;
      }
      
      if (higher_val - lower_val > m_dx_limited) {
         return false;
      }
      return true;
      
  }
//+------------------------------------------------------------------+
