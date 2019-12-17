//+------------------------------------------------------------------+
//|                                            LadinoStatusPanel.mqh |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright "Rodrigo Landim"
#property link      "http://www.emagine.com.br"

#include <Controls\Panel.mqh>

class LadinoStatusPanel : public CPanel {
   private:
   public:
      LadinoStatusPanel();
      ~LadinoStatusPanel();
      
      bool Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2);
};

void LadinoStatusPanel::LadinoStatusPanel() {
}

void LadinoStatusPanel::~LadinoStatusPanel() {
}

bool LadinoStatusPanel::Create(
   const long chart,
   const string name,
   const int subwin,
   const int x1,
   const int y1,
   const int x2,
   const int y2
) {

   if(!CPanel::Create(chart,name,subwin,x1,y1,x2,y2)) 
      return(false);
      
   CPanel::Alignment(WND_ALIGN_CLIENT, 0,10,10,0);
      
   return(true);
}