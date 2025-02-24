package com.robot.app.specialIcon
{
   import com.robot.core.manager.MainManager;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SpecialIconController
   {
      private static var list:SpecialIconList;
      
      private static var timer:Timer;
      
      public function SpecialIconController()
      {
         super();
      }
      
      public static function show(dis:DisplayObject) : void
      {
         if(Boolean(list))
         {
            MainManager.getStage().removeEventListener(MouseEvent.CLICK,stageClick);
            list.show(dis);
            timer.stop();
            timer.start();
         }
         else
         {
            timer = new Timer(500,1);
            timer.addEventListener(TimerEvent.TIMER,addStageListener);
            list = new SpecialIconList();
            list.show(dis);
            timer.stop();
            timer.start();
         }
      }
      
      private static function addStageListener(e:TimerEvent) : void
      {
         MainManager.getStage().addEventListener(MouseEvent.CLICK,stageClick);
      }
      
      private static function stageClick(event:MouseEvent) : void
      {
         if(!list.hitTestPoint(MainManager.getStage().mouseX,MainManager.getStage().mouseY,true))
         {
            MainManager.getStage().removeEventListener(MouseEvent.CLICK,stageClick);
            list.hide();
         }
      }
   }
}

