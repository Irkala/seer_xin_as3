package com.robot.app.task.disappearTeam
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.mode.AppModel;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class TwoBrothersIconController
   {
      private static var iconBtn:SimpleButton;
      
      private static var rescusPanel:AppModel;
      
      public function TwoBrothersIconController()
      {
         super();
      }
      
      public static function check() : void
      {
         if(TasksManager.getTaskStatus(13) == TasksManager.COMPLETE && TasksManager.getTaskStatus(14) == TasksManager.COMPLETE)
         {
            return;
         }
         var b1:Boolean = false;
         var b2:Boolean = false;
         if(TasksManager.getTaskStatus(13) == TasksManager.ALR_ACCEPT || TasksManager.getTaskStatus(13) == TasksManager.COMPLETE)
         {
            b1 = true;
         }
         if(TasksManager.getTaskStatus(14) == TasksManager.ALR_ACCEPT || TasksManager.getTaskStatus(14) == TasksManager.COMPLETE)
         {
            b2 = true;
         }
         if(b1 && b2)
         {
            createIcon();
         }
      }
      
      public static function createIcon() : void
      {
         iconBtn = UIManager.getButton("TwoBrothers_Icon");
         TaskIconManager.addIcon(iconBtn);
         iconBtn.addEventListener(MouseEvent.CLICK,onIconClickHandler);
      }
      
      private static function onIconClickHandler(e:MouseEvent) : void
      {
         showPanel();
      }
      
      public static function showPanel() : void
      {
         if(!rescusPanel)
         {
            rescusPanel = new AppModel(ClientConfig.getTaskModule("RescueTwoBrothersPanel"),"正在打开特派队任务");
            rescusPanel.setup();
         }
         rescusPanel.show();
      }
      
      public static function removeIcon() : void
      {
         if(Boolean(iconBtn))
         {
            iconBtn.removeEventListener(MouseEvent.CLICK,onIconClickHandler);
            TaskIconManager.delIcon(iconBtn);
            iconBtn = null;
         }
         if(Boolean(rescusPanel))
         {
            rescusPanel.destroy();
            rescusPanel = null;
         }
      }
   }
}

