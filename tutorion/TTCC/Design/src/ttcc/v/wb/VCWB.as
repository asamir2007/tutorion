package ttcc.v.wb {
	
	//{ =*^_^*= import
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.aswing.ASColor;
	import org.aswing.AssetIcon;
	import org.aswing.AssetPane;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.Component;
	import org.aswing.CustomJFrame;
	import org.aswing.event.InteractiveEvent;
	import org.aswing.geom.IntDimension;
	import org.aswing.GridLayout;
	import org.aswing.JAdjuster;
	import org.aswing.JButton;
	import org.aswing.JColorChooser;
	import org.aswing.JFrame;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.JSeparator;
	import org.aswing.JViewport;
	import org.aswing.JWindow;
	import org.aswing.SoftBoxLayout;
	import org.aswing.event.ColorChooserEvent;
	import org.aswing.event.ResizedEvent;
	import ttcc.APP;
	import ttcc.media.Text;
	import ttcc.v.Lib;
	
	import ttcc.LOG;
	import ttcc.d.m.GUIWindowModel;
	import ttcc.n.loaders.Im;
	import ttcc.v.AVCWW;
	import ttcc.v.wb.v.*;
	//} =*^_^*= END OF import
	
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 21.08.2012 7:13
	 */
	public class VCWB extends AVCWW {
		
		private var testMode:Boolean;	
		
		//{ =*^_^*= CONSTRUCTOR	
		public function VCWB (testMode:Boolean):void {this.testMode=testMode;}
		
		//public function construct(wndMinW:uint=709, wndMinH:uint=404, pagesAreaHeight:uint=150):void {
		//public function construct(wndMinW:uint=626, wndMinH:uint=398, pagesAreaHeight:uint=150):void {
		//public function construct(wndMinW:uint=630, wndMinH:uint=344, pagesAreaHeight:uint=150):void {
		//public function construct(wndMinW:uint=670, wndMinH:uint=374, pagesAreaHeight:uint=150):void {
		public function construct(wndMinW:uint=510, wndMinH:uint=374, pagesAreaHeight:uint=150):void {
			this.wnd_minH=wndMinH;
			this.wnd_minW=wndMinW;
			this.pagesAreaHeight=pagesAreaHeight;
			
			configureVC();
			configureControll();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= =*^_^*= real pen interface
		//все что касается реальной ручки здесь, включая все поля
		//для управления рисованием эти методы:
		//currentPage.startDrawRealPen();
		//currentPage.receiveDataFromRealPen({...});
		
		private function prepareRealPenInterace():void {
			//здесь подготовка пакета для работы с пен сервером	
			
		}
		//private var поле:тип;
		
		//} =*^_^*= =*^_^*= END OF real pen interface
		
		
		
		//{ =*^_^*= user access
		
		public function setZoomPosition(x:Number, y:Number):void {
			if (currentPage) {currentPage.setZoomPosition(x,y);}
		}
		public function page_setZoomPosition(x:Number, y:Number):void {
			listener(this, ID_E_SET_POSITION, [x,y]);
		}
		public function setZoom(a:int):void {
			if (currentPage) {currentPage.setZoom(a);}
		}
		
		/**
		 * очистить доску
		 */
		public function clearWBCompletely():void {
			clearPages();
		}
		
		public function setSelPage(n:int, userID:int=0):void {
			setCurrentPage_(n);
			setPagesText('  page '+(n+1)+' of '+pages.length);
		}
		public function setPagesText(a:String):void {
			vc.setTitle(wnd_title+a);
		}
		
		public function setCurrentTool(toolID:String):void {
			var bTable:Array=[
				bDraw, S_ID_B_TOOL_DRAW
				,bLine, S_ID_B_TOOL_LINE
				,bCircle, S_ID_B_TOOL_CIRC
				,bRect, S_ID_B_TOOL_RECT
				,bEllipse, S_ID_B_TOOL_ELLIPSE
				,bText, S_ID_B_TOOL_TEXT
				,bErase, S_ID_B_TOOL_ERASE
			];
			var bb_:JButton;
			for (var i:int = 0; i < bTable.length-1;i+=2) {
				bb_=bTable[i];
				bb_.setSelected(toolID==bTable[i+1]);
			}
			
			currentTool=toolID;
			switch (toolID) {
			
				case S_ID_B_TOOL_DRAW:currentPage.setCurrentTool(WhiteboardMainPage.ID_B_TOOL_DRAW);break;
				case S_ID_B_TOOL_ELLIPSE:currentPage.setCurrentTool(WhiteboardMainPage.ID_B_TOOL_ELLIPSE);break;
				case S_ID_B_TOOL_RECT:currentPage.setCurrentTool(WhiteboardMainPage.ID_B_TOOL_RECT);break;
				case S_ID_B_TOOL_CIRC:currentPage.setCurrentTool(WhiteboardMainPage.ID_B_TOOL_CIRC);break;
				case S_ID_B_TOOL_ERASE:currentPage.setCurrentTool(WhiteboardMainPage.ID_B_TOOL_ERASE);break;
				case S_ID_B_TOOL_LINE:currentPage.setCurrentTool(WhiteboardMainPage.ID_B_TOOL_LINE);break;
				case S_ID_B_TOOL_TEXT:currentPage.setCurrentTool(WhiteboardMainPage.ID_B_TOOL_TEXT);break;
			
			}
			
		}
		private var currentTool:String=S_ID_B_TOOL_LINE;
		
		public function fromData(a:Array):void {
			var pgs:int=0;
			for each(var ii:WhiteboardMainPage in pages) {
				if (!ii) {throw new Error(pages);}
				pgs+=1;
			}
			//LOG(0,'totoal:'+pgs,1)
			
			// clear pages
			clearPages();
			//[{url:, draw:[], txt:page1}]
			// process data
			var pa:Array=[];
			for (var i:int=0;i<a.length;i++) {
				pa.push(traceObject(a[i]));
				addPage(i, [a[i]]);
			}
			//LOG(1,'fromData>pages:\n'+pa,0)
			//LOG(1,'fromData>NUM PAGES:\n'+pages.length,0)
		}
		
		private function clearPages():void {
			// clear pages
			var l:uint = pages.length;
			for (var j:int = 0;j < l;j++) {
				//LOG(0,'{:} ++= rm#'+j);
				removePage_(0, true);
			}
		}
		public function addDataItem(p:int, o:Object):void{
			addObject_(p, o);
		}
		public function clearPage(pageSN:int):void{
			var p:WhiteboardMainPage=pages[pageSN];
			if (!p) {LOG(3,'clearPage>!page');return;}
			p.clearContent();
		}
		
		public function undo(pageSN:int):void{
			LOG(3,'undo>pageSN='+pageSN);
			//remove last added object
			var p:WhiteboardMainPage=pages[pageSN];
			if (!p) {LOG(3,'undo>!page');return;}
			p.undo();
		}
		public function delDataItem(i:int):void{
			sendFmsCommand("DelWBItem", [currentPageSN, i]);
		}
		public function addBG(p:int, url:String):void{
			LOG(3,"WB::addBG() -- not supported!", 2);
		}
		
		private function sendFmsCommand(cmdName:String, param:Array=null):void{
			LOG(3,"WB::sendFmsCommand("+cmdName+"): param="+traceObject(param),0);
			listener(this, ID_E_SEND_DATA, {cmdName:cmdName, param:param});	
		}
			
		
		public function setStringOutput(outputID:uint, value:String):void {
			switch (outputID) {
			case ID_OUT_STRING_TEST_PAGE_TEXT:
				//currentPage.setText(value);
				break;
			case ID_OUT_STRING_TOP_TEXT:
				break;
			}
		}
		
		public function setUintOutput(outputID:uint, value:uint):void {
			switch (outputID) {
			
			case ID_OUT_UINT_DISPLAY_MODE:
				mode=value;
				changeDisplayMode();
				break;
			
			}
		}
		
		private function changeDisplayMode():void {
			switch (mode) {
			
			case ID_MODE_VIEW_CONTENT_ONLY:
				topBlock.remove(panelPagesScrollPane);
				topBlock.remove(panelButtonsAll);
				//bottomBlock.remove(panelButtonsR);
				//panelContent.mouseChildren=false;
				//vc.setSizeWH(vc.getWidth(), vc.getHeight());
				break;
			case ID_MODE_VIEW_FULL:
				topBlock.append(panelButtonsAll, BorderLayout.NORTH);
				//topBlock.append(panelButtonsR, BorderLayout.NORTH);
				topBlock.append(panelPagesScrollPane, BorderLayout.EAST);
				break;
			}
		}
		
		//} =*^_^*= END OF user access
		
		
		//{ =*^_^*= view
		private function configureVC():void {
			// prepare frame
			vc=new CustomJFrame(getAppRef_().get_mainScreen(), null, wnd_title);
			
			vc.construct(NAME);
			registerGUIWindowModel(vc.getModel());
			vc.setIcon(new AssetIcon(windowIconImage,-1,-1,true));
			
			vc.getContentPane().setLayout(new BorderLayout(0,0));
			titlebarH=vc.getTitleBar().getSelf().getInsets().getMarginHeight();
			vc.setMinimumWidth(wnd_minW);
			vc.setMinimumHeight(wnd_minH+titlebarH);
			
			
			//Top
			topBlock = new JPanel(new BorderLayout());
			vc.getContentPane().append(topBlock, BorderLayout.CENTER);
			//Bottom
			bottomBlock = new JPanel(new BorderLayout());
			vc.getContentPane().append(bottomBlock, BorderLayout.EAST);
			
			//buttons panel right
			panelButtonsR=new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 1, SoftBoxLayout.RIGHT));
			//topBlock.append(panelButtonsR, BorderLayout.EAST);
			//buttons panel bottom
			panelButtonsL=new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 1, SoftBoxLayout.LEFT));
			panelButtonsC=new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 1, SoftBoxLayout.CENTER));
			// ************ draw tools ************
			panelDrawTools=new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 1, SoftBoxLayout.BOTTOM));
			//topBlock.append(panelButtonsB, BorderLayout.SOUTH);
			prepareBPTools();
			prepareBPControls();
			
			panelButtonsAll=new JPanel();
			panelButtonsAll.append(panelButtonsL, BorderLayout.EAST);
			panelButtonsAll.append(panelButtonsC, BorderLayout.CENTER);
			panelButtonsAll.append(panelButtonsR, BorderLayout.WEST);
			
			//vc.getContentPane().append(panelButtonsB, BorderLayout.WEST);
			drawToolsList=new JFrame(vc,'',true);
			drawToolsList.getContentPane().append(panelDrawTools, BorderLayout.CENTER)
			drawToolsList.getTitleBar().setIconifiedButton(null);drawToolsList.getTitleBar().setMaximizeButton(null);
			drawToolsList.getTitleBar().setRestoreButton(null);drawToolsList.getTitleBar().setCloseButton(null);
			drawToolsList.pack();
			drawToolsList.setLocation(vc.getLocation());
			drawToolsList.setX(drawToolsList.getX()+12);
			drawToolsList.setY(drawToolsList.getY()+90);
			
			//content
			//panelContent=new AssetPane(null, AssetPane.SCALE_FIT_PANE);
			panelContent=new JPanel(new BorderLayout());
			//contentScrollPane = new JScrollPane(panelContent);
			topBlock.append(panelContent, BorderLayout.CENTER);
			//contentScrollPane.setMinimumSize(new IntDimension(300, 300));// TODO: move wb size from here
			//topBlock.append(contentScrollPane, BorderLayout.CENTER);
			
			//pages
			panelPages = new JPanel(new GridLayout(0,1,1,1));
			//panelPages = new JPanel(new BoxLayout(BoxLayout.X_AXIS, 2));
			panelPagesScrollPane=new JScrollPane(panelPages, JScrollPane.SCROLLBAR_ALWAYS, JScrollPane.SCROLLBAR_NEVER);
			JViewport(panelPagesScrollPane.getViewport()).setVerticalAlignment(JViewport.TOP);
			JViewport(panelPagesScrollPane.getViewport()).setHorizontalAlignment(JViewport.LEFT);
			
			//bottomBlock.append(panelPagesScrollPane, BorderLayout.CENTER);
			
			vc.regiterScrollBar(GUIWindowModel.ID_P_SSV_0, panelPagesScrollPane.getVerticalScrollBar());
			//colorChooser
			var cc:JColorChooser=new JColorChooser;
			cc.addEventListener(ColorChooserEvent.COLOR_ADJUSTING, function (e:Event):void {
				set_currentColor(e.target.getSelectedColor().getRGB());
			});
			colorChooser = JColorChooser.createDialog(cc, null, APP.lText().get_TEXT(Text.ID_TEXT_WB_SELECT_COLOR), false);
			colorChooser.getTitleBar().getMaximizeButton().setVisible(false);
			colorChooser.getTitleBar().getIconifiedButton().setVisible(false);
			
			//line width
			selectSize = new JFrame(null, APP.lText().get_TEXT(Text.ID_TEXT_WB_SELECT_LINE_TEXT_SIZE));
			selectSize.getTitleBar().getMaximizeButton().setVisible(false);
			selectSize.getTitleBar().getIconifiedButton().setVisible(false);
			var p:JPanel = new JPanel();
			var adjuster1:JAdjuster = new JAdjuster(3, JAdjuster.HORIZONTAL);
			adjuster1.setName("adjuster1");
			//adjuster1.setValues(1250, 0, 1250, 1350);
			adjuster1.setMaximum(40);
			adjuster1.setMinimum(1);
			adjuster1.setValue(1);
			//adjuster1.setValueTranslator(function(value:int):String {return Math.round(value) + "%";});
			p.append(adjuster1);
			p.pack();
			selectSize.getContentPane().append(p, BorderLayout.CENTER);
			var __handler:Function=function (e:Event):void{
				var ad:JAdjuster = e.target;
				//LOG(0,ad.getName() + " " + e.type + " handled : " + ad.getValue());
				if (e.type==InteractiveEvent.STATE_CHANGED) {set_currentThickness(ad.getValue());}
			}
			adjuster1.addActionListener(__handler);
			adjuster1.addStateListener(__handler);
			selectSize.pack();
			selectSize.setSizeWH(210, 100);
			
			vc.setSizeWH(wnd_minW,wnd_minH+titlebarH);//initial size
			
			
			addPage(0,[{draw:[{type:'line', t:3,c:0x0000ff, x0:40,y0:35,x1:100,y1:144}], url:'', txt:'page 0'}]);
			addPage(0,[{draw:[{type:'line', t:6,c:0x00aaff, x0:70,y0:75,x1:110,y1:114}], url:'', txt:'page 1'}]);
			addPage(0,[{draw:[{type:'line', t:5,c:0x1140ff, x0:61,y0:45,x1:310,y1:214}], url:'', txt:'page 2'}]);
			addPage(0,[{draw:[{type:'line', t:8,c:0x03402f, x0:161,y0:245,x1:310,y1:134}], url:'', txt:'page 3'}]);
			addPage(0,[{draw:[{type:'rect', t:3,c:0x00a0ff, x0:161,y0:245,x1:310,y1:134}], url:'', txt:'page 4'}]);
			addPage(0,[{draw:[{type:'rect', t:5,c:0x40770f, x0:61,y0:45,x1:310,y1:214}], url:'', txt:'page 5'}]);
			addPage(0,[{draw:[{type:'rect', t:6,c:0x00104f, x0:40,y0:35,x1:100,y1:144}], url:'', txt:'page 0'}]);
			addPage(0,[{draw:[{type:'rect', t:2,c:0x00906f, x0:70,y0:75,x1:110,y1:114}], url:'', txt:'page 1'}]);
			setSelPage(0);
			
			//c
			vc.show();
		}
		
		public function setToggleButtonVisibility(a:Boolean):void {
			//a=false
			if (!bToggleTools) {
				bToggleTools=createButton('testToggleMode', el_b, '', this.icon_b_settings, true, true, 'инструменты');
			}
			if (a) {
				vc.getTitleBar().addExtraControl(bToggleTools, 0);
			} else {
				vc.getTitleBar().removeExtraControl(bToggleTools);
			}
			controllDisabled=!a;
		}
		public function get_controllDisabled():Boolean {return controllDisabled;}
		private var controllDisabled:Boolean;
		
		//{ =*^_^*= buttons panels
		private function prepareBPTools():void {
			//panelButtonsB.append(Lib.createIconifiedButton('custom button', el_b, '', this.icon_b_3stbutton, true, true, ''));	
			//return;
			
			//panelButtonsB.append(createButton(S_ID_B_COLOR_OPEN, el_b, '', icon_b_color, true, true, 
			//APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_0)));
			//panelButtonsB.append(createButton(S_ID_B_TOOL_DRAW, el_b, '', icon_b_draw_up, true, true, APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_2)));
			
			bLine=Lib.createIconifiedToggleButton(S_ID_B_TOOL_LINE, el_b, '', resO[ID_ELEMENT_ICON_LINE_W], true, true, APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_3));
			panelButtonsL.append(bLine);
			
			bDraw=Lib.createIconifiedToggleButton(S_ID_B_TOOL_DRAW, el_b, '', resO[ID_ELEMENT_ICON_B_DRAW], true, true, APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_2));
			panelDrawTools.append(bDraw);
			
			bCircle=Lib.createIconifiedToggleButton(S_ID_B_TOOL_CIRC, el_b, '', resO[ID_ELEMENT_ICON_CIRCLE_W], true, true,APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_4));
			panelDrawTools.append(bCircle);
			bRect=Lib.createIconifiedToggleButton(S_ID_B_TOOL_RECT, el_b, '', resO[ID_ELEMENT_ICON_RECT_W], true, true,APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_5));
			panelDrawTools.append(bRect);
			bEllipse=Lib.createIconifiedToggleButton(S_ID_B_TOOL_ELLIPSE, el_b, '', resO[ID_ELEMENT_ICON_ELLIPSE_W], true,true,APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_6));
			panelDrawTools.append(bEllipse);
			bText=Lib.createIconifiedToggleButton(S_ID_B_TOOL_TEXT, el_b, '', resO[ID_ELEMENT_ICON_TEXT_W], true, true,APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_7));
			panelDrawTools.append(bText);
			
			bErase=Lib.createIconifiedToggleButton(S_ID_B_TOOL_ERASE, el_b, '', resO[ID_ELEMENT_ICON_ERASE_W], true, true,
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_8));
			panelDrawTools.append(bErase);
			
			panelButtonsL.append(new JSeparator(JSeparator.VERTICAL));
			
			chb=new ColorChooserButton(S_ID_B_COLOR_OPEN, el_b, '', resO[ID_ELEMENT_ICON_COLOR], true, true, 
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_0));
			panelButtonsL.append(chb);
			
			shb=new SizeChooserButton(S_ID_B_SIZE_OPEN, el_b, '', resO[ID_ELEMENT_ICON_FONT], true, true,
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_1));
			panelButtonsL.append(shb);
			
			
			panelButtonsL.append(Lib.createIconifiedButton(S_ID_B_UNDO, el_b, '', resO[ID_ELEMENT_ICON_UNDO_W], true, true,
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_9)));
			
			panelButtonsC.append(new JSeparator(JSeparator.VERTICAL));
			
			
			panelButtonsC.append(Lib.createIconifiedButton(S_ID_B_TOOL_ZOOM, el_b, '', resO[ID_ELEMENT_ICON_ZOOM_P_W], true, true,
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_18)));
			panelButtonsC.append(Lib.createIconifiedButton(S_ID_B_TOOL_ZOOM_MINUS, el_b, '', resO[ID_ELEMENT_ICON_ZOOM_M_W], true, true,
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_19)));
			panelButtonsC.append(panelButtonsR);
		}
		
		private function prepareBPControls():void {
			//panelButtonsR.append(new JSeparator(JSeparator.VERTICAL));
			panelButtonsR.append(new JSeparator(JSeparator.VERTICAL));
			
			panelButtonsR.append(Lib.createIconifiedButton(S_ID_B_LOAD, el_b, '', resO[ID_ELEMENT_ICON_UPLOAD_W], true, true,
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_15)));	
			panelButtonsR.append(Lib.createIconifiedButton(S_ID_B_SAVE, el_b, '', resO[ID_ELEMENT_ICON_SAVE_W], true, true,
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_16)));	
			panelButtonsR.append(Lib.createIconifiedButton(S_ID_B_REMOVE_ALL_PAGES, el_b, '', resO[ID_ELEMENT_ICON_DELETE_ALL_W], true, true,
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_17)));	
			
			
			panelButtonsR.append(new JSeparator(JSeparator.VERTICAL));
			panelButtonsR.append(Lib.createIconifiedButton(S_ID_B_ADD_PAGE, el_b, '', resO[ID_ELEMENT_ICON_ADD_PAGE_W], true, true,
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_10)));
			panelButtonsR.append(Lib.createIconifiedButton(S_ID_B_DEL_PAGE, el_b, '', resO[ID_ELEMENT_ICON_REMOVE_PAGE_W], true, true,
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_11)));
			panelButtonsR.append(Lib.createIconifiedButton(S_ID_B_TOOL_CLEAR_PAGE, el_b, '', resO[ID_ELEMENT_ICON_B_CLEAR_PAGE], true, true,
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_12)));
			
			panelButtonsR.append(new JSeparator(JSeparator.VERTICAL));
			panelButtonsR.append(Lib.createIconifiedButton(S_ID_B_PREV_PAGE, el_b, '',  resO[ID_ELEMENT_ICON_B_PREV], true, true,
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_13)));
			panelButtonsR.append(Lib.createIconifiedButton(S_ID_B_NEXT_PAGE, el_b, '', resO[ID_ELEMENT_ICON_B_NEXT], true, true,
			APP.lText().get_TEXT(Text.ID_TEXT_WB_TOOL_14)));	
			
		}
		
		private function createButton(id:String, el:Function, text:String, icon:DisplayObject, fixH:Boolean=false, fixW:Boolean=false, textHint:String=null):JButton {
			var sb:JButton=new JButton(text, new AssetIcon(icon));sb.name=id;
			sb.addActionListener(el);sb.pack();
			if (fixH) {sb.setMaximumHeight(sb.getHeight());}
			if (fixW) {sb.setMaximumWidth(sb.getWidth());}
			if (textHint) {sb.setToolTipText(textHint);}
			sb.setOpaque(false);
			sb.setBackgroundDecorator(null);
			return sb;
		}
		
		
		private var bDraw:JButton;
		private var bLine:JButton;
		private var bCircle:JButton;
		private var bRect:JButton;
		private var bEllipse:JButton;
		private var bText:JButton;
		private var bErase:JButton;
		
		private var panelButtonsAll:JPanel;
		private var panelButtonsR:JPanel;
		private var panelButtonsC:JPanel;
		private var panelButtonsL:JPanel;
		private var panelDrawTools:JPanel;
		private var drawToolsList:JFrame
		private var panelContent:JPanel;
		private var contentScrollPane:JScrollPane;
		private var panelPages:JPanel;
		private var panelPagesScrollPane:JScrollPane;
		private var bToggleTools:JButton;
		private var chb:ColorChooserButton;
		private var shb:SizeChooserButton;
		//} =*^_^*= END OF buttons panels
				
		public function get_displayObject():DisplayObjectContainer {return container;}		
		private var container:Sprite=new Sprite;
		private var topBlock:JPanel;
		private var leftBlock:JPanel;
		private var bottomBlock:JPanel;
		private var pagesPane:JPanel;
		private var colorChooser:JFrame;
		private var selectSize:JFrame;
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= controll
		private function configureControll():void {
			panelContent.addEventListener(ResizedEvent.RESIZED, el_panelContent_resized);
			prepare_resizeT();
			set_currentThickness(2);
			set_currentColor(0x0000ff);
			prepareRealPenInterace();
			
			//test();
			//contentScrollPane.addEventListener(ResizedEvent.RESIZED, el_panelContent_resized);
		}
		
		private function test():void {
			/*var p:WhiteboardMainPage;
			var miniPage:WhiteboardListElement;
			
			for (var i:int = 0; i < 10;i++) {
				p=new WhiteboardMainPage(this, image_page_bg);
				p.set_id(i);
				pages[i]=p;
				miniPage=new WhiteboardListElement(p, 50,50,el_minipage, p.get_pageName());
				addMiniPage(p.get_id(), miniPage);
				p.set_miniPage(miniPage);
			}
			
			setSelPage(0);
			*///var s:Sprite=new Sprite()
			//s.graphics.beginFill(0x00ffff);
			//s.graphics.drawRect(0,0,244,44)
			//panelContent.addChild(s);
		}
		
		private function el_b(e:Event):void {
			switch (e.target.name) {
			
			case S_ID_B_DEBUG_CHANGE_MODE:
				listener(this, ID_E_B_DEBUG_CHANGE_MODE, null);
				break;
			
			case S_ID_B_NEXT_PAGE:
				currentPageSN+=1;
				currentPageSN=Math.max(0, Math.min(currentPageSN, pages.length-1))
				sendSelectPage();
				break;
			case S_ID_B_PREV_PAGE:
				currentPageSN-=1;
				currentPageSN=Math.max(0, Math.min(currentPageSN, pages.length-1))
				sendSelectPage();
				break;
			case S_ID_B_ADD_PAGE:
				sendFmsCommand("AddPg2WB", [currentPageSN]);
				break;
			case S_ID_B_DEL_PAGE:
				//if (pages.length<1) {break;}
				sendFmsCommand("DelPg2WB", [currentPageSN]);
				break;
			case S_ID_B_COLOR_OPEN:
				colorChooser.setLocation(vc.getLocation());
				colorChooser.setX(colorChooser.getX()+60);
				colorChooser.show();
				break;
			case S_ID_B_SIZE_OPEN:
				/*if (currentTool==S_ID_B_TOOL_TEXT) {
					selectSize.setTitle(APP.lText().get_TEXT(Text.ID_TEXT_WB_SELECT_TEXT_SIZE));
					selectSize.revalidate();
				} else {
					selectSize.setTitle(APP.lText().get_TEXT(Text.ID_TEXT_WB_SELECT_LINE_SIZE));
					selectSize.revalidate();
				}*/
				selectSize.setLocation(vc.getLocation());
				selectSize.setX(selectSize.getX()+60);
				selectSize.show();
				break;
				
			case S_ID_B_UNDO:
				sendFmsCommand("Undo2WB", [currentPageSN]);
				break;
			
			case S_ID_B_REMOVE_ALL_PAGES:
				sendFmsCommand("ClearWB");
				break;
			case S_ID_B_SAVE:
				LOG(3,"listener(this, ID_E_B_WB_SAVE, null);");
				listener(this, ID_E_B_WB_SAVE, null);
				break;
			case S_ID_B_LOAD:
				LOG(3,"listener(this, S_ID_B_LOAD, null);");
				listener(this, ID_E_B_WB_LOAD, null);
				break;
			case S_ID_B_TOOL_CLEAR_PAGE:
				sendFmsCommand("ClearPgWB", [currentPageSN]);
				break;
				
			case S_ID_B_TOOL_ZOOM:
			case S_ID_B_TOOL_ZOOM_MINUS:
				//zoomMode=!zoomMode;
				var zoom:uint=currentPage.getZoom();
				zoom+=30*((e.target.name==S_ID_B_TOOL_ZOOM)?1:-1);
				if (zoom>220) {zoom=100;}
				if (zoom<30) {zoom=100;}
				currentPage.setZoom(zoom);
				listener(this, ID_E_B_TOOL_ZOOM, zoom);
				break;
				
			case S_ID_B_TOOL_LINE:
				if (drawToolsList.isVisible()) {
					drawToolsList.hide();
				} else {
					drawToolsList.show();
				}
				break;
			case S_ID_B_TOOL_LINE:
			case S_ID_B_TOOL_DRAW:
			case S_ID_B_TOOL_ELLIPSE:
			case S_ID_B_TOOL_RECT:
			case S_ID_B_TOOL_CIRC:
			case S_ID_B_TOOL_TEXT:
			case S_ID_B_TOOL_ERASE:
				drawToolsList.hide();
				//setCurrentTool(e.target.name);
				break;
				
			}
		}
		
		//private var zoomMode:Boolean;
		
		private function el_panelContent_resized(e:Event):void {
			//LOG(0,'w/h:'+panelContent.getWidth()+'/'+panelContent.getHeight(),2);
			if (!resized) {resized=true;return;}
			if (!currentPage) {return;}
			currentPage.setNewSize(panelContent.getWidth(), panelContent.getHeight());
			var dw:Number=panelContent.getWidth()-currentPage.getSizeW();
			var dh:Number=panelContent.getHeight()-currentPage.getSizeH();
			//vc.setSizeWH(vc.getWidth()-dw, vc.getHeight()-dh+vc.getTitleBar().getSelf().getInsets().getMarginHeight());
			resizeToW=vc.getWidth();
			resizeToH=vc.getHeight();
			if (dw>dh) {
				if (dw>0) {
					resizeToW-=dw;
					resized=false;
					resizeT.reset();resizeT.start();
					//vc.addEventListener(Event.ENTER_FRAME, el_exitFrame);
					vc.setSizeWH(resizeToW+2, resizeToH+2);
					vc.repaint();
				}
			} else if (dh>0) {
				resizeToH-=dh;
				resized=false;
				//vc.addEventListener(Event.ENTER_FRAME, el_exitFrame);
				resizeT.reset();resizeT.start();
				vc.setSizeWH(resizeToW+2, resizeToH+2);
				vc.repaint();
			}
		}
		private function prepare_resizeT():void {
			resizeT.addEventListener(TimerEvent.TIMER, function (e:Event):void {
				vc.repaintAndRevalidate()
			});
			resizeTFT.addEventListener(TimerEvent.TIMER, function (e:Event):void {
				el_panelContent_resized(null);
				resizeTFT.removeEventListener(e.type, arguments.callee);
				resizeTFT=null;
			});
		}
		
		private function el_exitFrame(e:Event):void {
			e.target.removeEventListener(e.type, arguments.callee);
			//vc.setSizeWH(resizeToW+2, resizeToH+2);
			vc.repaint();
		}
		
		private var zoomValue:int;
		private var resized:Boolean=true;
		private var resizeToW:Number;
		private var resizeToH:Number;
		private var resizeT:Timer=new Timer(20);
		private var resizeTFT:Timer=new Timer(100);
		
		//{ =*^_^*= pages
		private function setCurrentPage_(id:int):void {
			currentPageSN=id;
			LOG(0,'setCurrentPage_>'+id);
			if (currentPage) {
				zoomValue=currentPage.getZoom();
				currentPage.hide();
				//while (panelContent.numChildren>0) {panelContent.removeChildAt(0);}
				panelContent.removeAll();
				currentPage=null;
			}
			
			var page:WhiteboardMainPage=pages[id];
			if (!page) {
				LOG(3,NAME+'>setPage()>!page='+id,1);
				if (!defaultPage) {
					LOG(3,NAME+'>setPage()>!defaultPage',1);
					return;
				}
				page=defaultPage;
			}
			
			currentPage=page;
			//panelContent.addChild(currentPage);
			panelContent.append(currentPage);
			//currentPage.setNewSize(panelContent.getWidth(), panelContent.getHeight());
			currentPage.display();
			currentPage.setNewSize(panelContent.getWidth(),panelContent.getHeight());
			currentPage.setZoom(zoomValue);
			setCurrentTool(currentTool);
			
		}
		
		private function removePage_(position:int, dontSwitch:Boolean=false):void {
			var page:WhiteboardMainPage=pages[position];
			if (!page) {LOG(3,NAME+'>removePage()>!position='+position,1);return;}
			pages.splice(position, 1);
			if (currentPage==page) {
				currentPage.hide();
				//panelContent.setAsset(null);
				//if (panelContent.contains(currentPage)) {panelContent.removeChild(currentPage);}
				panelContent.removeAll();
			}
			// remove from list
			page.destruct();
			redrawPages();
			
			if (position==currentPageSN) {
				if (currentPageSN>=pages.length) {currentPageSN=Math.max(0, pages.length-1);}
				if (!dontSwitch) {sendSelectPage();}
			}
		}
		public function addPage(position:int, rawData:Object):void {
			if (rawData is Array) {rawData=[rawData[0]];}
			//LOG(0,'[:]=== addPage_>'+rawData[0].txt, 0);
			
			if (rawData[0]==null) {return;}
			
			// TODO: simply add to array
			var p:WhiteboardMainPage=new WhiteboardMainPage(this, image_page_bg, 1024, 768, 0);
			p.deserialize(rawData[0]);
			// add to list
			//LOG(0, 'position:'+position+';pages.length:'+pages.length)
			//LOG(0,'pages before add:'+pages.length);
			pages.splice(Math.min(pages.length, position), 0, p);
			//LOG(0,'pages after add:'+pages.length);
			// add to list
			var minipage:WhiteboardListElement=new WhiteboardListElement(p,50,50,el_minipage, p.get_pageName());
			p.set_miniPage(minipage);
			p.redrawBD();
			
			redrawPages();
			if (position==currentPageSN) {
				sendSelectPage();
			}
			//el_panelContent_resized(null);
			if (redrawPages_FirstRun) {redrawPages_FirstRun=false;resizeTFT.reset();resizeTFT.start();}
		}
		private function removeObject_(pageID:int, objectID:int):void {
			var page:WhiteboardMainPage=pages[pageID];
			if (!page) {LOG(3,NAME+'>removeObject_()>!id='+pageID,1);return;}
			page.removeObject(objectID);
		}
		private function addObject_(pageID:int, rawData:Object):void {
			var page:WhiteboardMainPage=pages[pageID];
			if (!page) {LOG(3,NAME+'>addObject_()>!id='+pageID,1);return;}
			page.addObject(rawData);
		}
		
		private var currentPageSN:int;
		private var currentPage:WhiteboardMainPage;
		private var defaultPage:WhiteboardMainPage;
		/**
		 * [WhiteboardMainPage]
		 */
		private var pages:Array=[];
		//} =*^_^*= END OF pages
		
		//{ =*^_^*= pages list
		private function redrawPages():void {
			panelPages.removeAll();
			for each(var i:WhiteboardMainPage in pages) {panelPages.append(i.get_miniPage());}
		}
		private var redrawPages_FirstRun:Boolean=true;
		
		private function el_minipage(target:WhiteboardListElement, eventType:int, data:Object):void {
			currentPageSN=(pages.indexOf(target.get_owner()));
			sendSelectPage();
		}
		/**
		 * WhiteboardListElement
		 */
		private var miniPagesList:Array=[];
		//} =*^_^*= END OF pages list
		
		//} =*^_^*= END OF controll
		
		//{ =*^_^*= =*^_^*= server
		public function fromServer__removeObject(pageIndex:int, newObjectsIUIDList:Array):void {
			var p:WhiteboardMainPage=pages[pageIndex];if (!p) {LOG(2,NAME+'>fromServer__removeObject>page 404, index='+pageIndex,1);return;}
			p.fromServer__removeObject(newObjectsIUIDList);
		}
		private function sendSelectPage():void {
			LOG(0,'sendSelectPage>'+currentPageSN);
			listener(this, ID_E_SELECT_PAGE, {page:currentPageSN});
		}
		public function delDataItemS(pageSN:int, i:int):void{
			removeObject_(pageSN, i);
		}
		public function delPage(p:int):void{
			removePage_(p);
		}
		//} =*^_^*= =*^_^*= END OF server
		
		
		//{ =*^_^*= events
		/**
		 * @param	listener function (target:VCWB, eventType:String, details:Object=null):void;
		 */
		public function setListener(listener:Function):void {
			this.listener = listener;
		}
		private var listener:Function;
		//} =*^_^*= END OF events
		
		//{ ^_^ drawing vars
		public function draw_addNewObject(rawData:Object):void {
			sendFmsCommand("Send2WB", [rawData, currentPageSN]);
		}
		public function get_currentColor():uint {return currentColor;}
		public function get_currentThickness():uint {return currentThickness;}
		public function set_currentThickness(a:uint):void {
			currentThickness = a;
			shb.setText(a);
			//if (currentPage) {currentPage.set_currentThickness(a);}
			listener(this, ID_E_SELECT_THICKNESS, {thickness:currentThickness});
		}
		private function set_currentColor(a:uint):void {
			currentColor = a;
			chb.setColor(a);
			//if (currentPage) {currentPage.set_currentColor(a);}
			listener(this, ID_E_SELECT_COLOR, {color:currentColor});
		}
		
		private var currentColor:uint=0x0000ff;
		private var currentThickness:uint=2;
		//} ^_^ END OF drawing vars
		
		//{ =*^_^*= =*^_^*= res
		private var wnd_title:String;
		private var mode:uint;
		
		private var bIcons:Array=[];
		private var resS:Array=[];
		
		private var resSettingsIcon:DisplayObject;
		
		private var windowIconImage:DisplayObject;
		private var icon_b_draw_up:DisplayObject;
		private var icon_b_draw_over:DisplayObject;
		private var icon_b_draw_down:DisplayObject;
		
		private var icon_b_next_up:DisplayObject;
		private var icon_b_next_over:DisplayObject;
		private var icon_b_next_down:DisplayObject;
		
		private var icon_b_prev_up:DisplayObject;
		private var icon_b_prev_over:DisplayObject;
		private var icon_b_prev_down:DisplayObject;
		
		private var icon_b_add_page_w:DisplayObject;
		private var icon_b_ellipse_w:DisplayObject;
		private var icon_b_rect_w:DisplayObject;
		private var icon_b_circle_w:DisplayObject;
		private var icon_b_clean_page_w:DisplayObject;
		private var icon_b_clean_w:DisplayObject;
		private var icon_b_color:DisplayObject;
		private var icon_b_delete_all_w:DisplayObject;
		private var icon_b_erase_w:DisplayObject;
		private var icon_b_font:DisplayObject;
		private var icon_b_line_w:DisplayObject;
		private var icon_b_next_inact_w:DisplayObject;
		private var icon_b_prev_inact_w:DisplayObject;
		private var icon_b_remove_page_w:DisplayObject;
		private var icon_b_save_w:DisplayObject;
		private var icon_b_text_w:DisplayObject;
		private var icon_b_undo_w:DisplayObject;
		private var icon_b_upload_w:DisplayObject;
		private var icon_b_zoom_m_w:DisplayObject;
		private var icon_b_zoom_p_w:DisplayObject;
		private var icon_b_settings:DisplayObject;
		
		//3st
		private var icon_b_3stbutton:Array;
		
		private var image_page_bg:DisplayObject;
		
		//} =*^_^*= =*^_^*= END OF res
		
		//{ =*^_^*= data
		private var wnd_minH:uint;
		private var wnd_minW:uint;
		private var titlebarH:uint;
		private var pagesAreaHeight:uint;
		//} =*^_^*= END OF data
		
		//{ =*^_^*= id
		private static var id00:uint=1;
		public static const ID_B_SETTINGS:int=id00++;
		//} =*^_^*= END OF id
		
		//{ =*^_^*= =*^_^*= id events
		/**
		 * data:
		 */
		public static const ID_E_B_WB_SAVE:String='ID_E_B_WB_SAVE';
		public static const ID_E_B_WB_LOAD:String='ID_E_B_WB_LOAD';
		public static const ID_E_B_DEBUG_CHANGE_MODE:String='ID_E_B_DEBUG_CHANGE_MODE';
		public static const ID_E_B_NEXT_PAGE:String='ID_E_B_NEXT_PAGE';
		public static const ID_E_B_PREV_PAGE:String='ID_E_B_PREV_PAGE';
		public static const ID_E_B_TOOL_DRAW:String='ID_E_B_TOOL_DRAW';
		public static const ID_E_B_TOOL_LINE:String='ID_E_B_TOOL_LINE';
		/**
		 * zoom value :int
		 */
		public static const ID_E_B_TOOL_ZOOM:String='ID_E_B_TOOL_ZOOM';
		/**
		 * [x,y]
		 */
		public static const ID_E_SET_POSITION:String='ID_E_SET_POSITION';
		/**
		 * data:{cmdName:String, param:Array}
		 */
		public static const ID_E_SEND_DATA:String='ID_E_SEND_DATA';
		/**
		 * data:{page:int}
		 */
		public static const ID_E_SELECT_PAGE:String='ID_E_SELECT_PAGE';
		/**
		 * data:{color:int}
		 */
		public static const ID_E_SELECT_COLOR:String='ID_E_SELECT_COLOR';
		/**
		 * data:{thickness:int}
		 */
		public static const ID_E_SELECT_THICKNESS:String='ID_E_SELECT_THICKNESS';
		/**
		 * data:{url:String}
		 */
		public static const ID_E_REQ_GET_IMAGE_BD_BY_URL:String = NAME + '>ID_E_REQ_GET_IMAGE_BD_BY_URL';

		//} =*^_^*= =*^_^*= END OF id events
		
		//{ ^_^ id
		public static const ID_OUT_STRING_TEST_PAGE_TEXT:uint=0;
		public static const ID_OUT_STRING_TOP_TEXT:uint=1;
		
		public static const ID_OUT_UINT_DISPLAY_MODE:uint=0;
		
		public static const ID_MODE_VIEW_FULL:uint=0;
		public static const ID_MODE_VIEW_CONTENT_ONLY:uint=1;
		
		private static const S_ID_B_DEBUG_CHANGE_MODE:String='testToggleMode';
		private static const S_ID_B_NEXT_PAGE:String='nextPage';
		private static const S_ID_B_PREV_PAGE:String='prevPage';
		private static const S_ID_B_ADD_PAGE:String='addPage';
		private static const S_ID_B_DEL_PAGE:String='delPage';
		
		private static const S_ID_B_COLOR_OPEN:String='colorOpen';
		private static const S_ID_B_SIZE_OPEN:String='sizeOpen';
		private static const S_ID_B_TOOL_DRAW:String='toolDraw';
		private static const S_ID_B_TOOL_LINE:String='toolLine';
		private static const S_ID_B_TOOL_RECT:String='toolRect';
		private static const S_ID_B_TOOL_ELLIPSE:String='toolEllipse';
		private static const S_ID_B_TOOL_CIRC:String='toolCirc';
		private static const S_ID_B_TOOL_TEXT:String='toolText';
		private static const S_ID_B_TOOL_ERASE:String='toolErase';
		private static const S_ID_B_TOOL_ZOOM:String='toolZoom';
		private static const S_ID_B_TOOL_ZOOM_MINUS:String='toolZoomMinus';
		private static const S_ID_B_TOOL_CLEAR_PAGE:String='toolClearPage';
		private static const S_ID_B_UNDO:String='bUndo';
		
		private static const S_ID_B_REMOVE_ALL_PAGES:String='bRemoveAllPages';
		private static const S_ID_B_LOAD:String='bSave';
		private static const S_ID_B_SAVE:String='bLoad';
		//} ^_^ END OF id
		
		//{ =*^_^*= =*^_^*= id
		private static var nextID:uint=1;
		//{ =*^_^*= icons
		/**
		 * [DisplayObject]; [up,over,down]
		 */
		public static const ID_ELEMENT_ICON_B_DRAW:uint=nextID++;
		/**
		 * [DisplayObject]; [up,over,down]
		 */
		public static const ID_ELEMENT_ICON_B_NEXT:uint=nextID++;
		/**
		 * [DisplayObject]; [up,over,down]
		 */
		public static const ID_ELEMENT_ICON_B_PREV:uint=nextID++;
		
		public static const ID_ELEMENT_ICON_ADD_PAGE_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_RECT_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_ELLIPSE_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_CIRCLE_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_CLEAN_PAGE_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_CLEAN_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_COLOR:uint=nextID++;
		public static const ID_ELEMENT_ICON_DELETE_ALL_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_ERASE_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_FONT:uint=nextID++;
		public static const ID_ELEMENT_ICON_LINE_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_NEXT_INACT_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_PREV_INACT_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_REMOVE_PAGE_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_SAVE_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_TEXT_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_UNDO_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_UPLOAD_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_ZOOM_M_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_ZOOM_P_W:uint=nextID++;
		public static const ID_ELEMENT_ICON_B_SETTINGS:uint=nextID++;
		public static const ID_ELEMENT_ICON_B_CLEAR_PAGE:uint=nextID++;
		public static const ID_ELEMENT_PAGE_BG:uint=nextID++;
		//} =*^_^*= END OF icons
		
		
		/**
		 * String
		 */
		public static const ID_ELEMENT_TEXT_WINDOW_TITLE:uint=nextID++;
		/**
		 * DisplayObject
		 */
		public static const ID_ELEMENT_ICON_WINDOW:uint=nextID++;
		//} =*^_^*= =*^_^*= END OF id
		
		//{ =*^_^*= resources
		// TODO: convert this class to separate class then use in other duplicate places
		public function resourcesAreConfigured():void {
			//{ icons
			icon_b_draw_up=resO[ID_ELEMENT_ICON_B_DRAW][0];
			icon_b_draw_over=resO[ID_ELEMENT_ICON_B_DRAW][1];
			icon_b_draw_down=resO[ID_ELEMENT_ICON_B_DRAW][2];
			
			icon_b_next_up=resO[ID_ELEMENT_ICON_B_NEXT][0];
			icon_b_next_over=resO[ID_ELEMENT_ICON_B_NEXT][1];
			icon_b_next_down=resO[ID_ELEMENT_ICON_B_NEXT][2];
			
			icon_b_prev_up=resO[ID_ELEMENT_ICON_B_PREV][0];
			icon_b_prev_over=resO[ID_ELEMENT_ICON_B_PREV][1];
			icon_b_prev_down=resO[ID_ELEMENT_ICON_B_PREV][2];
			//
			icon_b_add_page_w=resO[ID_ELEMENT_ICON_ADD_PAGE_W][2];
			icon_b_rect_w=resO[ID_ELEMENT_ICON_RECT_W][2];
			icon_b_ellipse_w=resO[ID_ELEMENT_ICON_ELLIPSE_W][2];
			icon_b_circle_w=resO[ID_ELEMENT_ICON_CIRCLE_W][2];
			icon_b_clean_page_w=resO[ID_ELEMENT_ICON_CLEAN_PAGE_W][2];
			icon_b_clean_w=resO[ID_ELEMENT_ICON_CLEAN_W][2];
			icon_b_color=resO[ID_ELEMENT_ICON_COLOR][2];
			icon_b_delete_all_w=resO[ID_ELEMENT_ICON_DELETE_ALL_W][2];
			icon_b_erase_w=resO[ID_ELEMENT_ICON_ERASE_W][2];
			icon_b_font=resO[ID_ELEMENT_ICON_FONT][2];
			icon_b_line_w=resO[ID_ELEMENT_ICON_LINE_W][2];
			icon_b_next_inact_w=resO[ID_ELEMENT_ICON_NEXT_INACT_W][2];
			icon_b_prev_inact_w=resO[ID_ELEMENT_ICON_PREV_INACT_W][2];
			icon_b_remove_page_w=resO[ID_ELEMENT_ICON_REMOVE_PAGE_W][2];
			icon_b_save_w=resO[ID_ELEMENT_ICON_SAVE_W][2];
			icon_b_text_w=resO[ID_ELEMENT_ICON_TEXT_W][2];
			icon_b_undo_w=resO[ID_ELEMENT_ICON_UNDO_W][2];
			icon_b_upload_w=resO[ID_ELEMENT_ICON_UPLOAD_W][2];
			icon_b_zoom_m_w=resO[ID_ELEMENT_ICON_ZOOM_M_W][2];
			icon_b_zoom_p_w=resO[ID_ELEMENT_ICON_ZOOM_P_W][0];	
			icon_b_settings=resO[ID_ELEMENT_ICON_B_SETTINGS][0];	
			
			icon_b_3stbutton=resO[ID_ELEMENT_ICON_LINE_W];	
			
			image_page_bg=resO[ID_ELEMENT_PAGE_BG][0];	
			//} END OF icons
			
			windowIconImage=resO[ID_ELEMENT_ICON_WINDOW];
			wnd_title=resS[ID_ELEMENT_TEXT_WINDOW_TITLE];
		}
		public function setResourceO(id:uint, a:Object):void {resO[id]=a;}
		public function setResourceS(id:uint, a:String):void {resS[id]=a;}
		/**
		 * [[up, over, down]]
		 */
		private var resO:Array=[];
		//} =*^_^*= END OF resources
		
		
		public static const NAME:String='VCWB';
		
	}
}


