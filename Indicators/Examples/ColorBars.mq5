//+------------------------------------------------------------------+
//|                                                    ColorBars.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009-2017, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   1
//---- plot ColorBars
#property indicator_label1  "ColorBars"
#property indicator_type1   DRAW_COLOR_BARS
#property indicator_color1  Green,Red
#property indicator_label1  "Open;High;Low;Close"
//--- indicator buffers
double ExtOpenBuffer[];
double ExtHighBuffer[];
double ExtLowBuffer[];
double ExtCloseBuffer[];
double ExtColorsBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- indicators
   SetIndexBuffer(0,ExtOpenBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtHighBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,ExtLowBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,ExtCloseBuffer,INDICATOR_DATA);
   SetIndexBuffer(4,ExtColorsBuffer,INDICATOR_COLOR_INDEX);
//--- don't show indicator data in DataWindow
   PlotIndexSetInteger(0,PLOT_SHOW_DATA,false);
//--- set accuracy
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
//--- auxiliary variables
   int  i=0;
   bool vol_up=true;
//--- set position for beginning
   if(i<prev_calculated) i=prev_calculated-1;
//--- start calculations
   while(i<rates_total && !IsStopped())
     {
      ExtOpenBuffer[i]=open[i];
      ExtHighBuffer[i]=high[i];
      ExtLowBuffer[i]=low[i];
      ExtCloseBuffer[i]=close[i];
      //--- define volume change
      if(i>0)
        {
         if(tick_volume[i]>tick_volume[i-1]) vol_up=true;
         if(tick_volume[i]<tick_volume[i-1]) vol_up=false;
        }
      //--- set color
      if(vol_up) ExtColorsBuffer[i]=0.0;
      else       ExtColorsBuffer[i]=1.0;
      //---
      i++;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
