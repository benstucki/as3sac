package com.benstucki.css.sac
{
	import org.w3c.css.sac.ISelector;
	import org.w3c.css.sac.ISelectorList;

	public class SelectorList implements ISelectorList
	{
		private var list:Array = new Array();
		
		public function get length():uint {
			return list.length;
		}
		
		public function item(index:uint):ISelector {
			return ISelector(list[index]);
		}
		
		public function addItem( value:ISelector ):void {
			list.push( value );
		}
		
	}
}