//{ ^_^ import
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import org.aswing.AssetIcon;
import org.aswing.JButton;
import flash.display.Sprite;
import flash.display.DisplayObject;
//} ^_^ END OF import
class ColorChooserButton extends JButton {
	function ColorChooserButton (id:String, listener:Function, text:String, icons:Array, fixH:Boolean=false, fixW:Boolean=false, textHint:String=null):void {
		b=new BitmapData(icons[0].width-6, icons[0].height-6, false);
		super('',new AssetIcon(createSprite(b, icons[0])));
		//setRollOverIcon(new AssetIcon(createSprite(b, icons[1])));
		//setPressedIcon(new AssetIcon(createSprite(b, icons[2])));
		
		name=id;
		addActionListener(listener);pack();
		if (fixH) {setMaximumHeight(getHeight());}
		if (fixW) {setMaximumWidth(getWidth());}
		if (textHint) {setToolTipText(textHint);}
		setOpaque(false);
		setBackgroundDecorator(null);
	}
	public function setColor(a:uint):void {
		b.floodFill(0,0,a);
	}
	
	private function createSprite(bd:BitmapData, a:DisplayObject):Sprite {
		var sp:Sprite=new Sprite;
		var b0:Bitmap=sp.addChild(new Bitmap(bd, PixelSnapping.ALWAYS));
		b0.x=3;b0.y=3;
		sp.addChild(a);
		return sp;
	}
	
