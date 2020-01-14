//+------------------------------------------------------------------+
//|                                                  Accelerator.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Accelerator/Decelerator"

//---- indicator settings
#property indicator_separate_window
#property indicator_buffers 6
#property indicator_plots   1
#property indicator_type1   DRAW_COLOR_HISTOGRAM
#property indicator_color1  Green,Red
#property indicator_width1  2
#property indicator_label1  "AC"
//--- indicator buffers
double ExtACBuffer[];
double ExtColorBuffer[];
double ExtFastBuffer[];
double ExtSlowBuffer[];
double ExtAOBuffer[];
double ExtSMABuffer[];
//--- handles for MAs
int    ExtFastSMAHandle;
int    ExtSlowSMAHandle;
//--- bars minimum for calculation
#define DATA_LIMIT 37
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtACBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtColorBuffer,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(2,ExtFastBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(3,ExtSlowBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(4,ExtAOBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(5,ExtSMABuffer,INDICATOR_CALCULATIONS);
//--- set accuracy
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits+2);
//--- sets first bar from what index will be drawn
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,DATA_LIMIT);
//--- name for DataWindow 
   IndicatorSetString(INDICATOR_SHORTNAME,"AC");
//--- get handles
   ExtFastSMAHandle=iMA(NULL,0,5,0,MODE_SMA,PRICE_MEDIAN);
   ExtSlowSMAHandle=iMA(NULL,0,34,0,MODE_SMA,PRICE_MEDIAN);
//--- initialization done
  }
//+------------------------------------------------------------------+
//|  Accelerator/Decelerator Oscillator                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//--- check for rates total
   if(rates_total<DATA_LIMIT)
      return(0); // not enough bars for calculation
//--- not all data may be calculated
   int calculated=BarsCalculated(ExtFastSMAHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtFastSMAHandle is calculated (",calculated,"bars ). Error",GetLastError());
      return(0);
     }
   calculated=BarsCalculated(ExtSlowSMAHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtSlowSMAHandle is calculated (",calculated,"bars ). Error",GetLastError());
      return(0);
     }
//--- we can copy not all data
   int to_copy;
   if(prev_calculated>rates_total || prev_calculated<0) to_copy=rates_total;
   else
     {
      to_copy=rates_total-prev_calculated;
      if(prev_calculated>0) to_copy++;
     }
//--- get FastSMA buffer
   if(IsStopped()) return(0); //Checking for stop flag
   if(CopyBuffer(ExtFastSMAHandle,0,0,to_copy,ExtFastBuffer)<=0)
     {
      Print("Getting fast SMA is failed! Error",GetLastError());
      return(0);
     }
//--- get SlowSMA buffer
   if(IsStopped()) return(0); //Checking for stop flag
   if(CopyBuffer(ExtSlowSMAHandle,0,0,to_copy,ExtSlowBuffer)<=0)
     {
      Print("Getting slow SMA is failed! Error",GetLastError());
      return(0);
     }
//--- calculations
   int i,limit;
//--- first calculation or number of bars was changed
   if(prev_calculated<=33)
     {
      for(i=0;i<33;i++)
        {
         ExtACBuffer[i]=0.0;
         ExtAOBuffer[i]=0.0;
        }
      limit=33;
     }
   else limit=prev_calculated-1;
//--- main loop of calculations
   for(i=limit;i<DATA_LIMIT;i++)
     {
      ExtACBuffer[i]=0.0;
      ExtAOBuffer[i]=ExtFastBuffer[i]-ExtSlowBuffer[i];
     }
   for(; i<rates_total && !IsStopped(); i++)
     {
      ExtAOBuffer[i]=ExtFastBuffer[i]-ExtSlowBuffer[i];
      double sumAO=0.0;
      for(int j=0;j<5;j++) sumAO+=ExtAOBuffer[i-j];
      ExtSMABuffer[i]=sumAO/5.0;
      ExtACBuffer[i]=ExtAOBuffer[i]-ExtSMABuffer[i];
      if(ExtACBuffer[i]>=ExtACBuffer[i-1])
         ExtColorBuffer[i]=0.0; // set color Green
      else
         ExtColorBuffer[i]=1.0; // set color Red
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }

//+------------------------------------------------------------------+
