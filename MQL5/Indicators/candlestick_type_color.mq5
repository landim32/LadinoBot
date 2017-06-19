//+------------------------------------------------------------------+
//|                                       Candlestick Type Color.mq5 |
//|                                                         VDV Soft |
//|                                                 vdv_2001@mail.ru |
//+------------------------------------------------------------------+
#property copyright "VDV Soft"
#property link      "vdv_2001@mail.ru"
#property version   "1.00"

#include <CandlestickType.mqh>
#property indicator_chart_window

#property indicator_buffers 5
#property indicator_plots   1
//--- plot 1
#property indicator_label1  ""
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  Green,Blue,Magenta,DeepSkyBlue,Orange,LightSlateGray,Red,DarkViolet
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- input parameters
//---- indicator buffers
double ExtOpen[];
double ExtHigh[];
double ExtLow[];
double ExtClose[];
double ExtColor[];
//--- indicator handles
//--- list global variable
string prefix="Candlestick Type ";
string name[]={"MARIBOZU","DOJI","SPINNING TOP","HAMMER","TURN HAMMER","LONG","SHORT"};
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtOpen,INDICATOR_DATA);
   SetIndexBuffer(1,ExtHigh,INDICATOR_DATA);
   SetIndexBuffer(2,ExtLow,INDICATOR_DATA);
   SetIndexBuffer(3,ExtClose,INDICATOR_DATA);
   SetIndexBuffer(4,ExtColor,INDICATOR_CALCULATIONS);
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//---- sets drawing line empty value--
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(2,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(3,PLOT_EMPTY_VALUE,EMPTY_VALUE);
//---
   for(int i=0;i<ArraySize(name);i++)
     {
      ObjectCreate(0,name[i],OBJ_LABEL,0,0,0);
      ObjectSetString(0,name[i],OBJPROP_FONT,"Tahoma");
      ObjectSetInteger(0,name[i],OBJPROP_FONTSIZE,8);
      ObjectSetInteger(0,name[i],OBJPROP_CORNER,2);
      ObjectSetInteger(0,name[i],OBJPROP_ANCHOR,ANCHOR_RIGHT_LOWER);
      ObjectSetInteger(0,name[i],OBJPROP_XDISTANCE,10);
      ObjectSetInteger(0,name[i],OBJPROP_YDISTANCE,i*15);
      ObjectSetInteger(0,name[i],OBJPROP_COLOR,PlotIndexGetInteger(0,PLOT_LINE_COLOR,i));
      ObjectSetString(0,name[i],OBJPROP_TEXT,name[i]);

     }
   return(0);
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
//--- ∆дем нового бара
   if(rates_total==prev_calculated)
     {
      return(rates_total);
     }
   ExtOpen[rates_total-1]=EMPTY_VALUE;
   ExtHigh[rates_total-1]=EMPTY_VALUE;
   ExtLow[rates_total-1]=EMPTY_VALUE;
   ExtClose[rates_total-1]=EMPTY_VALUE;
//--- delete object
   string objname;
   for(int i=ObjectsTotal(0,0,-1)-1;i>=0;i--)
     {
      objname=ObjectName(0,i);
      if(StringFind(objname,prefix)==-1)
         continue;
      else
         ObjectDelete(0,objname);
     }
   int objcount=0;
//---
   int limit;
   if(prev_calculated==0)
      limit=20;
   else limit=prev_calculated-5;
//--- calculate candlestick
   for(int i=limit;i<rates_total-1;i++)
     {
      ExtOpen[i]=open[i];
      ExtHigh[i]=high[i];
      ExtLow[i]=low[i];
      ExtClose[i]=close[i];
      CANDLE_STRUCTURE cand;
      RecognizeCandle(_Symbol,_Period,time[i],10,cand);
      switch(cand.type)
        {
         case CAND_MARIBOZU:
         case CAND_MARIBOZU_LONG:
            ExtColor[i]=0;
            break;
         case CAND_DOJI:
            ExtColor[i]=1;
            break;
         case CAND_SPIN_TOP:
            ExtColor[i]=2;
            break;
         case CAND_HAMMER:
            ExtColor[i]=3;
            break;
         case CAND_INVERT_HAMMER:
            ExtColor[i]=4;
            break;
         case CAND_LONG:
            ExtColor[i]=5;
            break;
         case CAND_SHORT:
            ExtColor[i]=6;
            break;
         case CAND_STAR:
            ExtColor[i]=7;
            break;
         default:
            ExtOpen[i]=EMPTY_VALUE;
            ExtHigh[i]=EMPTY_VALUE;
            ExtLow[i]=EMPTY_VALUE;
            ExtClose[i]=EMPTY_VALUE;
            break;
        }
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   for(int i=0;i<ArraySize(name);i++)
     {
      ObjectDelete(0,name[i]);
     }
//----
   string objname;
   for(int i=ObjectsTotal(0,0,-1)-1;i>=0;i--)
     {
      objname=ObjectName(0,i);
      if(StringFind(objname,prefix)==-1)
         continue;
      else
         ObjectDelete(0,objname);
     }
  }
//+------------------------------------------------------------------+
