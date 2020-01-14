//+------------------------------------------------------------------+
//|                                            ColorCandlesDaily.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009-2017, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

#property indicator_separate_window
#property indicator_buffers 5
#property indicator_plots   1
//---- plot ColorCandles
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_label1  "Open;High;Low;Close"
//--- indicator buffers
double ExtOpenBuffer[];
double ExtHighBuffer[];
double ExtLowBuffer[];
double ExtCloseBuffer[];
double ExtColorsBuffer[];
//---
color  ExtColorOfDay[6]={CLR_NONE,MediumSlateBlue,DarkGoldenrod,ForestGreen,BlueViolet,Red};
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtOpenBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtHighBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,ExtLowBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,ExtCloseBuffer,INDICATOR_DATA);
   SetIndexBuffer(4,ExtColorsBuffer,INDICATOR_COLOR_INDEX);
//--- set number of colors in color buffer
   PlotIndexSetInteger(0,PLOT_COLOR_INDEXES,6);
//--- set colors for color buffer
   for(int i=1;i<6;i++)
      PlotIndexSetInteger(0,PLOT_LINE_COLOR,i,ExtColorOfDay[i]);
//--- set accuracy
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
   printf("We have %u colors of days",PlotIndexGetInteger(0,PLOT_COLOR_INDEXES));
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
//---
   int         i;
   MqlDateTime tstruct;
//----
   if(prev_calculated<1) i=0;
   else                  i=prev_calculated-1;
//----
   while(i<rates_total && !IsStopped())
     {
      ExtOpenBuffer[i]=open[i];
      ExtHighBuffer[i]=high[i];
      ExtLowBuffer[i]=low[i];
      ExtCloseBuffer[i]=close[i];
      //--- set color for every candle
      TimeToStruct(time[i],tstruct);
      ExtColorsBuffer[i]=tstruct.day_of_week;
      //---
      i++;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
