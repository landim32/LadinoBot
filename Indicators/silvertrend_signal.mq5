//+------------------------------------------------------------------+
//|                                           SilverTrend_Signal.mq5 |
//|                                        Ramdass - Conversion only |
//+------------------------------------------------------------------+
#property copyright "SilverTrend  rewritten by CrazyChart"
#property link      "http://viac.ru/"
//---- indicator version
#property version   "1.00"
//---- drawing the indicator in the main window
#property indicator_chart_window 
//---- two buffers are used for calculation and drawing the indicator
#property indicator_buffers 2
//---- only two plots are used
#property indicator_plots   2
//+----------------------------------------------+
//|  Bearish indicator drawing parameters        |
//+----------------------------------------------+
//---- drawing the indicator 1 as a symbol
#property indicator_type1   DRAW_ARROW
//---- red color is used for the indicator bearish line
#property indicator_color1  Red
//---- indicator 1 line width is equal to 4
#property indicator_width1  4
//---- displaying the bearish label of the indicator line
#property indicator_label1  "Silver Sell"
//+----------------------------------------------+
//|  Bullish indicator drawing parameters        |
//+----------------------------------------------+
//---- drawing the indicator 2 as a line
#property indicator_type2   DRAW_ARROW
//---- lime color is used as the color of the bullish indicator line
#property indicator_color2  Lime
//---- indicator 2 line width is equal to 4
#property indicator_width2  4
//---- displaying the bullish label of the indicator line
#property indicator_label2 "Silver Buy"
//+----------------------------------------------+
//|  Indicator input parameters                  |
//+----------------------------------------------+
input int RISK=3;
input int NumberofAlerts=2;
//+----------------------------------------------+

//---- declaration of dynamic arrays that
//---- will be used as indicator buffers
double SellBuffer[];
double BuyBuffer[];
//----
int K,SSP=9;
int counter=0;
bool old,uptrend_;
//---- declaration of the integer variables for the start of data calculation
int StartBars;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//---- initialization of variables of the start of data calculation
   StartBars=SSP+1;
//---- set SellBuffer[] dynamic array as an indicator buffer
   SetIndexBuffer(0,SellBuffer,INDICATOR_DATA);
//---- shifting the start of drawing the indicator 1
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,StartBars);
//--- create a label to display in DataWindow
   PlotIndexSetString(0,PLOT_LABEL,"Silver Sell");
//---- indicator symbol
   PlotIndexSetInteger(0,PLOT_ARROW,108);
//---- indexing the elements in the buffer as timeseries
   ArraySetAsSeries(SellBuffer,true);

//---- set BuyBuffer[] dynamic array as an indicator buffer
   SetIndexBuffer(1,BuyBuffer,INDICATOR_DATA);
//---- shifting the start of drawing the indicator 2
   PlotIndexSetInteger(1,PLOT_DRAW_BEGIN,StartBars);
//--- create a label to display in DataWindow
   PlotIndexSetString(1,PLOT_LABEL,"Silver Buy");
//---- indicator symbol
   PlotIndexSetInteger(1,PLOT_ARROW,108);
//---- indexing the elements in the buffer as timeseries
   ArraySetAsSeries(BuyBuffer,true);

//---- setting the format of accuracy of displaying the indicator
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//---- name for the data window and the label for tooltips 
   string short_name="SilverTrend_Signal";
   IndicatorSetString(INDICATOR_SHORTNAME,short_name);
//----   
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
//---- checking the number of bars to be enough for the calculation
   if(rates_total<StartBars) return(0);

//---- declarations of local variables 
   int limit;
   double Range,AvgRange,smin,smax,SsMax,SsMin,price;
   bool uptrend;

//---- calculations of the necessary amount of data to be copied
//---- and the 'limit' starting index for the bars recalculation loop
   if(prev_calculated>rates_total || prev_calculated<=0)// checking for the first start of the indicator calculation
     {
      K=33-RISK;
      limit=rates_total-StartBars;       // starting index for calculation of all bars
     }
   else
     {
      limit=rates_total-prev_calculated; // starting index for calculation of new bars
     }

//---- indexing elements in arrays as timeseries  
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(close,true);

//---- restore values of the variables
   uptrend=uptrend_;

//---- main indicator calculation loop
   for(int bar=limit; bar>=0; bar--)
     {
      //---- store values of the variables before running at the current bar
      if(rates_total!=prev_calculated && bar==0)
        {
         uptrend_=uptrend;
        }

      Range=0;
      AvgRange=0;
      for(int iii=bar; iii<=bar+SSP; iii++) AvgRange=AvgRange+MathAbs(high[iii]-low[iii]);
      Range=AvgRange/(SSP+1);
      //----
      SsMax=low[bar];
      SsMin=close[bar];

      for(int kkk=bar; kkk<=bar+SSP-1; kkk++)
        {
         price=high[kkk];
         if(SsMax<price) SsMax=price;
         price=low[kkk];
         if(SsMin>=price) SsMin=price;
        }

      smin=SsMin+(SsMax-SsMin)*K/100;
      smax=SsMax-(SsMax-SsMin)*K/100;

      SellBuffer[bar]=0;
      BuyBuffer[bar]=0;

      if(close[bar]<smin) uptrend=false;
      if(close[bar]>smax) uptrend=true;

      if(uptrend!=old && uptrend==true)
        {
         BuyBuffer[bar]=low[bar]-Range*0.5;

         if(bar==0)
           {
            if(counter<=NumberofAlerts)
              {
               //Alert("Silver Trend ",EnumToString(Period())," ",Symbol()," BUY");
               counter++;
              }
           }
         else counter=0;
        }
      if(uptrend!=old && uptrend==false)
        {
         SellBuffer[bar]=high[bar]+Range*0.5;

         if(bar==0)
           {
            if(counter<=NumberofAlerts)
              {
               //Alert("Silver Trend ",EnumToString(Period())," ",Symbol()," SELL");
               counter++;
              }
           }
         else counter=0;
        }

      if(bar>0) old=uptrend;
     }
//----     
   return(rates_total);
  }
//+------------------------------------------------------------------+