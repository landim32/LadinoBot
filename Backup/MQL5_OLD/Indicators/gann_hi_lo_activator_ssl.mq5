//+------------------------------------------------------------------+
//|                                     Gann_Hi_Lo_Activator_SSL.mq5 |
//|                                                        avoitenko |
//|                        https://login.mql5.com/en/users/avoitenko |
//+------------------------------------------------------------------+
#property copyright     ""
#property link          "https://login.mql5.com/en/users/avoitenko"
#property version       "1.00"
#property description   "Author: Kalenzo"

#property indicator_chart_window
#property indicator_buffers   5
#property indicator_plots     1
//--- output line
#property indicator_type1  DRAW_COLOR_LINE
#property indicator_color1 clrDodgerBlue, clrOrangeRed
#property indicator_style1 STYLE_SOLID
#property indicator_width1 2
#property indicator_label1 "GHL (4, EMA)"

//--- input parameters
input uint           InpPeriod=4;       // Period
input ENUM_MA_METHOD InpMethod=MODE_EMA;// Method
//--- buffers
double GannBuffer[];
double ColorBuffer[];
double MaHighBuffer[];
double MaLowBuffer[];
double TrendBuffer[];
//--- global vars
int ma_high_handle;
int ma_low_handle;
int period;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- check period
   period=(int)fmax(InpPeriod,2);
//--- set buffers
   SetIndexBuffer(0,GannBuffer);
   SetIndexBuffer(1,ColorBuffer,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(2,MaHighBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(3,MaLowBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(4,TrendBuffer,INDICATOR_CALCULATIONS);
//--- set direction
   ArraySetAsSeries(GannBuffer,true);
   ArraySetAsSeries(ColorBuffer,true);
   ArraySetAsSeries(MaHighBuffer,true);
   ArraySetAsSeries(MaLowBuffer,true);
   ArraySetAsSeries(TrendBuffer,true);
//--- get handles
   ma_high_handle=iMA(NULL,0,period,0,InpMethod,PRICE_HIGH);
   ma_low_handle =iMA(NULL,0,period,0,InpMethod,PRICE_LOW);
   if(ma_high_handle==INVALID_HANDLE || ma_low_handle==INVALID_HANDLE)
     {
      Print("Unable to create handle for iMA");
      return(INIT_FAILED);
     }
//--- set indicator properties
   string short_name=StringFormat("Gann High-Low Activator SSL (%u, %s)",period,StringSubstr(EnumToString(InpMethod),5));
   IndicatorSetString(INDICATOR_SHORTNAME,short_name);
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//--- set label
   short_name=StringFormat("GHL (%u, %s)",period,StringSubstr(EnumToString(InpMethod),5));
   PlotIndexSetString(0,PLOT_LABEL,short_name);
//--- done
   return(INIT_SUCCEEDED);
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
   if(rates_total<period+1)return(0);
   ArraySetAsSeries(close,true);
//---
   int limit;
   if(rates_total<prev_calculated || prev_calculated<=0)
     {
      limit=rates_total-period-1;
      ArrayInitialize(GannBuffer,EMPTY_VALUE);
      ArrayInitialize(ColorBuffer,0);
      ArrayInitialize(MaHighBuffer,0);
      ArrayInitialize(MaLowBuffer,0);
      ArrayInitialize(TrendBuffer,0);
     }
   else
      limit=rates_total-prev_calculated;
//--- get MA
   if(CopyBuffer(ma_high_handle,0,0,limit+1,MaHighBuffer)!=limit+1)return(0);
   if(CopyBuffer(ma_low_handle,0,0,limit+1,MaLowBuffer)!=limit+1)return(0);
//--- main cycle
   for(int i=limit; i>=0 && !_StopFlag; i--)
     {
      TrendBuffer[i]=TrendBuffer[i+1];
      //---
      if(NormalizeDouble(close[i],_Digits)>NormalizeDouble(MaHighBuffer[i+1],_Digits)) TrendBuffer[i]=1;
      if(NormalizeDouble(close[i],_Digits)<NormalizeDouble(MaLowBuffer[i+1],_Digits)) TrendBuffer[i]=-1;
      //---
      if(TrendBuffer[i]<0)
        {
         GannBuffer[i]=MaHighBuffer[i];
         ColorBuffer[i]=1;
        }
      //---
      if(TrendBuffer[i]>0)
        {
         GannBuffer[i]=MaLowBuffer[i];
         ColorBuffer[i]=0;
        }
     }
//--- done
   return(rates_total);
  }
//+------------------------------------------------------------------+
