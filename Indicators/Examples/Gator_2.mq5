//+------------------------------------------------------------------+
//|                                                        Gator.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Gator Oscillator"
#property description "based on shifted Alligator buffers"
//********************************************************************
// Attention! Following correlations must be obeyed:
// 1.InpJawsPeriod>InpTeethPeriod>InpLipsPeriod;
// 2.InpJawsShift>InpTeethShift>InpLipsShift;
// 3.InpJawsPeriod>InpJawsShift;
// 4.InpTeethPeriod>InpTeethShift;
// 5.InpLipsPeriod>InpLipsShift.
//********************************************************************
//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 7
#property indicator_plots   2
#property indicator_type1   DRAW_COLOR_HISTOGRAM
#property indicator_type2   DRAW_COLOR_HISTOGRAM
#property indicator_color1  Green,Red
#property indicator_color2  Green,Red
#property indicator_width1  2
#property indicator_width2  2
#property indicator_label1  "Gator Upper"
#property indicator_label2  "Gator Lower"
//--- input parameters
input int                InpJawsPeriod=13;               // Jaws period
input int                InpJawsShift=8;                 // Jaws shift
input int                InpTeethPeriod=8;               // Teeth period
input int                InpTeethShift=5;                // Teeth shift
input int                InpLipsPeriod=5;                // Lips period
input int                InpLipsShift=3;                 // Lips shift
input ENUM_MA_METHOD     InpMAMethod=MODE_SMMA;          // Moving average method
input ENUM_APPLIED_PRICE InpAppliedPrice=PRICE_MEDIAN;   // Applied price
//--- indicator buffers
double                   ExtUpperBuffer[];
double                   ExtUpColorsBuffer[];
double                   ExtLowerBuffer[];
double                   ExtLoColorsBuffer[];
double                   ExtJawsBuffer[];
double                   ExtTeethBuffer[];
double                   ExtLipsBuffer[];
//--- handle
int                      ExtAlligatorHandle;
//--- global variables
int                      ExtUpperShift;
int                      ExtLowerShift;
bool                     ExtFlag;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtUpperBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtUpColorsBuffer,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(2,ExtLowerBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,ExtLoColorsBuffer,INDICATOR_COLOR_INDEX);
//--- MAs
   SetIndexBuffer(4,ExtJawsBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(5,ExtTeethBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(6,ExtLipsBuffer,INDICATOR_CALCULATIONS);
//--- get handles
   ExtAlligatorHandle=iAlligator(NULL,0,
                                 InpJawsPeriod,0,
                                 InpTeethPeriod,0,
                                 InpLipsPeriod,0,
                                 InpMAMethod,InpAppliedPrice);
//--- set indicator digits
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits+1);
//--- sets first bar from what index will be drawn
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,InpTeethShift+InpTeethPeriod);
   PlotIndexSetInteger(1,PLOT_DRAW_BEGIN,InpLipsShift+InpLipsPeriod);
//--- line shifts when drawing
   PlotIndexSetInteger(0,PLOT_SHIFT,InpTeethShift);
   PlotIndexSetInteger(1,PLOT_SHIFT,InpLipsShift);
//--- name for indicator subwindow label
   IndicatorSetString(INDICATOR_SHORTNAME,"Gator("+
                      string(InpJawsPeriod)+","+
                      string(InpTeethPeriod)+","+
                      string(InpLipsPeriod)+")");
//--- sets drawing line empty value
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0.0);
   PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,0.0);
//--- calculate global variables values
   ExtUpperShift=InpJawsShift-InpTeethShift;
   ExtLowerShift=InpTeethShift-InpLipsShift;
//--- check for input parameters
   ExtFlag=CheckForInput();
   if(!ExtFlag) Print("Wrong input parameters. Indicator won't work.");
//--- initialization done. 0 returned if ExtFlag is true
   return(ExtFlag?0:1);
  }
//+------------------------------------------------------------------+
//| Gator Oscillator                                                 |
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
   int    pos,shift;
   double dCurr,dPrev;
//--- check for rules and bars count
   if(ExtUpperShift>ExtLowerShift)
      shift=ExtUpperShift;
   else shift=ExtLowerShift;
   if(!ExtFlag || shift>rates_total)
      return(0);
