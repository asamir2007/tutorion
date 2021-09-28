package ttcc.v.wb {
	
	//{ =*^_^*= import
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.aswing.ASColor;
	import org.aswing.AssetIcon;
	import org.aswing.AssetPane;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
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
	import org.aswing.SoftBoxLayout;
	import org.aswing.event.ColorChooserEvent;
	import org.aswing.event.ResizedEvent;
	
	import ttcc.LOG;
	import ttcc.d.m.GUIWindowModel;
	import ttcc.n.loaders.Im;
	import ttcc.v.AVCWW;
	import ttcc.v.wb.c.item_control.WBToolButton;
	import ttcc.v.wb.v.*;
	//} =*^_^*= END OF import
	
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 21.08.2012 7:13
	 */
	public class VCWB extends AVCWW {
	//{
		static public const testSWF:String="http://tutorion.com/file_srv/files/imgs/a6572f31.txt.pdf1.swf";
		static public const testJPG:String="http://tutorion.com/file_srv/files/imgs/3771388b.jpg";
		static public var DATA_EXAMPLE:String=
'{'+
'    "pages":['+
'	{"url":"'+testSWF+'","txt":"page1","draw":'+
'	    ['+
'	    {"pointdata":[237,275,237,273,307,185,294,376,257,405,442,338,443,360,440,371,435,377,438,377,484,357,533,336,586,329,625,329,649,350,654,384,654,424,647,436,642,449,642,450],"npoints":20,"w":3,"x":237,"y":275,"c":0,"commands":[1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],"type":"line"}'+
'		]},'+
'	{"url":"'+testJPG+'","txt":"page1","draw":'+
'	    ['+
'	    {"text":"page 2","c":0,"type":"text","w":90,"x":258,"y":83},'+
'	    {"l":565,"type":"circle","w":3,"x":213,"y":156,"c":0,"h":469},'+
'	    {"pointdata":[672,164,672,166,672,171,672,176,672,183,665,202,655,227,638,260,615,301,598,329,576,364,549,402,526,436,512,455,469,507,454,528,440,547,428,561,422,570,415,577,411,579,410,580,408,580,406,582],"npoints":24,"w":3,"x":672,"y":164,"c":0,"commands":[1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],"type":"line"},'+
'	    {"pointdata":[359,214,381,214,400,214,432,221,475,242,649,357,684,379,714,398,746,424,775,450,793,469,805,483,812,492,815,495,817,497],"npoints":15,"w":3,"x":359,"y":214,"c":0,"commands":[1,2,2,2,2,2,2,2,2,2,2,2,2,2,2],"type":"line"}]},'+
'	    {"url":"","txt":"page1","draw":[{"pointdata":[136,145,136,149,136,161,136,171,136,185,136,201,136,216,136,228,136,241,136,253,136,265,136,272,136,289,136,301,136,303,136,312,136,313],"npoints":17,"w":3,"x":136,"y":145,"c":0,"commands":[1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],"type":"line"},'+
'	    {"pointdata":[124,143,122,138,126,138,127,138,146,138,159,142,174,149,186,157,198,169,206,182,211,195,213,204,215,213,215,218,149,261,142,261,136,261,131,256,129,253,129,249],"npoints":20,"w":3,"x":124,"y":143,"c":0,"commands":[1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],"type":"line"},'+
'	    {"pointdata":[297,291,297,287,297,273,297,263,297,239,297,225,297,211,297,201,297,197,297,194,299,194,306,201,314,220,331,263,354,325,363,351,368,371,374,391,374,393],"npoints":19,"w":3,"x":297,"y":291,"c":0,"commands":[1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],"type":"line"},'+
'	    {"pointdata":[277,325,279,324,282,324,285,324,292,324,299,324,306,324,319,324,324,324,334,324,343,324,353,324],"npoints":12,"w":3,"x":277,"y":325,"c":0,"commands":[1,2,2,2,2,2,2,2,2,2,2,2],"type":"line"},'+
'	    {"pointdata":[559,221,558,221,556,221,549,221,544,221,533,221,529,221,524,220,516,230,507,249,497,268,484,301,479,319,474,334,474,350,474,358,607,452,617,449,623,440,627,428,633,402,633,400,633,398,633,393,633,386,633,383,633,379,632,379,630,379,627,371],"npoints":30,"w":3,"x":559,"y":221,"c":0,"commands":[1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],"type":"line"},'+
'	    {"pointdata":[559,360,561,358,566,358,573,358,583,358,590,358,600,358,607,358,615,358,618,358,620,358,627,358,630,360,632,362,632,364,635,364,637,365,640,367,647,372,655,379],"npoints":20,"w":3,"x":559,"y":360,"c":0,"commands":[1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],"type":"line"},{"pointdata":[675,277,675,289,675,305,675,329,675,428,675,438,675,447,675,455,675,462,675,469,675,473,675,475,677,475],"npoints":13,"w":3,"x":675,"y":277,"c":0,"commands":[1,2,2,2,2,2,2,2,2,2,2,2,2],"type":"line"},'+
'	    {"pointdata":[679,258,681,256,684,256,696,256,704,256,716,256,728,256,729,256,729,258],"npoints":9,"w":3,"x":679,"y":258,"c":0,"commands":[1,2,2,2,2,2,2,2,2],"type":"line"},{"pointdata":[682,338,684,338,687,338,692,338,702,338,706,338,707,339,709,339],"npoints":8,"w":3,"x":682,"y":338,"c":0,"commands":[1,2,2,2,2,2,2,2],"type":"line"},{"pointdata":[677,464,684,464,687,464,691,464,696,464,704,464,714,464,738,464,743,464,744,464,748,464,755,464,756,464,758,464],"npoints":14,"w":3,"x":677,"y":464,"c":0,"commands":[1,2,2,2,2,2,2,2,2,2,2,2,2,2],"type":"line"}'+
'		]}'+
'	]'+
'}';		
	//}

	
	/*{pages:[{url:http://storage.samir.v2.tutorion.com/files/imgs/52905d25.png, draw:[], txt:page0}
,{url:http://storage.samir.v2.tutorion.com/files/imgs/cca8af18.png, draw:[], txt:page0}, {url:http://storage.samir.v2.tutorion.com/files/imgs/2311ecb9.png, draw:[], txt:page0}, {url:, draw:[], txt:page1}], last:{p:0, type:add_page, user:1641}, ready:1, sel:0}
	*/
		public var testMode:Boolean;
		
		
		//{ =*^_^*= CONSTRUCTOR	
		public function VCWB (testMode:Boolean):void {this.testMode=testMode;}
		
		public function construct(wndMinW:uint=400, wndMinH:uint=500, pagesAreaHeight:uint=150):void {
			this.wnd_minH=wndMinH;
			this.wnd_minW=wndMinW;
			this.pagesAreaHeight=pagesAreaHeight;
			
			configureVC();
			configureControll();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= user access
		
		/**
		 * очистить доску
		 */
		public function cleaWBCompletely():void {
			clearPages();
		}
		
		public function setSelPage(n:int):void {
			setCurrentPage_(n);
		}
		public function setCurrentTool(toolID:String):void {
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
		public function delDataItem(i:int):void{
			sendFmsCommand("DelWBItem", [currentPageSN, i]);
		}
		public function delDataItemS(pageSN:int, i:int):void{
			removeObject_(pageSN, i);
		}
		public function delPage(p:int):void{
			removePage_(p);
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
				bottomBlock.remove(panelPagesScrollPane);
				topBlock.remove(panelButtonsR);
				topBlock.remove(panelButtonsB);
				panelContent.mouseChildren=false;
				break;
			case ID_MODE_VIEW_FULL:
				bottomBlock.append(panelPagesScrollPane, BorderLayout.CENTER);
				topBlock.append(panelButtonsR, BorderLayout.EAST);
				topBlock.append(panelButtonsB, BorderLayout.SOUTH);
				break;
			}
		}
		
		//} =*^_^*= END OF user access
		
		
		//{ =*^_^*= view
		private function configureVC():void {
			// prepare frame
			vc=new CustomJFrame(null, wnd_title);
			vc.construct(NAME);
			registerGUIWindowModel(vc.getModel());
			vc.setIcon(new AssetIcon(windowIconImage,-1,-1,true));
			
			vc.getContentPane().setLayout(new BorderLayout(0,0));
			var titlebarH:uint=vc.getTitleBar().getSelf().getInsets().getMarginHeight();
			vc.setMinimumWidth(wnd_minW);
			vc.setMinimumHeight(wnd_minH+titlebarH);
			vc.setSizeWH(wnd_minW,wnd_minH+titlebarH);
			
			
			//Top
			topBlock = new JPanel(new BorderLayout());
			vc.getContentPane().append(topBlock, BorderLayout.CENTER);
			//buttons panel right
			panelButtonsR=new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 1, SoftBoxLayout.CENTER));
			topBlock.append(panelButtonsR, BorderLayout.EAST);
			prepareBPControls();
			//buttons panel bottom
			panelButtonsB=new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 1, SoftBoxLayout.CENTER));
			topBlock.append(panelButtonsB, BorderLayout.SOUTH);
			prepareBPTools();
			
			//content
			//panelContent=new AssetPane(null, AssetPane.SCALE_FIT_PANE);
			panelContent=new JPanel(new BorderLayout());
			//contentScrollPane = new JScrollPane(panelContent);
			topBlock.append(panelContent, BorderLayout.CENTER);
			//contentScrollPane.setMinimumSize(new IntDimension(300, 300));// TODO: move wb size from here
			//topBlock.append(contentScrollPane, BorderLayout.CENTER);
			
			//Bottom
			bottomBlock = new JPanel(new BorderLayout());
			vc.getContentPane().append(bottomBlock, BorderLayout.SOUTH);
			//pages
			panelPages = new JPanel(new GridLayout(2,0,1,1));
			//panelPages = new JPanel(new BoxLayout(BoxLayout.X_AXIS, 2));
			panelPagesScrollPane=new JScrollPane(panelPages, JScrollPane.SCROLLBAR_NEVER, JScrollPane.SCROLLBAR_AS_NEEDED);
			JViewport(panelPagesScrollPane.getViewport()).setVerticalAlignment(JViewport.TOP);
			JViewport(panelPagesScrollPane.getViewport()).setHorizontalAlignment(JViewport.LEFT);
			
			bottomBlock.append(panelPagesScrollPane, BorderLayout.CENTER);
			
			//регистрация скроллбара для реплейки(ссылка на скроллбар и затем указать ид(максимум 3 скроллбара на одну подель щас, разумеется доабвить еще можно))
			vc.regiterScrollBar(GUIWindowModel.ID_P_SSV_0, panelPagesScrollPane.getVerticalScrollBar());
			//colorChooser
			colorChooser = JColorChooser.createDialog(new JColorChooser(), vc.getContentPane(), "pick a color", false
				,function (e:ASColor):void {set_currentColor(e.getARGB());} 
				,function():void {LOG(0, 'cancel presed');}
			);
			
			//line width
			selectSize = new JFrame(null, "select line width/text size");
			var p:JPanel = new JPanel();
			var adjuster1:JAdjuster = new JAdjuster(4, JAdjuster.VERTICAL);
			adjuster1.setName("adjuster1");
			//adjuster1.setValues(1250, 0, 1250, 1350);
			adjuster1.setMaximum(40);
			adjuster1.setMinimum(1);
			adjuster1.setValue(1);
			//adjuster1.setValueTranslator(function(value:int):String {return Math.round(value) + "%";});
			p.append(adjuster1);
			selectSize.getContentPane().append(p, BorderLayout.CENTER);
			var __handler:Function=function (e:Event):void{
				var ad:JAdjuster = e.target;
				//LOG(0,ad.getName() + " " + e.type + " handled : " + ad.getValue());
				if (e.type==InteractiveEvent.STATE_CHANGED) {set_currentThickness(ad.getValue());}
			}
			adjuster1.addActionListener(__handler);
			adjuster1.addStateListener(__handler);
			selectSize.pack();
			//selectSize.setSizeWH(100, 250);
			
			//{ =*^_^*= test
			//var bToggleMode:JButton=createButton('testToggleMode', el_b, 'full mode/replay mode',null);
			//vc.getTitleBar().addExtraControl(bToggleMode, 50);
			//} =*^_^*= END OF test
			
			//c
			vc.show();
		}
		
		//{ =*^_^*= buttons panels
		private function prepareBPTools():void {
			var b:JButton;
			b=createButton(S_ID_B_COLOR_OPEN, el_b, '', icon_b_color, true, true, 'color');
			panelButtonsB.append(b);
			
			b=createButton(S_ID_B_SIZE_OPEN, el_b, '', icon_b_font, true, true, 'size');
			panelButtonsB.append(b);
			
			panelButtonsB.append(new JSeparator(JSeparator.VERTICAL));
			
			b=createButton(S_ID_B_TOOL_DRAW, el_b, '', icon_b_draw_up, true, true, 'free-hand drawing');
			panelButtonsB.append(b);
			
			b=createButton(S_ID_B_TOOL_LINE, el_b, '', icon_b_line_w, true, true, 'line');
			panelButtonsB.append(b);

			b=createButton(S_ID_B_TOOL_CIRC, el_b, '', icon_b_circle_w, true, true, 'circle');
			panelButtonsB.append(b);

			b=createButton(S_ID_B_TOOL_RECT, el_b, '', icon_b_rect_w, true, true, 'rect');
			panelButtonsB.append(b);

			b=createButton(S_ID_B_TOOL_ELLIPSE, el_b, '', icon_b_ellipse_w, true, true, 'ellipse');
			panelButtonsB.append(b);

			b=createButton(S_ID_B_TOOL_TEXT, el_b, '', this.icon_b_text_w, true, true, 'text');
			panelButtonsB.append(b);
			
			panelButtonsB.append(new JSeparator(JSeparator.VERTICAL));
			
			b=createButton(S_ID_B_TOOL_ERASE, el_b, '', this.icon_b_erase_w, true, true, 'erase');
			panelButtonsB.append(b);
			
			b=createButton(S_ID_B_TOOL_ZOOM, el_b, '', this.icon_b_zoom_p_w, true, true, 'zoom');
			panelButtonsB.append(b);
			
			b=createButton(S_ID_B_UNDO, el_b, '', this.icon_b_undo_w, true, true, 'undo');
			panelButtonsB.append(b);
			// TODO: translate labels
		}
		private function prepareBPControls():void {
			panelButtonsR.append(createButton(S_ID_B_DEL_PAGE, el_b, '', icon_b_remove_page_w, true, true, ''));
			panelButtonsR.append(createButton(S_ID_B_ADD_PAGE, el_b, '', icon_b_add_page_w, true, true, ''));
			panelButtonsR.append(new JSeparator(JSeparator.HORIZONTAL));
			panelButtonsR.append(createButton(S_ID_B_PREV_PAGE, el_b, '', icon_b_prev_up, true, true, ''));
			panelButtonsR.append(new JSeparator(JSeparator.HORIZONTAL));
			panelButtonsR.append(createButton(S_ID_B_NEXT_PAGE, el_b, '', icon_b_next_up, true, true, ''));	
			panelButtonsR.append(new JSeparator(JSeparator.HORIZONTAL));
			panelButtonsR.append(createButton(S_ID_B_LOAD, el_b, '', this.icon_b_upload_w, true, true, 'load'));	
			panelButtonsR.append(createButton(S_ID_B_SAVE, el_b, '', this.icon_b_save_w, true, true, 'save'));	
			panelButtonsR.append(createButton(S_ID_B_REMOVE_ALL_PAGES, el_b, '', this.icon_b_delete_all_w, true, true, ''));	
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
		
		private var panelButtonsR:JPanel;
		private var panelButtonsB:JPanel;
		private var panelContent:JPanel;
		private var contentScrollPane:JScrollPane;
		private var panelPages:JPanel;
		private var panelPagesScrollPane:JScrollPane;
		//} =*^_^*= END OF buttons panels
				
		public function get_displayObject():DisplayObject {return container;}		
		private var container:Sprite=new Sprite;
		private var topBlock:JPanel;
		private var bottomBlock:JPanel;
		private var pagesPane:JPanel;
		private var colorChooser:JFrame;
		private var selectSize:JFrame;
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= controll
		private function configureControll():void {
			panelContent.addEventListener(ResizedEvent.RESIZED, el_panelContent_resized);
			prepare_resizeT();
			//test();
			//contentScrollPane.addEventListener(ResizedEvent.RESIZED, el_panelContent_resized);
		}
		
		private function test():void {
			var p:WhiteboardMainPage;
			var miniPage:WhiteboardListElement;
			
			for (var i:int = 0; i < 10;i++) {
				p=new WhiteboardMainPage(this);
				p.set_id(i);
				pages[i]=p;
				miniPage=new WhiteboardListElement(p, 50,50,el_minipage, p.get_pageName());
				addMiniPage(p.get_id(), miniPage);
				p.set_miniPage(miniPage);
			}
			
			setSelPage(0);
			//var s:Sprite=new Sprite()
			//s.graphics.beginFill(0x00ffff);
			//s.graphics.drawRect(0,0,244,44)
			//panelContent.addChild(s);
		}
		
		private function el_b(e:Event):void {
			switch (e.target.name) {
			
			/*case S_ID_B_DEBUG_CHANGE_MODE:
				listener(this, ID_E_B_DEBUG_CHANGE_MODE, null);
				break;
			*/
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
				if (pages.length<2) {break;}
				sendFmsCommand("DelPg2WB", [currentPageSN]);
				break;
			case S_ID_B_COLOR_OPEN:
				colorChooser.show();
				colorChooser.setLocation(vc.getLocation());
				break;
			case S_ID_B_SIZE_OPEN:
				selectSize.show();
				selectSize.setLocation(vc.getLocation());
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
			case S_ID_B_TOOL_ZOOM:
				//zoomMode=!zoomMode;
				var zoom:uint=currentPage.getZoom();
				zoom+=30;
				if (zoom>220) {zoom=100;}
				currentPage.setZoom(zoom);
				break;
				
			case S_ID_B_TOOL_DRAW:
			case S_ID_B_TOOL_LINE:
			case S_ID_B_TOOL_ELLIPSE:
			case S_ID_B_TOOL_RECT:
			case S_ID_B_TOOL_CIRC:
			case S_ID_B_TOOL_TEXT:
			case S_ID_B_TOOL_ERASE:
				setCurrentTool(e.target.name);
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
				//vc.setSizeWH(resizeToW+2, resizeToH+2);
				//e.target.stop();
				vc.repaintAndRevalidate()
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
			
			// TODO: if selection>numpages, fix
			// TODO: set selected page
			//setCurrentPage_();
		}
		public function addPage(position:int, rawData:Object):void {
			if (rawData is Array) {rawData=[rawData[0]];}
			LOG(0,'[:]=== addPage_>'+rawData[0].txt, 0);
			
			if (rawData[0]==null) {return;}
			
			// TODO: simply add to array
			var p:WhiteboardMainPage=new WhiteboardMainPage(this, 800, 600);
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
		private function sendSelectPage():void {
			LOG(0,'sendSelectPage>'+currentPageSN);
			listener(this, ID_E_SELECT_PAGE, {page:currentPageSN});
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
			//if (currentPage) {currentPage.set_currentThickness(a);}
		}
		private function set_currentColor(a:uint):void {
			currentColor = a;
			//if (currentPage) {currentPage.set_currentColor(a);}
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
		
		//} =*^_^*= =*^_^*= END OF res
		
		//{ =*^_^*= data
		private var wnd_minH:uint;
		private var wnd_minW:uint;
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
		 * data:{cmdName:String, param:Array}
		 */
		public static const ID_E_SEND_DATA:String='ID_E_SEND_DATA';
		/**
		 * data:{page:int}
		 */
		public static const ID_E_SELECT_PAGE:String='ID_E_SELECT_PAGE';
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
			icon_b_zoom_p_w=resO[ID_ELEMENT_ICON_ZOOM_P_W][2];	
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