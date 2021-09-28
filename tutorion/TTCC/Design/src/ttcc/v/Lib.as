// Project TTCC
package ttcc.v {
	
	//{ =*^_^*= import
	import org.aswing.AssetIcon;
	import org.aswing.JButton;
	import org.aswing.JToggleButton;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 28.09.2012 22:28
	 */
	public class Lib {
		
		public static function modifyIconifiedButton(target:JButton, icons:Array):void {
			target.setIcon(new AssetIcon(icons[0]));
			target.setRollOverIcon(new AssetIcon(icons[1]));
			target.setPressedIcon(new AssetIcon(icons[2]));
		}
		
		public static function createIconifiedToggleButton(id:String, listener:Function, text:String, icons:Array, fixH:Boolean=false, fixW:Boolean=false, textHint:String=null):JButton {
			var sb:JButton=createIconifiedButton(id, listener, text,icons,fixH,fixW,textHint);
			sb.setSelectedIcon(new AssetIcon(icons[2]));
			sb.setRollOverSelectedIcon(new AssetIcon(icons[2]));
			return sb;
		}
		
		public static function createIconifiedButton(id:String, listener:Function, text:String, icons:Array, fixH:Boolean=false, fixW:Boolean=false, textHint:String=null):JButton {
			var sb:JButton=new JButton(text, new AssetIcon(icons[0]));
			sb.setRollOverIcon(new AssetIcon(icons[1]));
			sb.setPressedIcon(new AssetIcon(icons[2]));
			
			sb.name=id;
			sb.addActionListener(listener);sb.pack();
			if (fixH) {sb.setMaximumHeight(sb.getHeight());}
			if (fixW) {sb.setMaximumWidth(sb.getWidth());}
			if (textHint) {sb.setToolTipText(textHint);}
			sb.setOpaque(false);
			sb.setBackgroundDecorator(null);
			
			return sb;
		}
		
		public static function createSimpleButton(id:String, listener:Function, text:String, fixH:Boolean=false, fixW:Boolean=false, textHint:String=null):JButton {
			var sb:JButton=new JButton(text);
			sb.name=id;sb.addActionListener(listener);sb.pack();
			if (fixH) {sb.setMaximumHeight(sb.getHeight());}if (fixW) {sb.setMaximumWidth(sb.getWidth());}
			if (textHint) {sb.setToolTipText(textHint);}
			return sb;
		}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]