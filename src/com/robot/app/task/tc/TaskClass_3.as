package com.robot.app.task.tc
{
   import com.robot.app.task.noviceGuide.AwardDialog;
   import com.robot.app.task.noviceGuide.GuideTaskController;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.TasksManager;
   
   public class TaskClass_3
   {
      public function TaskClass_3(info:NoviceFinishInfo)
      {
         super();
         AwardDialog.show("",function():void
         {
            GuideTaskController.showPanel();
         });
         trace("新手任务   成功获得新手奖励。。。。。。。。");
         MainManager.actorInfo.coins += 2000;
         TasksManager.setTaskStatus(3,TasksManager.COMPLETE);
      }
   }
}

