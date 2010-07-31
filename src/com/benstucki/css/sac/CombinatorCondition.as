package com.benstucki.css.sac
{
	import org.w3c.css.sac.ICombinatorCondition;
	import org.w3c.css.sac.ICondition;
	import org.w3c.css.sac.ConditionTypes;

	public class CombinatorCondition implements ICombinatorCondition
	{
		private var _first:ICondition;
		private var _second:ICondition;
		private var _type:uint = ConditionTypes.SAC_AND_CONDITION;

		public function CombinatorCondition( first:ICondition, second:ICondition, type:uint ) {
			_first = first;
			_second = second;
			_type = type;
		}

		public function get firstCondition():ICondition { return _first; }
		public function get secondCondition():ICondition { return _second; }
		public function get conditionType():uint { return _type; }
	}
}