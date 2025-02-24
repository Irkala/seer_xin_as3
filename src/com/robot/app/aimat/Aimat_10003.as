package com.robot.app.aimat
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.IAimatSprite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class Aimat_10003 extends BaseAimat
   {
      private var ui:MovieClip;
      
      private var ui2:MovieClip;
      
      public function Aimat_10003()
      {
         super();
      }
      
      override public function execute(info:AimatInfo) : void
      {
         super.execute(info);
         this.ui = AimatController.getResEffect(_info.id);
         this.ui.x = _info.startPos.x;
         this.ui.y = _info.startPos.y;
         this.ui.mouseEnabled = false;
         this.ui.mouseChildren = false;
         MapManager.currentMap.root.addChild(this.ui);
         this.ui.addFrameScript(this.ui.totalFrames - 1,this.onEnd);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(Boolean(this.ui))
         {
            this.ui.addFrameScript(this.ui.totalFrames - 1,null);
            DisplayUtil.removeForParent(this.ui);
            this.ui = null;
         }
         if(Boolean(this.ui2))
         {
            this.ui2.addFrameScript(10,null);
            this.onEnd3();
         }
      }
      
      private function onEnd() : void
      {
         this.ui.addFrameScript(this.ui.totalFrames - 1,null);
         AimatController.dispatchEvent(AimatEvent.PLAY_END,_info);
         DisplayUtil.removeForParent(this.ui);
         this.ui = null;
         this.ui2 = AimatController.getResEffect(_info.id,"02");
         this.ui2.x = _info.endPos.x;
         this.ui2.y = _info.endPos.y;
         this.ui2.mouseEnabled = false;
         this.ui2.mouseChildren = false;
         MapManager.currentMap.root.addChild(this.ui2);
         this.ui2.addFrameScript(10,this.onEnd2);
         this.ui2.addFrameScript(this.ui2.totalFrames - 1,this.onEnd3);
      }
      
      private function onEnd2() : void
      {
         var obj:DisplayObject = null;
         this.ui2.addFrameScript(10,null);
         var list:Array = MapManager.getObjectsPointRect(_info.endPos,30,[IAimatSprite]);
         for each(obj in list)
         {
            if(obj is IAimatSprite)
            {
               IAimatSprite(obj).aimatState(_info);
            }
         }
      }
      
      private function onEnd3() : void
      {
         this.ui2.addFrameScript(this.ui2.totalFrames - 1,null);
         DisplayUtil.removeForParent(this.ui2);
         this.ui2 = null;
      }
   }
}

