package com.robot.app.task.control
{
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.mode.AppModel;
   import com.robot.core.newloader.MCLoader;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import org.taomee.manager.ToolTipManager;
   
   public class TaskController_31
   {
      private static var icon:InteractiveObject;
      
      private static var lightMC:MovieClip;
      
      public static const TASK_ID:uint = 31;
      
      private static var panel:AppModel = null;
      
      public function TaskController_31()
      {
         super();
      }
      
      public static function setup() : void
      {
         if(TasksManager.getTaskStatus(TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            showIcon();
         }
      }
      
      public static function start() : void
      {
         NpcTipDialog.show("不要轻敌，眼前的每一个敌人都是可怕，这是一场硬仗，只有胆大心细的小赛尔才能突破重重包围进入海盗基地，为赛尔大部队的开辟安全的进攻道路。",accept,NpcTipDialog.INSTRUCTOR);
      }
      
      private static function accept() : void
      {
         TasksManager.accept(TASK_ID);
         showIcon();
         var mcloader:MCLoader = new MCLoader("resource/bounsMovie/PirateFortFightTask.swf",LevelManager.topLevel,1,"正在打开任务...");
         mcloader.addEventListener(MCLoadEvent.SUCCESS,onLoaded);
         mcloader.doLoad();
      }
      
      private static function onLoaded(evt:MCLoadEvent) : void
      {
         (evt.currentTarget as MCLoader).removeEventListener(MCLoadEvent.SUCCESS,onLoaded);
         var app:ApplicationDomain = evt.getApplicationDomain();
         var mc:MovieClip = new (app.getDefinition("ReceiveTaskMC") as Class)() as MovieClip;
         LevelManager.appLevel.addChild(mc);
         mc.x = 480;
         mc.y = 280;
      }
      
      public static function showIcon() : void
      {
         if(!icon)
         {
            icon = TaskIconManager.getIcon("icon_31");
            icon.addEventListener(MouseEvent.CLICK,clickHandler);
            ToolTipManager.add(icon,"海盗要塞前的战斗");
            lightMC = icon["lightMC"];
         }
         TaskIconManager.addIcon(icon);
      }
      
      public static function delIcon() : void
      {
         TaskIconManager.delIcon(icon);
      }
      
      private static function clickHandler(event:MouseEvent) : void
      {
         lightMC.gotoAndStop(lightMC.totalFrames);
         if(panel == null)
         {
            panel = new AppModel(ClientConfig.getTaskModule("PirateFortFight"),"正在打开任务信息");
            panel.setup();
         }
         panel.show();
      }
   }
}

