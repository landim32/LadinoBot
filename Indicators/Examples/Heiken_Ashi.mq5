
//+------------------------------------------------------------------+
//|                                                  Heiken_Ashi.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009-2017, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
//--- indicator settings
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   1
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  DodgerBlue, Red
#property indicator_label1  "Heiken Ashi Open;Heiken Ashi High;Heiken Ashi Low;Heiken Ashi Close"
//--- indicator buffers
double ExtOBuffer[];
double ExtHBuffer[];
double ExtLBuffer[];
double ExtCBuffer[];
double ExtColorBuffer[];
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
//---
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//--- sets first bar from what index will be drawn
   IndicatorSetString(INDICATOR_SHORTNAME,"Heiken Ashi");
//--- sets drawing line empty value
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0.0);
//--- initialization done
  }
//+------------------------------------------------------------------+
//| Heiken Ashi                                                      |
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
//--- preliminary calculations
   if(prev_calculated==0)
     {
      //--- set first candle
      ExtLBuffer[0]=low[0];
      ExtHBuffer[0]=high[0];
      ExtOBuffer[0]=open[0];
      ExtCBuffer[0]=close[0];
      limit=1;
     }
   else limit=prev_calculated-1;

//--- the main loop of calculations
   for(i=limit;i<rates_total && !IsStopped();i++)
     {
      double haOpen=(ExtOBuffer[i-1]+ExtCBuffer[i-1])/2;
      double haClose=(open[i]+high[i]+low[i]+close[i])/4;
      double haHigh=MathMax(high[i],MathMax(haOpen,haClose));
      double haLow=MathMin(low[i],MathMin(haOpen,haClose));

      ExtLBuffer[i]=haLow;
      ExtHBuffer[i]=haHigh;
      ExtOBuffer[i]=haOpen;
      ExtCBuffer[i]=haClose;

      //--- set candle color
      if(haOpen<haClose) ExtColorBuffer[i]=0.0; // set color DodgerBlue
      else               ExtColorBuffer[i]=1.0; // set color Red
     }
//--- done
   return(rates_total);
  }
//+------------------------------------------------------------------+
