package com.robot.core.info.skillEffectInfo
{
	public class Effect_32 extends AbstractEffectInfo
	{
		public function Effect_32()
		{
			super();
			_argsNum = 1;
		}

		override public function getInfo(array:Array = null) : String
		{
			return array[0] + "回合内，自身击中目标要害几率提升6.25%";
		}

	}
}