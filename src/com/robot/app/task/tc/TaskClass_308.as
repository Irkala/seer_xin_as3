package com.robot.app.task.tc
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   
   public class TaskClass_308
   {
      public function TaskClass_308(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(308,TasksManager.COMPLETE);
         var id:uint = uint(info.monBallList[0].itemID);
         LevelManager.iconLevel.addChild(Alarm.show("你得到了1个" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(id)) + "。"));
      }
   }
}

