package org.jinanoimateydragoncat.works.cyber_modules.v {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 04.02.2012 20:37
	 */
	public class VCCustomListItemsScroller {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function VCCustomListItemsScroller (container:DisplayObject, bNext:DisplayObject, bPrev:DisplayObject, listElementNamePrefix:String='i') {
			this.listElementNamePrefix = listElementNamePrefix;
			this.sprite = container;
			this.bNext = bNext;
			this.bPrev = bPrev;
			prepareSprites();
			prepareData();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =^_^= =^_^= physical
		
		/**
		 * скрытие списка товаров и кнопок прокрутки
		 */
		public function clearItemsList():void {
			bNext_set_visible(false);
			bPrev_set_visible(false);
			for each(var i:DisplayObject in itemSpritesList) {i.visible = false;}
		}
		
		private function prepareSprites():void {
			if (bNext) {Helpers.configureSpriteAsButton(bNext, el_bNextOnPress);}
			if (bPrev) {Helpers.configureSpriteAsButton(bPrev, el_bPrevOnPress);}
			
			var i:int = 0;
			var sprite_:DisplayObject;
			while (true) {
				sprite_ = sprite.getChildByName(listElementNamePrefix+ i);
				if (!sprite_) {break;}
				itemSpritesList.push(sprite_);
				i+= 1;
			}
			pageSize = i;
		}
		
		
		private function bNext_set_visible(a:Boolean):void {if (bNext) {bNext.visible = a;}}
		private function bPrev_set_visible(a:Boolean):void {if (bPrev) {bPrev.visible = a;}}
		
		private var listElementNamePrefix:String
		private var sprite:DisplayObjectContainer;
		
		private var itemSpritesList:Vector.<DisplayObject> =  new Vector.<DisplayObject>();
		
		private var bNext:DisplayObject;
		private var bPrev:DisplayObject;
		//} =^_^= =^_^= END OF physical
		
		
		//{ =^_^= =^_^= data
		public function redrawCurrentPage():void {
			var t:uint = 0;
			var itemsCount:uint = itemsData.length;
			var item:ICustomListItem;
			
			for (var i:uint = currentPage*pageSize; i < currentPage*pageSize+ pageSize; i++ ) {
				item = items[t];
				if (i<itemsCount) {
					item.set_visible(true);
				} else {
					item.set_visible(false);
				}
				t+=1;
			}
		}
		
		/**
		 * @param	a function (item:ICustomListItem):void;
		 */
		public function set_el_ItemOnActivateRef (a:Function):void {el_ItemActivateRef = a;}
		
		protected function el_ItemOnActivate(item:ICustomListItem):void {el_ItemActivateRef(item);}
		
		private function prepareData():void {
			//prepare items
			var item:ICustomListItem;
			var sp:DisplayObject;
			for (var i:uint in itemSpritesList) {
				sp = itemSpritesList[i];
				item = get_ICustomListItem_instance(sp, el_ItemOnActivate);
				items.push(item);
			}
			clearItemsList();
		}
		
		/**
		* function (item:ICustomListItem):void;
		* @param	target controlled DisplayObject
		* @param	onActivate function (item:ICustomListItem):void;
		* @return
		*/
		protected function get_ICustomListItem_instance(target:DisplayObject, onActivate:Function):ICustomListItem {
			// override and place your code here
			throw new ArgumentError('override and place your code here');
		}
		
		
		//{ =^_^= =^_^= Buttons Next and Previous
		
		/**
		 * button Next pressed
		 */
		private function el_bNextOnPress(e:Object):void {
			nextPage();
		}
		/**
		 * button Previous pressed
		 */
		private function el_bPrevOnPress(e:Object):void {
			prevPage();
		}
		
		//} =^_^= =^_^= END OF Buttons next and previous
		
		
		public function nextPage():void {
			if ((currentPage+1)*pageSize < itemsData.length) {
				currentPage += 1;
				bPrev_set_visible(true);
			}
			if ((currentPage+1)*pageSize >= itemsData.length) {
				bNext_set_visible(false);
			}
			displayCurrentPage();
		}
		
		public function prevPage():void {
			if (currentPage < 1) {return;}
			currentPage -= 1;
			bNext_set_visible(itemsData.length > pageSize);
			if (currentPage < 1) {bPrev_set_visible(false);}
			displayCurrentPage();
		}
		
		private function setElementsData():void {
			currentPage = 0;
			bNext_set_visible(itemsData.length > pageSize);
			bPrev_set_visible(false);
			
			displayCurrentPage();
		}
		 
		private function displayCurrentPage():void {
			var t:uint = 0;
			var itemData:Object;
			var itemsCount:uint = itemsData.length;
			var item:ICustomListItem;
			
			for (var i:uint = currentPage*pageSize; i < currentPage*pageSize+ pageSize; i++ ) {
				item = items[t];
				if (i<itemsCount) {
					itemData = itemsData[i];
					fillElementWithData(itemData, item);
				} else {
					item.set_visible(false);
				}
				t+=1;
			}
			
			
		}
		
		/**
		 * default, override if needed
		 */
		protected function fillElementWithData(itemData:Object, item:ICustomListItem):void {
			item.set_data(itemData);
			item.set_visible(true);
		}
		
		
		private var el_ItemActivateRef:Function;
		
		private var currentCategoryId:uint;
		
		public function get_itemsData():Vector.<Object> { return itemsData; }
		/**
		 * get the copy (! not ref)
		 * @author [Object]
		 */
		public function set_itemsData(a:Array):void {
			itemsData = a.slice();
			setElementsData();
		}
		private var itemsData:Array;
		
		private var pageSize:uint;
		private var currentPage:uint;
		
		private var items:Vector.<ICustomListItem> = new Vector.<ICustomListItem>();
		//} =^_^= =^_^= END OF data
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]