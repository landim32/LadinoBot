//+------------------------------------------------------------------+
//|                                                    ColorLine.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009-2017, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   1
//---- plot ColorLine
#property indicator_label1  "ColorLine"
#property indicator_type1   DRAW_COLOR_LINE
#property indicator_color1  Red,Green,Blue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  3
//--- indicator buffers
double ExtColorLineBuffer[];
double ExtColorsBuffer[];
//---
int    ExtMAHandle;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtColorLineBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtColorsBuffer,INDICATOR_COLOR_INDEX);
//--- get MA handle
   ExtMAHandle=iMA(Symbol(),0,10,0,MODE_EMA,PRICE_CLOSE);
  }
//+------------------------------------------------------------------+
//| get color index                                               |
//+------------------------------------------------------------------+
int getIndexOfColor(int i)
  {
   int j=i%300;
   if(j<100) return(0);// first index
   if(j<200) return(1);// second index
   return(2); // third index
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
   static int ticks=0,modified=0;
   int        limit;
//--- check data
   int calculated=BarsCalculated(ExtMAHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtMAHandle is calculated (",calculated,"bars ). Error",GetLastError());
      return(0);
     }
//--- first calculation or number of bars was changed
   if(prev_calculated==0)
     {
      //--- copy values of MA into indicator buffer ExtColorLineBuffer
      if(IsStopped()) return(0); //Checking for stop flag
      if(CopyBuffer(ExtMAHandle,0,0,rates_total,ExtColorLineBuffer)<=0) return(0);
      //--- now set line color for every bar
      for(int i=0;i<rates_total && !IsStopped();i++)
         ExtColorsBuffer[i]=getIndexOfColor(i);
     }
   else
     {
      //--- we can copy not all data
      int to_copy;
      if(prev_calculated>rates_total || prev_calculated<0) to_copy=rates_total;
      else
        {
         to_copy=rates_total-prev_calculated;
         if(prev_calculated>0) to_copy++;
        }
      //--- copy values of MA into indicator buffer ExtColorLineBuffer
      if(IsStopped()) return(0); //Checking for stop flag
      int copied=CopyBuffer(ExtMAHandle,0,0,rates_total,ExtColorLineBuffer);
      if(copied<=0) return(0);

      ticks++;// ticks counting
      if(ticks>=5)//it's time to change color scheme
        {
         ticks=0; // reset counter
         modified++; // counter of color changes
         if(modified>=3)modified=0;// reset counter 
         ResetLastError();
         switch(modified)
           {
            case 0:// first color scheme
               PlotIndexSetInteger(0,PLOT_LINE_COLOR,0,Red);
               PlotIndexSetInteger(0,PLOT_LINE_COLOR,1,Blue);
               PlotIndexSetInteger(0,PLOT_LINE_COLOR,2,Green);
               break;
            case 1:// second color scheme
               PlotIndexSetInteger(0,PLOT_LINE_COLOR,0,Yellow);
               PlotIndexSetInteger(0,PLOT_LINE_COLOR,1,Pink);
               PlotIndexSetInteger(0,PLOT_LINE_COLOR,2,LightSlateGray);
               break;
            default:// third color scheme
               PlotIndexSetInteger(0,PLOT_LINE_COLOR,0,LightGoldenrod);
               PlotIndexSetInteger(0,PLOT_LINE_COLOR,1,Orchid);
               PlotIndexSetInteger(0,PLOT_LINE_COLOR,2,LimeGreen);
           }
        }
      else
        {
         //--- set start position
         limit=prev_calculated-1;
         //--- now we set line color for every bar
         for(int i=limit;i<rates_total && !IsStopped();i++)
            ExtColorsBuffer[i]=getIndexOfColor(i);
        }
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
