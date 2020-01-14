//+------------------------------------------------------------------+
//|                                                    Alligator.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009-2017, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

//---- indicator settings
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   3
#property indicator_type1   DRAW_LINE
#property indicator_type2   DRAW_LINE
#property indicator_type3   DRAW_LINE
#property indicator_color1  Blue
#property indicator_color2  Red
#property indicator_color3  Lime
#property indicator_width1  1
#property indicator_width2  1
#property indicator_width3  1
#property indicator_label1  "Jaws"
#property indicator_label2  "Teeth"
#property indicator_label3  "Lips"
//---- input parameters
input int                InpJawsPeriod=13;               // Jaws period
input int                InpJawsShift=8;                 // Jaws shift
input int                InpTeethPeriod=8;               // Teeth period
input int                InpTeethShift=5;                // Teeth shift
input int                InpLipsPeriod=5;                // Lips period
input int                InpLipsShift=3;                 // Lips shift
input ENUM_MA_METHOD     InpMAMethod=MODE_SMMA;          // Moving average method
input ENUM_APPLIED_PRICE InpAppliedPrice=PRICE_MEDIAN;   // Applied price
//---- indicator buffers
double ExtJaws[];
double ExtTeeth[];
double ExtLips[];
//---- handles for moving averages
int    ExtJawsHandle;
int    ExtTeethHandle;
int    ExtLipsHandle;
//--- bars minimum for calculation
int    ExtBarsMinimum;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtJaws,INDICATOR_DATA);
   SetIndexBuffer(1,ExtTeeth,INDICATOR_DATA);
   SetIndexBuffer(2,ExtLips,INDICATOR_DATA);
//--- set accuracy
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//---- sets first bar from what index will be drawn
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,InpJawsPeriod-1);
   PlotIndexSetInteger(1,PLOT_DRAW_BEGIN,InpTeethPeriod-1);
   PlotIndexSetInteger(2,PLOT_DRAW_BEGIN,InpLipsPeriod-1);
//---- line shifts when drawing
   PlotIndexSetInteger(0,PLOT_SHIFT,InpJawsShift);
   PlotIndexSetInteger(1,PLOT_SHIFT,InpTeethShift);
   PlotIndexSetInteger(2,PLOT_SHIFT,InpLipsShift);
//---- name for DataWindow 
   PlotIndexSetString(0,PLOT_LABEL,"Jaws("+string(InpJawsPeriod)+")");
   PlotIndexSetString(1,PLOT_LABEL,"Teeth("+string(InpTeethPeriod)+")");
   PlotIndexSetString(2,PLOT_LABEL,"Lips("+string(InpLipsPeriod)+")");
//--- get MA's handles
   ExtJawsHandle=iMA(NULL,0,InpJawsPeriod,0,InpMAMethod,InpAppliedPrice);
   ExtTeethHandle=iMA(NULL,0,InpTeethPeriod,0,InpMAMethod,InpAppliedPrice);
   ExtLipsHandle=iMA(NULL,0,InpLipsPeriod,0,InpMAMethod,InpAppliedPrice);
//--- bars minimum for calculation
   ExtBarsMinimum=InpJawsPeriod+InpJawsShift;
   if(ExtBarsMinimum<(InpTeethPeriod+InpTeethShift))
      ExtBarsMinimum=InpTeethPeriod+InpTeethShift;
   if(ExtBarsMinimum<(InpLipsPeriod+InpLipsPeriod))
      ExtBarsMinimum=InpLipsPeriod+InpLipsPeriod;
//--- initialization done
  }
//+------------------------------------------------------------------+
//|  Alligator OnCalculate function                                  |
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
   if(rates_total<ExtBarsMinimum)
      return(0); // not enough bars for calculation
//--- not all data may be calculated
   int calculated=BarsCalculated(ExtJawsHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtJawsHandle is calculated (",calculated,"bars ). Error",GetLastError());
      return(0);
     }
   calculated=BarsCalculated(ExtTeethHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtTeethHandle is calculated (",calculated,"bars ). Error",GetLastError());
      return(0);
     }
   calculated=BarsCalculated(ExtLipsHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtLipsHandle is calculated (",calculated,"bars ). Error",GetLastError());
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
//---- get ma buffers
   if(IsStopped()) return(0); //Checking for stop flag
   if(CopyBuffer(ExtJawsHandle,0,0,to_copy,ExtJaws)<=0)
     {
      Print("getting ExtJawsHandle is failed! Error",GetLastError());
      return(0);
     }
   if(IsStopped()) return(0); //Checking for stop flag
   if(CopyBuffer(ExtTeethHandle,0,0,to_copy,ExtTeeth)<=0)
     {
      Print("getting ExtTeethHandle is failed! Error",GetLastError());
      return(0);
     }
   if(IsStopped()) return(0); //Checking for stop flag
   if(CopyBuffer(ExtLipsHandle,0,0,to_copy,ExtLips)<=0)
     {
      Print("getting ExtLipsHandle is failed! Error",GetLastError());
      return(0);
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
