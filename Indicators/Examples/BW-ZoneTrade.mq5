//+------------------------------------------------------------------+
//|                                                 BW-ZoneTrade.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009-2017, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
//--- indicator settings
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_plots   1
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  Green,Red,Gray
#property indicator_width1  3
#property indicator_label1  "Open;High;Low;Close"
//--- indicator buffers
double ExtOBuffer[];
double ExtHBuffer[];
double ExtLBuffer[];
double ExtCBuffer[];
double ExtColorBuffer[];
double ExtAOBuffer[];
double ExtACBuffer[];
//--- handles of indicators
int    ExtACHandle;
int    ExtAOHandle;
//--- bars minimum for calculation
#define DATA_LIMIT 38
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtOBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtHBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,ExtLBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,ExtCBuffer,INDICATOR_DATA);
   SetIndexBuffer(4,ExtColorBuffer,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(5,ExtACBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(6,ExtAOBuffer,INDICATOR_CALCULATIONS);
//---
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//--- sets first bar from what index will be drawn
   IndicatorSetString(INDICATOR_SHORTNAME,"BW ZoneTrade");
//--- don't show indicator data in DataWindow
   PlotIndexSetInteger(0,PLOT_SHOW_DATA,false);
//--- sets first candle from what index will be drawn
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,DATA_LIMIT);
//--- get handles
   ExtACHandle=iAC(NULL,0);
   ExtAOHandle=iAO(NULL,0);
//--- initialization done
  }
//+------------------------------------------------------------------+
//| Trade zone by Bill Williams                                      | 
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
   int i,limit;
//--- check for bars count
   if(rates_total<DATA_LIMIT)
      return(0);// not enough bars for calculation
//--- not all data may be calculated
   int calculated=BarsCalculated(ExtACHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtACHandle is calculated (",calculated,"bars ). Error",GetLastError());
      return(0);
     }
   calculated=BarsCalculated(ExtAOHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtAOHandle is calculated (",calculated,"bars ). Error",GetLastError());
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
//--- get AC buffer
   if(IsStopped()) return(0); //Checking for stop flag
   if(CopyBuffer(ExtACHandle,0,0,to_copy,ExtACBuffer)<=0)
     {
      Print("Getting iAC is failed! Error",GetLastError());
      return(0);
     }
//--- get AO buffer
   if(IsStopped()) return(0); //Checking for stop flag
   if(CopyBuffer(ExtAOHandle,0,0,to_copy,ExtAOBuffer)<=0)
     {
      Print("Getting iAO is failed! Error",GetLastError());
      return(0);
     }
//--- set first bar from what calculation will start
   if(prev_calculated<DATA_LIMIT)
      limit=DATA_LIMIT;
   else
      limit=prev_calculated-1;
//--- the main loop of calculations
   for(i=limit;i<rates_total && !IsStopped();i++)
     {
      ExtOBuffer[i]=open[i];
      ExtHBuffer[i]=high[i];
      ExtLBuffer[i]=low[i];
      ExtCBuffer[i]=close[i];
      //--- set color for candle
      ExtColorBuffer[i]=2.0;  // set gray Color
      //--- check for Green Zone and set Color Green
      if(ExtACBuffer[i]>ExtACBuffer[i-1] && ExtAOBuffer[i]>ExtAOBuffer[i-1])
         ExtColorBuffer[i]=0.0;
      //--- check for Red Zone and set Color Red
      if(ExtACBuffer[i]<ExtACBuffer[i-1] && ExtAOBuffer[i]<ExtAOBuffer[i-1])
         ExtColorBuffer[i]=1.0;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
