package com.benstucki.css.sac
{
	import org.w3c.css.sac.IPositionalCondition;
	import org.w3c.css.sac.ConditionTypes;

	public class PositionalCondition implements IPositionalCondition
	{
		private var _position:int = 0;
		private var _typeNode:Boolean = false;
		private var _type:Boolean = false;
		private var _grouping:int = 0;
		
		public function PositionalCondition(position:int, typeNode:Boolean, type:Boolean, grouping:int=0):void {
			_position = position;
			_typeNode = typeNode;
			_type = type;
			_grouping = grouping;
		}
		
		public function get typeNode():Boolean { return _typeNode; }
		
		public function get position():int { return _position; }
		
		public function get type():Boolean { return _type; }
		
		public function get grouping():int { return _grouping; }
		
		public function get conditionType():uint {
			return ConditionTypes.SAC_POSITIONAL_CONDITION;
		}
		
	}
}