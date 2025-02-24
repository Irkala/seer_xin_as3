package com.robot.app.task.tc
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   
   public class TaskClass_35
   {
      public function TaskClass_35(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(35,TasksManager.COMPLETE);
         info.monBallList.forEach(function(item:Object, index:int, array:Array):void
         {
            Alarm.show(TextFormatUtil.getRedTxt(ItemXMLInfo.getItemVipName(item.itemID)) + "已放入你超能NoNo的储藏空间中。");
         });
      }
   }
}

