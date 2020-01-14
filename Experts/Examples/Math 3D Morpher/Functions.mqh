//+------------------------------------------------------------------+
//|                                                    Functions.mqh |
//|                         Copyright 2019,MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//--- custom function y=f(x,y)
typedef double(*MathFunction)(double,double);

//+------------------------------------------------------------------+
//| math functions                                                   |
//+------------------------------------------------------------------+
enum EnMathFunction
  {
   Peaks=0,
   Chomolungma=1,
   ClimberDream=2,
   Granite=3,
   Hedgehog=4,
   Hill=5,
   Josephine=6,
   Screw=7,
   DoubleScrew=8,
   MultiExtremalScrew=9,
   Sink=10,
   Skin=11,
   Trapfall=12,
  };
//+------------------------------------------------------------------+
//| Names of the math functions                                      |
//+------------------------------------------------------------------+
const string ExtFunctionsNames[]=
  {
   "Peaks",
   "Chomolungma",
   "Climber Dream",
   "Granite",
   "Hedgehog",
   "Hill",
   "Josephine",
   "Screw",
   "Double Screw",
   "Multi Extremal Screw",
   "Sinc",
   "Skin",
   "Trapfall"
  };
//+------------------------------------------------------------------+
//| Function Peaks                                                   |
//+------------------------------------------------------------------+
double PeaksFunction(double x,double y)
  {
   double res = 3*MathPow((1-x),2)*MathExp(-x*x-(y+1)*(y+1))-10*(0.2*x-MathPow(x,3)-MathPow(y,5))*MathExp(-x*x-y*y)-1/3*MathExp(-(x+1)*(x+1)-y*y);
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Function Chomolungma                                             |
//+------------------------------------------------------------------+
double ChomolungmaFunction(double x,double y)
  {
   double a= MathCos(x*x)+MathCos(y*y);
   double b= MathPow(MathCos(5*x*y),5);
   double c=1.0/MathPow(2,b);
//--- calculate result
   double res=a-c;
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Function ClimberDream                                            |
//+------------------------------------------------------------------+
double ClimberDreamFunction(double x,double y)
  {
   double a= MathSin(MathSqrt(MathAbs(x - 1.3) + MathAbs(y)));
   double b= MathCos(MathSqrt(MathAbs(MathSin(x))) + MathSqrt(MathAbs(MathSin(y))));
   double f=a+b;
//--- calculate result
   double res=MathPow(f,4);
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Function Granite                                                 |
//+------------------------------------------------------------------+
double GraniteFunction(double x,double y)
  {
   double a= MathPow(MathSin(MathSqrt(MathAbs(x)+MathAbs(y))),2);
   double b= MathPow(MathCos(MathSqrt(MathAbs(x)+MathAbs(y))),2);
//--- calculate result
   double res=a*b;
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Function Hedgehog                                                |
//+------------------------------------------------------------------+
double HedgehogFunction(double x,double y)
  {
   double a1=MathSin(MathSqrt(MathAbs(x-2)+MathAbs(y)));
   double a2=MathCos(MathSqrt(MathAbs(MathSin(x)))+MathSqrt(MathAbs(MathSin(y))));
//--- calculate result
   double res=a1+a2;
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Function Hill                                                    |
//+------------------------------------------------------------------+
double HillFunction(double x,double y)
  {
//--- calculate result
   double res=MathExp(-x*x-y*y);
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Function Josephine                                               |
//+------------------------------------------------------------------+
double JosephineFunction(double x,double y)
  {
   double a= MathSin(MathPow(MathAbs(x)+MathAbs(y),0.5));
   double b= MathCos(MathPow(MathAbs(x),0.5)+MathPow(MathAbs(y),0.5));
//--- calculate function
   double res=a+b;
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Function Screw                                                   |
//+------------------------------------------------------------------+
double ScrewFunction(double x,double y)
  {
   double a=(y==0)?0:((x*y<0)?MathArctan(x/y):MathArctan(x/y)+M_PI);
   double b=x*x+y*y;
   double f=MathSin(b+a);
//--- calculate result
   double  res=(f*f);
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Function DoubleScrew                                             |
//+------------------------------------------------------------------+
double DoubleScrewFunction(double x,double y)
  {
   double a=(y==0)?0:((x*y<0)?MathArctan(x/y):MathArctan(x/y)+M_PI);
   double b=x*x+y*y;
   double res1=MathCos(b/2+a*3);
   res1=((res1*res1)/sqrt(b+1)-0.2);
   double res2=MathCos(b/2-a*3);
   res2=((res2*res2)/sqrt(b+1)-0.2);
   double f=fmax(res1,res2);
//--- calculate result
   double    res=(f>0)?f:0;
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Function MultiExtremalScrew                                      |
//+------------------------------------------------------------------+
double MultiExtremalScrewFunction(double x,double y)
  {
   double a=(y==0)?0:((x*y<0)?MathArctan(x/y):MathArctan(x/y)+M_PI);
   double b=x*x+y*y;
   double res1=MathCos(b/2+a*3);
   res1=((res1*res1)/sqrt(b+1)-0.2);
   double res2=MathCos(b/2-a*3);
   res2=((res2*res2)/sqrt(b+1)-0.2);
//--- calculate function
   double res=fmin(res1,res2);
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Function Sink                                                    |
//+------------------------------------------------------------------+
double SinkFunction(double x,double y)
  {
   static double   k=5.0;
   static double   p=6.0;
//--- calculate result
   double     res=MathSin(x*x+y*y)+k*MathExp(-p*x*x-p*y*y);
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Function Skin                                                    |
//+------------------------------------------------------------------+
double SkinFunction(double x,double y)
  {
   double a1=2*x*x;
   double a2=2*y*y;
   double b1=MathCos(a1)-1.1;
   b1=b1*b1;
   double c1=MathSin(0.5*x)-1.2;
   c1=c1*c1;
   double d1=MathCos(a2)-1.1;
   d1=d1*d1;
   double e1=MathSin(0.5*y)-1.2;
   e1=e1*e1;
//--- calculate result
   double res=b1+c1-d1+e1;
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Function Trapfall                                                |
//+------------------------------------------------------------------+
double TrapfallFunction(double x,double y)
  {
   double a1=MathSqrt(MathAbs(MathSin(x-1.0)));
   double b1=MathSqrt(MathAbs(MathSin(y+2.0)));
//--- calculate result
   double     res=-MathSqrt(MathAbs(MathSin(MathSin(a1+b1))));
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| GenerateFunctionData                                             |
//+------------------------------------------------------------------+
void GenerateFunctionData(double &data[],int &x_size,int &y_size,double x_min,double x_max,double y_min,double y_max,MathFunction function)
  {
   double dx = 0.1;
   double dy = 0.1;
//---
   x_size = (int)((x_max - x_min)/dx) + 1;
   y_size = (int)((y_max - y_min)/dy) + 1;
   ArrayResize(data,x_size*y_size);
//---
   for(int j = 0; j < y_size; j++)
     {
      for(int i = 0; i < x_size; i++)
        {
         double x = x_min + i*dx;
         double y = y_min + j*dy;
         data[j*x_size + i] = function(x,y);
        }
     }
  }
//+------------------------------------------------------------------+
//| GenerateData                                                     |
//+------------------------------------------------------------------+
void GenerateData(EnMathFunction function_id,double &data[],int &x_size,int &y_size)
  {
//---
   switch(function_id)
     {
      case Peaks:
         GenerateFunctionData(data,x_size,y_size,-3.0,+3.0,-3.0,+3.0,PeaksFunction);
         break;
      case Chomolungma:
         GenerateFunctionData(data,x_size,y_size,-2.0,+2.0,-2.0,+2.0,ChomolungmaFunction);
         break;
      case ClimberDream:
         GenerateFunctionData(data,x_size,y_size,-10.0,+10.0,-10.0,+10.0,ClimberDreamFunction);
         break;
      case Granite:
         GenerateFunctionData(data,x_size,y_size,-4.0,+4.0,-4.0,+4.0,GraniteFunction);
         break;
      case Hedgehog:
         GenerateFunctionData(data,x_size,y_size,-10.0,+10.0,-10.0,+10.0,HedgehogFunction);
         break;
      case Hill:
         GenerateFunctionData(data,x_size,y_size,-1.5,+1.5,-1.5,+1.5,HillFunction);
         break;
      case Josephine:
         GenerateFunctionData(data,x_size,y_size,-200.0,+200.0,-200.0,+200.0,JosephineFunction);
         break;
      case Screw:
         GenerateFunctionData(data,x_size,y_size,-3.0,+3.0,-3.0,+3.0,ScrewFunction);
         break;
      case DoubleScrew:
         GenerateFunctionData(data,x_size,y_size,-3.0,+3.0,-3.0,+3.0,DoubleScrewFunction);
         break;
      case MultiExtremalScrew:
         GenerateFunctionData(data,x_size,y_size,-3.0,+3.0,-3.0,+3.0,MultiExtremalScrewFunction);
         break;
      case Sink:
         GenerateFunctionData(data,x_size,y_size,-3.0,+3.0,-3.0,+3.0,SinkFunction);
         break;
      case Skin:
         GenerateFunctionData(data,x_size,y_size,-5.0,+5.0,-5.0,+5.0,SkinFunction);
         break;
      case Trapfall:
         GenerateFunctionData(data,x_size,y_size,-5.0,+5.0,-5.0,+5.0,TrapfallFunction);
         break;
     }
  }
//+------------------------------------------------------------------+
//| GenerateFunctionDataFixedSize                                    |
//+------------------------------------------------------------------+
bool GenerateFunctionDataFixedSize(int x_size,int y_size,double &data[],double x_min,double x_max,double y_min,double y_max,MathFunction function)
  {
   if(x_size<2 || y_size<2)
     {
      PrintFormat("Error in data sizes: x_size=%d,y_size=%d",x_size,y_size);
      return(false);
     }
   double dx = (x_max - x_min)/(x_size-1);
   double dy = (y_max - y_min)/(y_size-1);
   ArrayResize(data,x_size*y_size);
//---
   for(int j = 0; j < y_size; j++)
     {
      for(int i = 0; i < x_size; i++)
        {
         double x = x_min + i*dx;
         double y = y_min + j*dy;
         data[j*x_size + i] = function(x,y);
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| GenerateDataFixedSize                                            |
//+------------------------------------------------------------------+
bool GenerateDataFixedSize(int x_size,int y_size,EnMathFunction function_id,double &data[])
  {
   if(x_size<2 || y_size<2)
     {
      PrintFormat("Error in data sizes: x_size=%d,y_size=%d",x_size,y_size);
      return(false);
     }
   bool result=false;
//---
   switch(function_id)
     {
      case Peaks:
         result=GenerateFunctionDataFixedSize(x_size,y_size,data,-3.0,+3.0,-3.0,+3.0,PeaksFunction);
         break;
      case Chomolungma:
         result=GenerateFunctionDataFixedSize(x_size,y_size,data,-2.0,+2.0,-2.0,+2.0,ChomolungmaFunction);
         break;
      case ClimberDream:
         result=GenerateFunctionDataFixedSize(x_size,y_size,data,-10.0,+10.0,-10.0,+10.0,ClimberDreamFunction);
         break;
      case Granite:
         result=GenerateFunctionDataFixedSize(x_size,y_size,data,-4.0,+4.0,-4.0,+4.0,GraniteFunction);
         break;
      case Hedgehog:
         result=GenerateFunctionDataFixedSize(x_size,y_size,data,-10.0,+10.0,-10.0,+10.0,HedgehogFunction);
         break;
      case Hill:
         result=GenerateFunctionDataFixedSize(x_size,y_size,data,-1.5,+1.5,-1.5,+1.5,HillFunction);
         break;
      case Josephine:
         result=GenerateFunctionDataFixedSize(x_size,y_size,data,-200.0,+200.0,-200.0,+200.0,JosephineFunction);
         break;
      case Screw:
         result=GenerateFunctionDataFixedSize(x_size,y_size,data,-3.0,+3.0,-3.0,+3.0,ScrewFunction);
         break;
      case DoubleScrew:
         result=GenerateFunctionDataFixedSize(x_size,y_size,data,-3.0,+3.0,-3.0,+3.0,DoubleScrewFunction);
         break;
      case MultiExtremalScrew:
         result=GenerateFunctionDataFixedSize(x_size,y_size,data,-3.0,+3.0,-3.0,+3.0,MultiExtremalScrewFunction);
         break;
      case Sink:
         result=GenerateFunctionDataFixedSize(x_size,y_size,data,-3.0,+3.0,-3.0,+3.0,SinkFunction);
         break;
      case Skin:
         result=GenerateFunctionDataFixedSize(x_size,y_size,data,-5.0,+5.0,-5.0,+5.0,SkinFunction);
         break;
      case Trapfall:
         result=GenerateFunctionDataFixedSize(x_size,y_size,data,-5.0,+5.0,-5.0,+5.0,TrapfallFunction);
         break;
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
