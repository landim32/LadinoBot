//+------------------------------------------------------------------+
//|                                                  PanelDialog.mqh |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include <Controls\Dialog.mqh>
#include <Controls\ComboBox.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\Label.mqh>
#include <Controls\SpinEdit.mqh>
#include <ChartObjects\ChartObjectSubChart.mqh>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
//--- indents and gaps
#define INDENT_LEFT                         (11)      // indent from left (with allowance for border width)
#define INDENT_TOP                          (11)      // indent from top (with allowance for border width)
#define INDENT_RIGHT                        (11)      // indent from right (with allowance for border width)
#define INDENT_BOTTOM                       (11)      // indent from bottom (with allowance for border width)
#define CONTROLS_GAP_X                      (10)      // gap by X coordinate
#define CONTROLS_GAP_Y                      (10)      // gap by Y coordinate
//--- for combo boxes
#define COMBOBOX_WIDTH                      (100)     // size by X coordinate
#define COMBOBOX_HEIGHT                     (20)      // size by Y coordinate
//--- for spin edit
#define SPINEDIT_WIDTH                      (50)      // size by X coordinate
//+------------------------------------------------------------------+
//| Class CPanelDialog                                               |
//| Usage: main dialog of the Controls application                   |
//+------------------------------------------------------------------+
class CPanelDialog : public CAppDialog
  {
private:
   CChartObjectSubChart m_subchart;                   // the sub-chart object
   CComboBox         m_symbols;                       // the symbols combo box object
   CComboBox         m_periods;                       // the timeframes combo box object
   CCheckBox         m_time;                          // the time scale management object
   CCheckBox         m_price;                         // the price scale management object
   CLabel            m_label;                         // the label object
   CSpinEdit         m_scale;                         // the scale management object

public:
                     CPanelDialog(void);
                    ~CPanelDialog(void);
   //--- create
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   //--- chart event handler
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);

protected:
   //--- create dependent controls
   bool              CreateSubchart(void);
   bool              CreateSymbols(void);
   bool              CreatePeriods(void);
   bool              CreateTime(void);
   bool              CreatePrice(void);
   bool              CreateLabel(void);
   bool              CreateScale(void);
   //--- fill dependent controls
   bool              FillSymbols(void);
   bool              FillPeriods(void);
   //--- internal event handlers
   virtual bool      OnResize(void);
   //--- handlers of the dependent controls events
   void              OnChangeSymbols(void);
   void              OnChangePeriods(void);
   void              OnChangeTime(void);
   void              OnChangePrice(void);
   void              OnChangeScale(void);
   //--- change dialog title
   void              SetCaption(void);
  };
//+------------------------------------------------------------------+
//| Event Handling                                                   |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CPanelDialog)
ON_EVENT(ON_CHANGE,m_symbols,OnChangeSymbols)
ON_EVENT(ON_CHANGE,m_periods,OnChangePeriods)
ON_EVENT(ON_CHANGE,m_time,OnChangeTime)
ON_EVENT(ON_CHANGE,m_price,OnChangePrice)
ON_EVENT(ON_CHANGE,m_scale,OnChangeScale)
EVENT_MAP_END(CAppDialog)
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPanelDialog::CPanelDialog(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPanelDialog::~CPanelDialog(void)
  {
  }
//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+
bool CPanelDialog::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);
//--- create dependent controls
   if(!CreateSubchart())
      return(false);
   if(!CreateTime())
      return(false);
   if(!CreatePrice())
      return(false);
   if(!CreateLabel())
      return(false);
   if(!CreateScale())
      return(false);
   if(!CreatePeriods())
      return(false);
   if(!CreateSymbols())
      return(false);
