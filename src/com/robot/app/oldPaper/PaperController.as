package com.robot.app.oldPaper
{
   import com.robot.core.manager.LevelManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.DisplayUtil;
   
   public class PaperController
   {
      private static var mc:MovieClip;
      
      private static var posArray:Array = [new Point(70,26),new Point(480,287),new Point(480,287),new Point(480,287),new Point(567,294),new Point(567,294),new Point(567,294),new Point(567,294)];
      
      public function PaperController()
      {
         super();
      }
      
      public static function setup(app:ApplicationDomain, index:uint) : void
      {
         mc = new (app.getDefinition("timeNews") as Class)() as MovieClip;
         mc.stop();
         (mc["bookMC"] as MovieClip).stop();
         show(index);
      }
      
      private static function show(index:uint) : void
      {
         var p:Point = posArray[index];
         if(!p)
         {
            p = new Point(567,294);
         }
         mc.x = p.x;
         mc.y = p.y;
         LevelManager.closeMouseEvent();
         LevelManager.topLevel.addChild(mc);
         var closeBtn:SimpleButton = mc["exitBtn"];
         closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
      }
      
      private static function closeHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(mc);
         LevelManager.openMouseEvent();
      }
   }
}