//--- not all data may be calculated
   int calculated=BarsCalculated(ExtAlligatorHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtAlligatorHandle is calculated (",calculated,"bars ). Error",GetLastError());
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
   if(CopyBuffer(ExtAlligatorHandle,0,0,to_copy,ExtJawsBuffer)<=0)
     {
      Print("getting ExtAlligatorHandle buffer 0 is failed! Error",GetLastError());
      return(0);
     }
   if(IsStopped()) return(0); //Checking for stop flag
   if(CopyBuffer(ExtAlligatorHandle,1,0,to_copy,ExtTeethBuffer)<=0)
     {
      Print("getting ExtAlligatorHandle buffer 1 is failed! Error",GetLastError());
      return(0);
     }
   if(IsStopped()) return(0); //Checking for stop flag
   if(CopyBuffer(ExtAlligatorHandle,2,0,to_copy,ExtLipsBuffer)<=0)
     {
      Print("getting ExtAlligatorHandle buffer 2 is failed! Error",GetLastError());
      return(0);
     }
//--- last counted bar will be recounted
   pos=prev_calculated-1;
   if(pos<shift)
     {
      for(int i=0;i<shift;i++)
        {
         ExtUpperBuffer[i]=0.0;
         ExtUpColorsBuffer[i]=0.0;
         ExtLowerBuffer[i]=0.0;
         ExtLoColorsBuffer[i]=0.0;
        }
      pos=shift;
     }
//--- main cycle
   int lower_limit=ExtLowerShift+InpLipsShift+InpLipsPeriod;
   int upper_limit=ExtUpperShift+InpTeethShift+InpTeethPeriod;
   for(int i=pos;i<rates_total && !IsStopped();i++)
     {
      if(i>=lower_limit)
        {
         //--- calculate down buffer value
         dCurr=-fabs(ExtTeethBuffer[i-ExtLowerShift]-ExtLipsBuffer[i]);
         dPrev=ExtLowerBuffer[i-1];
         ExtLowerBuffer[i]=dCurr;
         //--- set down buffer color
         if(dPrev==dCurr)
            ExtLoColorsBuffer[i]=ExtLoColorsBuffer[i-1];
         else
           {
            if(dPrev<dCurr)
               ExtLoColorsBuffer[i]=1.0;
            else
               ExtLoColorsBuffer[i]=0.0;
           }
        }
      else
        {
         ExtLowerBuffer[i]=0.0;
         ExtLoColorsBuffer[i]=0.0;
        }
      if(i>=upper_limit)
        {
         //--- calculate up buffer value
         dCurr=fabs(ExtJawsBuffer[i-ExtUpperShift]-ExtTeethBuffer[i]);
         ExtUpperBuffer[i]=dCurr;
         dPrev=ExtUpperBuffer[i-1];
         //--- set up buffer color
         if(dPrev==dCurr)
            ExtUpColorsBuffer[i]=ExtUpColorsBuffer[i-1];
         else
           {
            if(dPrev<dCurr)
               ExtUpColorsBuffer[i]=0.0;
            else
               ExtUpColorsBuffer[i]=1.0;
           }
        }
      else
        {
         ExtUpperBuffer[i]=0.0;
         ExtUpColorsBuffer[i]=0.0;
        }
     }
//---
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Check for rules                                                  |
//| 1.InpJawsPeriod>InpTeethPeriod>InpLipsPeriod;                    |
//| 2.InpJawsShift>InpTeethShift>InpLipsShift;                       |
//| 3.InpJawsPeriod>InpJawsShift;                                    |
//| 4.InpTeethPeriod>InpTeethShift;                                  |
//| 5.InpLipsPeriod>InpLipsShift.                                    |
//+------------------------------------------------------------------+
bool CheckForInput()
  {
//--- 1
   if(InpJawsPeriod<=InpTeethPeriod || InpTeethPeriod<=InpLipsPeriod)
      return(false);
//--- 2
   if(InpJawsShift<=InpTeethShift || InpTeethShift<=InpLipsShift)
      return(false);
//--- 3
   if(InpJawsPeriod<=InpJawsShift)
      return(false);
//--- 4
   if(InpTeethPeriod<=InpTeethShift)
      return(false);
//--- 5
   if(InpLipsPeriod<=InpLipsShift)
      return(false);
//--- all right
   return(true);
  }
//+------------------------------------------------------------------+
