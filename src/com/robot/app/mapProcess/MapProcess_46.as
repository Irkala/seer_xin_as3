package com.robot.app.mapProcess
{
   import com.robot.app.buyItem.ItemAction;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import gs.TweenLite;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_46 extends BaseMapProcess
   {
      private var roadMC:MovieClip;
      
      private var rollMC_0:MovieClip;
      
      private var rollMC_1:MovieClip;
      
      private var btn_0:MovieClip;
      
      private var btn_1:MovieClip;
      
      public function MapProcess_46()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.jh();
         this.refreshRoad();
      }
      
      override public function destroy() : void
      {
         MainManager.actorModel.sprite.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
      }
      
      private function jh() : void
      {
         MainManager.actorModel.sprite.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         this.roadMC = animatorLevel["roadMC"];
         this.rollMC_0 = animatorLevel["rollMC_0"];
         this.rollMC_1 = animatorLevel["rollMC_1"];
         this.btn_0 = conLevel["btn_0"];
         this.btn_1 = conLevel["btn_1"];
         this.btn_1.buttonMode = true;
         this.btn_0.buttonMode = true;
         this.btn_0.gotoAndStop(1);
         this.btn_1.gotoAndStop(1);
         this.btn_0.addEventListener(MouseEvent.CLICK,this.clickBtn);
         this.btn_1.addEventListener(MouseEvent.CLICK,this.clickBtn);
      }
      
      private function clickBtn(event:MouseEvent) : void
      {
         var btn:MovieClip = event.currentTarget as MovieClip;
         btn.gotoAndStop(2);
         btn.mouseEnabled = false;
         if(btn == this.btn_0)
         {
            DisplayUtil.stopAllMovieClip(this.rollMC_0);
         }
         else
         {
            DisplayUtil.stopAllMovieClip(this.rollMC_1);
         }
      }
      
      private function getItem(event:MouseEvent) : void
      {
         ItemAction.buyItem(100172,false);
      }
      
      private function kgHandler(event:MouseEvent) : void
      {
         conLevel["light_0"].gotoAndStop(4);
      }
      
      private function refreshRoad() : void
      {
         this.roadMC.gotoAndStop(50);
         DisplayUtil.removeForParent(typeLevel["maskMC"]);
         MapManager.currentMap.makeMapArray();
      }
      
      private function onWalk(event:RobotEvent) : void
      {
         if(this.rollMC_0.hitTestPoint(MainManager.actorModel.pos.x,MainManager.actorModel.pos.y,true))
         {
            if(this.btn_0.currentFrame == 1)
            {
               LevelManager.closeMouseEvent();
               MainManager.actorModel.stop();
               TweenLite.to(MainManager.actorModel,2,{
                  "x":268,
                  "y":364,
                  "onComplete":this.compHandler
               });
            }
         }
         if(this.rollMC_1.hitTestPoint(MainManager.actorModel.pos.x,MainManager.actorModel.pos.y,true))
         {
            if(this.btn_1.currentFrame == 1)
            {
               LevelManager.closeMouseEvent();
               MainManager.actorModel.stop();
               TweenLite.to(MainManager.actorModel,2,{
                  "x":600,
                  "y":370,
                  "onComplete":this.compHandler
               });
            }
         }
      }
      
      private function compHandler() : void
      {
         LevelManager.openMouseEvent();
      }
   }
}

