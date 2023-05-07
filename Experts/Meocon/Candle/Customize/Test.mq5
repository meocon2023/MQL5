//+------------------------------------------------------------------+ 
//|                                           OnCalculate_Sample.mq5 | 
//|                        Copyright 2018, MetaQuotes Software Corp. | 
//|                                             https://www.mql5.com | 
//+------------------------------------------------------------------+ 
#property copyright "Copyright 2018, MetaQuotes Software Corp." 
#property link      "https://www.mql5.com" 
#property version   "1.00" 
#property description "Sample Momentum indicator calculation" 
  
//---- indicator settings 
#property indicator_separate_window 
#property indicator_buffers 1 
#property indicator_plots   1 
#property indicator_type1   DRAW_LINE
#property indicator_color1  Blue 

//---- inputs 
input int MomentumPeriod=14; // Calculation period 
//---- indicator buffer 
double    MomentumBuffer[]; 
//--- global variable for storing calculation period 
int       IntPeriod; 
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
void OnInit() 
  { 
//--- check the input parameter 
   if(MomentumPeriod<0) 
     { 
      IntPeriod=14; 
      Print("Period parameter has an incorrect value. The following value is to be used for calculations ",IntPeriod); 
     } 
   else 
      IntPeriod=MomentumPeriod; 
//---- buffers   
   SetIndexBuffer(0,MomentumBuffer,INDICATOR_DATA); 
//---- indicator name to be displayed in DataWindow and subwindow 
   IndicatorSetString(INDICATOR_SHORTNAME,"Momentum"+"("+string(IntPeriod)+")"); 
//--- set index of the bar the drawing starts from 
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,IntPeriod-1); 
//--- set 0.0 as an empty value that is not drawn 
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0.0); 
//--- indicator accuracy to be displayed 
   IndicatorSetInteger(INDICATOR_DIGITS,2); 
  } 
//+------------------------------------------------------------------+ 
//|  Momentum indicator calculation                                  | 
//+------------------------------------------------------------------+ 
int OnCalculate(const int rates_total,     // price[] array size  
                const int prev_calculated, // number of previously handled bars 
                const int begin,           // where significant data start from  
                const double &price[])     // value array for handling 
  { 
//--- initial position for calculations 
   int StartCalcPosition=(IntPeriod-1)+begin; 
//---- if calculation data is insufficient 
   if(rates_total<StartCalcPosition) 
      return(0);  // exit with a zero value - the indicator is not calculated 
//--- correct draw begin 
   if(begin>0) 
      PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,StartCalcPosition+(IntPeriod-1)); 
//--- start calculations, define the starting position 
   int pos=prev_calculated-1; 
   if(pos<StartCalcPosition) 
      pos=begin+IntPeriod; 
//--- main calculation loop 
   for(int i=pos;i<rates_total && !IsStopped();i++) 
      MomentumBuffer[i]=price[i]*100/price[i-IntPeriod]; 
//--- OnCalculate execution is complete. Return the new prev_calculated value for the subsequent call 
   return(rates_total); 
  }