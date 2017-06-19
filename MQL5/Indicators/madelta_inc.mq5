//+------------------------------------------------------------------+
//|                                                      madelta_inc |
//|                                           Copyright 2013 Winston |
//+------------------------------------------------------------------+
#property copyright "Winston 2013"
#property version "1.10"
#property description "madelta_inc"
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_plots   3
//---
#property indicator_type1   DRAW_COLOR_LINE
#property indicator_color1  White,Yellow,Red
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2
//---
#property indicator_type2   DRAW_LINE
#property indicator_color2  Yellow
#property indicator_style2  STYLE_DOT
#property indicator_width2  1
//---
#property indicator_type3   DRAW_LINE
#property indicator_color3  Red
#property indicator_style3  STYLE_DOT
#property indicator_width3  1
//---
input double d=0.00195;                     //Delta
input double m=39.2;                        //Mult
//---
input int F=26;                             //Fast moving average
input ENUM_MA_METHOD FM=MODE_SMA;           //Fast average mode
input ENUM_APPLIED_PRICE FP=PRICE_WEIGHTED; //Fast price mode
//---
input int S=51;                             //Slow moving average
input ENUM_MA_METHOD SM=MODE_EMA;           //Slow average mode
input ENUM_APPLIED_PRICE SP=PRICE_MEDIAN;   //Slow price mode
//---
int Ms,Mf,trend,flg=0;
double px,hi,lo;
double ms[1],mf[1];
double ag[],bg[],cg[],ac[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
   SetIndexBuffer(0,ag,INDICATOR_DATA);
   ArraySetAsSeries(ag,true);          //signal
//---
   SetIndexBuffer(1,ac,INDICATOR_COLOR_INDEX);
   ArraySetAsSeries(ac,true);          //signal trend colour
//---
   SetIndexBuffer(2,bg,INDICATOR_DATA);
   ArraySetAsSeries(bg,true);          //hi threshold
//---
   SetIndexBuffer(3,cg,INDICATOR_DATA);
   ArraySetAsSeries(cg,true);          //lo threshold
//---
   Mf=iMA(NULL,PERIOD_H1,F,0,FM,FP);
   Ms=iMA(NULL,PERIOD_H1,S,0,SM,SP);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,       // size of the price[] array
                const int prev_calculated,   // bars handled on a previous call
                const int begin,             // where the significant data start from
                const double& price[])       // array to calculate
  {
//---
   CopyBuffer(Mf,0,0,1,mf);   //fast moving average value
   CopyBuffer(Ms,0,0,1,ms);   //slow moving average value
//---
   px=pow(m*(mf[0]-ms[0]),3); //amplify and cube the difference
//---
   if(flg==0) //initialise on first pass
     {
      ArrayInitialize(ag,EMPTY_VALUE);
      ArrayInitialize(bg,EMPTY_VALUE);
      ArrayInitialize(cg,EMPTY_VALUE);
      hi=0;
      lo=0;
      trend=0;
      flg=1;
     }
//---
   if(px>hi){hi=px; lo=hi-d; trend=1;}    //identify trend
   if(px<lo){lo=px; hi=lo+d; trend=2;}    //with colour change
//---
   ag[0]=px;
   bg[0]=hi;
   cg[0]=lo;
   ac[0]=trend;
//---
   return(rates_total);
  }
//+------------------------------------------------------------------+
