// Project MainPanelComponent
package ttcc.v.mp {
	
	//{ =*^_^*= import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import org.aswing.ASColor;
	import org.aswing.ASFont;
	import org.aswing.GridLayout;
	import org.aswing.JPanel;
	import org.jinanoimateydragoncat.display.utils.Utils;
	import ttcc.Application;
	import ttcc.cfg.AppCfg;
	import ttcc.d.a.DUUD;
	import ttcc.d.m.MPUsersListComModel;
	import ttcc.LOG;
	import ttcc.n.loaders.Im;
	import ttcc.v.mp.VCMainPanelIPanelElement;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 25.08.2012 11:07
	 */
	public class VCMainPanelUsersListElement extends VCMainPanelBasePanelElement implements VCMainPanelIPanelElement {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * use construct method
		 */
		function VCMainPanelUsersListElement () {
		}
		/**
		 * @param	el function(target:VCMainPanelUsersListElement, type:uint, data:Object):void {
		 */
		public function construct(el:Function):void {
			this.el=el;
			prepareView();
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= user interface
		public function prepareModel(a:Application):void {
			M=new MPUsersListComModel(a);
			M.construct(NAME+'ComModel');
			M.setViewUpdatesListener(el_M);
		}
		
		public function userLoggedIn(u:DUUD):void {
			processUser(u, false);
		}
		public function userLoggedOut(u:DUUD):void {
			processUser(u, true);
		}
		public function userPropertyUpdatedChatTyping(u:DUUD):void {
			M.set_usersPropertiesHandChatStream(u);
		}
		public function userPropertyUpdatedHandUp(u:DUUD):void {
			M.set_usersPropertiesHandChatStream(u);
		}
		public function userPropertyUpdatedStreamName(u:DUUD):void {
			M.set_usersPropertiesHandChatStream(u);
		}
		
		//} =*^_^*= END OF user interface
		
		
		//{ =*^_^*= view
		private function prepareView():void {
			com=new JPanel(new GridLayout(1));
			
			//{ =*^_^*= test
			
			/*setResources(
				TestBitmapClass0
				,TestBitmapClass0a
				,TestBitmapClass1
				,TestBitmapClass1a
				,TestBitmapClass2
				,TestBitmapClass2a
				,AppCfg.MAIN_PANEL_CL_CONTACT_AVATAR_W
				,AppCfg.MAIN_PANEL_CL_CONTACT_AVATAR_H
				,AppCfg.MAIN_PANEL_CL_CONTACT_STATE_ICON_W
				,AppCfg.MAIN_PANEL_CL_CONTACT_STATE_ICON_H
			);*/
			//} =*^_^*= END OF test
		}
		
		private function redraw():void {
			com.pack();com.revalidate();
		}
		
		private function ui_removeElementFromList(u:MPDUUser):void {
			var lp:JPanel=com;
			lp.remove(u.get_vc());
			redraw();
		}
		
		private function ui_redrawUserList():void {
			var lp:JPanel=com;
			
			// TODO: sort list
			
			//clear display
			lp.removeAll();
			// reflect
			for each(var i:MPDUUser in mpduUserList) {
				i.projectDU();
				lp.append(i.get_vc());
			}
			
			redraw();
			
		}
		
		private function createElement(du:DUUD):VCMainPanelUsersListElementElement {
			var listElement:VCMainPanelUsersListElementElement=new VCMainPanelUsersListElementElement(
				du.get_id()
				,createAvatarSmallPicture(du.get_avatarPictureSmall(),avatarW,avatarH)
				,iconH*3,iconW*3
			);
			
			listElement.setEventListener(el_listElement);
			
			listElement.addIcon(MPDUUser.ID_ICON_USER_PROPERTY_STREAM, new Bitmap(iconStreamOn), new Bitmap(iconStreamOff), iconW, iconH);
			listElement.addIcon(MPDUUser.ID_ICON_USER_PROPERTY_CHAT_TYPING, new Bitmap(iconChatTypingOn), new Bitmap(iconChatTypingOff), iconW, iconH);
			listElement.addIcon(MPDUUser.ID_ICON_USER_PROPERTY_HAND, new Bitmap(iconHandUpOn), new Bitmap(iconHandUpOff), iconW, iconH);
			return listElement;
		}
		
		private function el_listElement(userID:String, do_:DisplayObject):void {
			el(this, ID_E_ELEMENT_SELECTED, {targetDO:do_, targetDU:getDUUDById(usersList, userID)});
		}
		
		private function createAvatarSmallPicture(a:String, w:uint, h:uint):DisplayObject {
			var s:Sprite=new Sprite;
			s.graphics.beginFill(0,0);s.graphics.drawRect(0, 0, w, h);
			s.addChild(new Im(a,null,null,function (a:Im):void {
				Utils.resizeDO(a, w, h);
				Utils.centerDO(a, new Rectangle(0,0,w,h));
			}));
			
			
			return s;
		}
		
		//{ ^_^ test
		private function createSprite(w:uint, h:uint, c:uint, b:uint):Sprite {
			var av:Sprite=new Sprite;
			av.graphics.beginFill(c);
			av.graphics.lineStyle(.5, b);
			av.graphics.drawRect(0,0,w,h);
			return av;
		}
		private function createBitmap(w:uint, h:uint, c:uint):Bitmap {
			return new Bitmap(new BitmapData(w,h,false,c));
		}
		//} ^_^ END OF test
		
		private function v():JPanel {return com;}
		
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= control
		private function processUser(u:DUUD, loggedOut:Boolean=false):void {
			//LOG(0, 'processUser>>',1);
			//determine whether user is in list
			var index:int=-1;
			for each(var i:MPDUUser in mpduUserList) {if (i.get_userID()==u.get_id()) {index=mpduUserList.indexOf(i);break;}}
			//LOG(0, 'user index:'+index,1);
			
			var newList:Array;
			
			if (!loggedOut) {
				//if has -
				if (index==-1) {// add if not found in list
					// add to model
					//LOG(0,'add to model',0);
					newList=M.get_usersList().slice();
					newList.push(u);
					M.set_usersList(newList);
					//addUserToList(u);//- old way before new model format
				}//else {return;}//already in list, do nothing
			} else if (index!=-1) {//if has not - remove if found
				// remove from model
				//LOG(0,'remove from model',0);
				newList=M.get_usersList().slice();
				newList.splice(newList.indexOf(getDUUDById(newList, i.get_userID())), 1);
				M.set_usersList(newList);	
				//removeUserFromList(i); //- old way before new model format
				//else {return;}//not found in list, do nothing
			}
			
		}
		
		private function removeUserFromList(u:MPDUUser):void {
			usersList.splice(usersList.indexOf(getDUUDById(usersList, u.get_userID())), 1);
			// remove from list
			mpduUserList.splice(mpduUserList.indexOf(u), 1);
			// ui remove from list only
			ui_removeElementFromList(u);
			el(this, ID_E_REDRAW_MP, null);
			// free memory used by and disconnect from interface
			u.destruct();
		}
		
		private function getUserByID(id:String):MPDUUser {
			for each(var i:MPDUUser in mpduUserList) {if (i.get_userID()==id) {return i;}}return null;
		}
		
		private function addUserToList(u:DUUD):void {
			usersList.push(u);
			var avu:MPDUUser=new MPDUUser(u, createElement(u));
			mpduUserList.push(avu);
			// deal with GUI
			// sort and display list
			ui_redrawUserList();
			el(this, ID_E_REDRAW_MP, null);
		}
		
		/**
		 * @param	a [DUUD]
		 */
		private function setUsers(a:Array):void {
			var missingUsers:Array=getDifference(a, usersList);
			var newUsers:Array=getDifference(usersList, a);
			//LOG(0,'setUsers:',1);
			
			
			// add
			if (newUsers.length>0) {
				//LOG(0,'new users:'+newUsers,1);
				for each(var i:DUUD in newUsers) {
					if (!getUserByID(i.get_id())) {addUserToList(i);}
				}
			}
			// remove
			var avu:MPDUUser;
			if (missingUsers.length>0) {
				//LOG(0,'missingUsers:'+missingUsers,1);
				for each(var iu:DUUD in missingUsers) {
					avu=getUserByID(iu.get_id());
					if (avu) {removeUserFromList(avu);}
				}
			}
			//get fresh data from model
			for each(iu in a) {
				avu=getUserByID(iu.get_id());
				if (avu) {avu.refreshDU(iu);}
			}
			//reflect 
			ui_redrawUserList();
			
		}
		
		/**
		 * find elements that are present only in b list
		 */
		private function getDifference(a:Array, b:Array):Array {
			var r:Array=[];
			for each(var i:DUUD in b) {if (getDUUDById(a, i.get_id())==null) {r.push(i);}}return r;
		}
		private function getDUUDById(list:Array, id:String):DUUD {
			// TODO: LOW; OPTIMIZATION; use hashmap
			for each(var i:DUUD in list) {if (i.get_id()==id) {return i;}}return null;
		}
		
		
		private var usersList:Array=[];
		private var mpduUserList:Array=[];
		//} =*^_^*= END OF control
		
		
		//{ =*^_^*= model
		private function el_M(targetModel:MPUsersListComModel, elementID:uint, updateFromDataport:Boolean=false):void {
			switch (elementID) {
				
				case MPUsersListComModel.ID_P_USERS:
				setUsers(M.get_usersList());
				break;
			
				case MPUsersListComModel.ID_P_USER_PROPERTIES_UPDATE:
				//LOG(0,'MPUsersListComModel.ID_P_UPDATE_USER_PROPERTIES',2);
				ui_redrawUserList();
				break;
			
			}
			
		}
		
		public function get_model():MPUsersListComModel {return M;}
		private var M:MPUsersListComModel;
		//} =*^_^*= END OF model
		
		
		//{ =*^_^*= res
		public function setResources(iconChatTypingOn:Class, iconChatTypingOff:Class, iconStreamOn:Class, iconStreamOff:Class, iconHandUpOn:Class, iconHandUpOff:Class, avatarW:uint, avatarH:uint, iconW:uint, iconH:uint):void {
			this.iconChatTypingOn=Bitmap(new iconChatTypingOn).bitmapData;
			this.iconChatTypingOff=Bitmap(new iconChatTypingOff).bitmapData;
			this.iconStreamOn=Bitmap(new iconStreamOn).bitmapData;
			this.iconStreamOff=Bitmap(new iconStreamOff).bitmapData;
			this.iconHandUpOn=Bitmap(new iconHandUpOn).bitmapData;
			this.iconHandUpOff=Bitmap(new iconHandUpOff).bitmapData;
			this.avatarW=avatarW;
			this.avatarH=avatarH;
			this.iconW=iconW;
			this.iconH=iconH;
		}
		
		private var iconChatTypingOn:BitmapData;
		private var iconChatTypingOff:BitmapData;
		private var iconStreamOn:BitmapData;
		private var iconStreamOff:BitmapData;
		private var iconHandUpOn:BitmapData;
		private var iconHandUpOff:BitmapData;
		
		private var avatarW:uint;
		private var avatarH:uint;
		private var iconW:uint;
		private var iconH:uint;
		//} =*^_^*= END OF res
		
		//{ =*^_^*= =*^_^*= events
		/**
		 * {targetDO:DisplayObject, targetDU:DUUD}
		 */
		public static const ID_E_ELEMENT_SELECTED:uint=0;
		public static const ID_E_REDRAW_MP:uint=1;
		//} =*^_^*= =*^_^*= END OF events
		
		public static const NAME:String='VCMainPanelUsersListElement';
		
	}
}


//{ =*^_^*= import
import flash.display.Bitmap;
import flash.display.BitmapData;
import org.aswing.JPanel;
import ttcc.d.a.DUUD;
import ttcc.v.mp.VCMainPanelUsersListElementElement;
//} =*^_^*= END OF import

class MPDUUser {
	function MPDUUser (du:DUUD, vc:VCMainPanelUsersListElementElement):void {
		this.du=du;
		this.vc=vc;
		projectDU();
	}
	public function destruct():void {
		// TODO: FOR PERFORMANCE OPTIMIZATION
	}
	
	
	public function projectDU():void {
		vc.setIconFrame(ID_ICON_USER_PROPERTY_CHAT_TYPING, uint(du.get_chatIsTyping()));
		vc.setIconFrame(ID_ICON_USER_PROPERTY_HAND, uint(du.get_handIsUp()));
		vc.setIconFrame(ID_ICON_USER_PROPERTY_STREAM, uint(!(du.get_streamName()==null||du.get_streamName().length==0)));
	}
	
	public function get_userID():String {return du.get_id();}
	
	
	public function get_vc():JPanel {return vc.get_vc();}
	public function refreshDU(a:DUUD):void {du = a;}

	private var du:DUUD;
	private var vc:VCMainPanelUsersListElementElement;
	
	
	public static const ID_ICON_USER_PROPERTY_STREAM:uint=0;
	public static const ID_ICON_USER_PROPERTY_CHAT_TYPING:uint=1;
	public static const ID_ICON_USER_PROPERTY_HAND:uint=2;

}

//{ ^_^ test
class TestBitmapClass0 extends Bitmap {function TestBitmapClass0 ():void {super(new BitmapData(15,15,false,0x00ff00));}}
class TestBitmapClass0a extends Bitmap {function TestBitmapClass0a ():void {super(new BitmapData(15,15,false,0x00cc00));}}
class TestBitmapClass1 extends Bitmap {function TestBitmapClass1 ():void {super(new BitmapData(15,15,false,0xff0000));}}
class TestBitmapClass1a extends Bitmap {function TestBitmapClass1a ():void {super(new BitmapData(15,15,false,0xcc000));}}
class TestBitmapClass2 extends Bitmap {function TestBitmapClass2 ():void {super(new BitmapData(15,15,false,0x0000ff));}}
class TestBitmapClass2a extends Bitmap {function TestBitmapClass2a ():void {super(new BitmapData(15,15,false,0x0000cc));}}
//} ^_^ END OF test

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]