	private var b:BitmapData;
}


//{ ^_^ import
import org.aswing.AssetIcon;
import org.aswing.JButton;
import flash.display.Sprite;
import flash.display.DisplayObject;
//} ^_^ END OF import
class SizeChooserButton extends JButton {
	function SizeChooserButton (id:String, listener:Function, text:String, icons:Array, fixH:Boolean=false, fixW:Boolean=false, textHint:String=null):void {
		
		var sp:Sprite;
		
		sp=new Sprite;b=createSprite(icons[0]);sp.addChild(icons[0]);sp.addChild(b);
		super('', new AssetIcon(sp));
		//sp=new Sprite;b0=createSprite(icons[1]);sp.addChild(icons[1]);sp.addChild(b0);
		//setRollOverIcon(new AssetIcon(sp));
		//sp=new Sprite;b1=createSprite(icons[2]);sp.addChild(icons[2]);sp.addChild(b1);
		//setPressedIcon(new AssetIcon(sp));
		
		name=id;
		addActionListener(listener);pack();
		if (fixH) {setMaximumHeight(getHeight());}
		if (fixW) {setMaximumWidth(getWidth());}
		if (textHint) {setToolTipText(textHint);}
		setOpaque(false);
		setBackgroundDecorator(null);
	}
	public override function setText(a:String):void {
		b.text=a;
		//b1.text=a;b0.text=a;
	}
	
	private function createSprite(a:DisplayObject):TextField {
		var b:TextField=new TextField;b.autoSize=TextFieldAutoSize.CENTER;b.x=9;b.y=2;
		return b;
	}
	
	private var b:TextField;
	private var b0:TextField;
	private var b1:TextField;
}

