package com.robot.core.info.skillEffectInfo
{
	public class Effect_13 extends AbstractEffectInfo
	{
		public function Effect_13()
		{
			super();
			_argsNum = 1;
		}

		override public function getInfo(array:Array = null) : String
		{
			return array[0] + "回合吸取对方[最大体力]的1/8(对草系精灵无效)";
		}

	}
}