//--- change dialog title
   SetCaption();
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Chart of Chart" object                               |
//+------------------------------------------------------------------+
bool CPanelDialog::CreateSubchart(void)
  {
//--- coordinates
   int x=ClientAreaLeft()+INDENT_LEFT;
   int y=ClientAreaTop()+INDENT_TOP;
   int w=ClientAreaWidth()-(INDENT_RIGHT+COMBOBOX_WIDTH+CONTROLS_GAP_X+INDENT_LEFT);
   int h=ClientAreaHeight()-(INDENT_BOTTOM+INDENT_TOP);
//--- create
   if(!m_subchart.Create(m_chart_id,m_name,m_subwin,x,y,w,h))
      return(false);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Symbols" combo box                                   |
//+------------------------------------------------------------------+
bool CPanelDialog::CreateSymbols(void)
  {
//--- coordinates
   int x1=ClientAreaWidth()-(INDENT_RIGHT+COMBOBOX_WIDTH);
   int y1=INDENT_TOP;
   int x2=x1+COMBOBOX_WIDTH;
   int y2=y1+COMBOBOX_HEIGHT;
//--- create
   if(!m_symbols.Create(m_chart_id,m_name+"Symbols",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(m_symbols))
      return(false);
   m_symbols.Alignment(WND_ALIGN_RIGHT,0,0,INDENT_RIGHT,0);
//--- fill
   if(!FillSymbols())
      return(false);
//--- select
   m_symbols.SelectByText(Symbol());
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Timeframes" combo box                                |
//+------------------------------------------------------------------+
bool CPanelDialog::CreatePeriods(void)
  {
//--- coordinates
   int x1=ClientAreaWidth()-(INDENT_RIGHT+COMBOBOX_WIDTH);
   int y1=INDENT_TOP+COMBOBOX_HEIGHT+CONTROLS_GAP_Y;
   int x2=x1+COMBOBOX_WIDTH;
   int y2=y1+COMBOBOX_HEIGHT;
//--- create
   if(!m_periods.Create(m_chart_id,m_name+"Periods",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(m_periods))
      return(false);
   m_periods.Alignment(WND_ALIGN_RIGHT,0,0,INDENT_RIGHT,0);
//--- fill
   if(!FillPeriods())
      return(false);
//--- select
   m_periods.SelectByValue(Period());
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Time scale" check box                                |
//+------------------------------------------------------------------+
bool CPanelDialog::CreateTime(void)
  {
//--- coordinates
   int x1=ClientAreaWidth()-(INDENT_RIGHT+COMBOBOX_WIDTH);
   int y1=INDENT_TOP+2*(COMBOBOX_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBOBOX_WIDTH;
   int y2=y1+COMBOBOX_HEIGHT;
//--- create
   if(!m_time.Create(m_chart_id,m_name+"Time",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_time.Text(" dates  scale"))
      return(false);
   if(!Add(m_time))
      return(false);
   m_time.Alignment(WND_ALIGN_RIGHT,0,0,INDENT_RIGHT,0);
//--- state
   m_time.Checked(m_subchart.DateScale());
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Price scale" check box                               |
//+------------------------------------------------------------------+
bool CPanelDialog::CreatePrice(void)
  {
//--- coordinates
   int x1=ClientAreaWidth()-(INDENT_RIGHT+COMBOBOX_WIDTH);
   int y1=INDENT_TOP+3*(COMBOBOX_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBOBOX_WIDTH;
   int y2=y1+COMBOBOX_HEIGHT;
//--- create
   if(!m_price.Create(m_chart_id,m_name+"Price",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_price.Text(" prices scale"))
      return(false);
   if(!Add(m_price))
      return(false);
   m_price.Alignment(WND_ALIGN_RIGHT,0,0,INDENT_RIGHT,0);
//--- state
   m_price.Checked(m_subchart.PriceScale());
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create label for the "Scale" spin edit                           |
//+------------------------------------------------------------------+
bool CPanelDialog::CreateLabel(void)
  {
//--- coordinates
   int x1=ClientAreaWidth()-(INDENT_RIGHT+COMBOBOX_WIDTH);
   int y1=INDENT_TOP+4*(COMBOBOX_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+COMBOBOX_WIDTH-SPINEDIT_WIDTH;
   int y2=y1+COMBOBOX_HEIGHT;
//--- create
   if(!m_label.Create(m_chart_id,m_name+"Label",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_label.Text("Scale"))
      return(false);
   if(!Add(m_label))
      return(false);
   m_label.Alignment(WND_ALIGN_RIGHT,0,0,INDENT_RIGHT+SPINEDIT_WIDTH,0);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Scale" spin edit                                     |
//+------------------------------------------------------------------+
bool CPanelDialog::CreateScale(void)
  {
//--- coordinates
   int x1=ClientAreaWidth()-(INDENT_RIGHT+SPINEDIT_WIDTH);
   int y1=INDENT_TOP+4*(COMBOBOX_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+SPINEDIT_WIDTH;
   int y2=y1+COMBOBOX_HEIGHT;
//--- create
   if(!m_scale.Create(m_chart_id,m_name+"Scale",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(m_scale))
      return(false);
   m_scale.Alignment(WND_ALIGN_RIGHT,0,0,INDENT_RIGHT,0);
//--- set up
   m_scale.MinValue(0);
   m_scale.MaxValue(5);
   m_scale.Value(m_subchart.Scale());
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Fill the "Symbols" combo box                                     |
//+------------------------------------------------------------------+
bool CPanelDialog::FillSymbols(void)
  {
   int total=SymbolsTotal(true);
   for(int i=0;i<total;i++)
      if(!m_symbols.ItemAdd(SymbolName(i,true)))
         return(false);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Fill the "Timeframes" combo box                                  |
//+------------------------------------------------------------------+
bool CPanelDialog::FillPeriods(void)
  {
   static string name[]=
     {
      "M1","M2","M3","M4","M5","M6","M10","M12","M15","M20","M30",
      "H1","H2","H3","H4","H6","H8","H12","Day","Week","Month"
     };
   static long   value[]=
     {
      PERIOD_M1,PERIOD_M2,PERIOD_M3,PERIOD_M4,PERIOD_M5,PERIOD_M6,
      PERIOD_M10,PERIOD_M12,PERIOD_M15,PERIOD_M20,PERIOD_M30,
      PERIOD_H1,PERIOD_H2,PERIOD_H3,PERIOD_H4,PERIOD_H6,PERIOD_H8,PERIOD_H12,
      PERIOD_D1,PERIOD_W1,PERIOD_MN1
     };
//---
   int total=ArraySize(name);
   if(total>ArraySize(value))
      total=ArraySize(value);
//---
   for(int i=0;i<total;i++)
      if(!m_periods.ItemAdd(name[i],value[i]))
         return(false);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Handler of resizing                                              |
//+------------------------------------------------------------------+
bool CPanelDialog::OnResize(void)
  {
//--- call method of parent class
   if(!CAppDialog::OnResize())
      return(false);
//--- change width of sub-chart
   m_subchart.X_Size(ClientAreaWidth()-(INDENT_RIGHT+COMBOBOX_WIDTH+CONTROLS_GAP_X+INDENT_LEFT));
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Change dialog title                                              |
//+------------------------------------------------------------------+
void CPanelDialog::SetCaption(void)
  {
   Caption(ProgramName()+"("+m_symbols.Select()+","+m_periods.Select()+")");
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CPanelDialog::OnChangeSymbols(void)
  {
   m_subchart.Symbol(m_symbols.Select());
//--- change dialog title
   SetCaption();
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CPanelDialog::OnChangePeriods(void)
  {
   m_subchart.Period((int)m_periods.Value());
//--- change dialog title
   SetCaption();
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CPanelDialog::OnChangeTime(void)
  {
   m_subchart.DateScale(m_time.Checked());
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CPanelDialog::OnChangePrice(void)
  {
   m_subchart.PriceScale(m_price.Checked());
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CPanelDialog::OnChangeScale(void)
  {
   m_subchart.Scale(m_scale.Value());
  }
//+------------------------------------------------------------------+
