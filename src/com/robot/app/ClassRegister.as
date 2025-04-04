package com.robot.app
{
   import com.robot.app.experienceShared.ExperienceSharedInfo;
   import com.robot.app.experienceShared.GetExperienceInfo;
   import com.robot.app.experienceShared.MyExperiencePondInfo;
   import com.robot.app.fightLevel.ChoiceLevelRequestInfo;
   import com.robot.app.fightLevel.SuccessFightRequestInfo;
   import com.robot.app.freshFightLevel.FreshChoiceLevelRequestInfo;
   import com.robot.app.freshFightLevel.FreshSuccessFightRequestInfo;
   import com.robot.app.info.ArenaInfo;
   import com.robot.app.info.fightInvite.InviteHandleInfo;
   import com.robot.app.info.fightInvite.InviteNoteInfo;
   import com.robot.app.info.item.BuyItemInfo;
   import com.robot.app.info.item.BuyMultiItemInfo;
   import com.robot.app.magicPassword.GiftItemInfo;
   import com.robot.app.teacherAward.SevenNoLoginInfo;
   import com.robot.app.teacherAward.TeacherAwardInfo;
   import com.robot.core.CommandID;
   import com.robot.core.info.ChangeClothInfo;
   import com.robot.core.info.ChangeUserNameInfo;
   import com.robot.core.info.ChatInfo;
   import com.robot.core.info.FightLoadPercentInfo;
   import com.robot.core.info.GetImgAddrInfo;
   import com.robot.core.info.GetPlateInfo;
   import com.robot.core.info.HatchTask.HatchTaskBufInfo;
   import com.robot.core.info.InformInfo;
   import com.robot.core.info.MapHotInfo;
   import com.robot.core.info.NonoImplementsToolResquestInfo;
   import com.robot.core.info.PetKingPrizeInfo;
   import com.robot.core.info.RoomPetInfo;
   import com.robot.core.info.SystemMsgInfo;
   import com.robot.core.info.SystemTimeInfo;
   import com.robot.core.info.TeamChatInfo;
   import com.robot.core.info.UsePetItemOutOfFightInfo;
   import com.robot.core.info.fbGame.FBGameOverInfo;
   import com.robot.core.info.fightInfo.CatchPetInfo;
   import com.robot.core.info.fightInfo.ChangePetInfo;
   import com.robot.core.info.fightInfo.FightStartInfo;
   import com.robot.core.info.fightInfo.NoteReadyToFightInfo;
   import com.robot.core.info.fightInfo.UsePetItemInfo;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.info.fightInfo.attack.UseSkillInfo;
   import com.robot.core.info.mail.MailListInfo;
   import com.robot.core.info.moneyAndGold.GoldBuyProductInfo;
   import com.robot.core.info.moneyAndGold.MoneyBuyProductInfo;
   import com.robot.core.info.pet.EatSpecialMedicineInfo;
   import com.robot.core.info.pet.PetBargeListInfo;
   import com.robot.core.info.pet.PetFusionInfo;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.PetShowInfo;
   import com.robot.core.info.pet.PetTakeOutInfo;
   import com.robot.core.info.pet.update.PetUpdatePropInfo;
   import com.robot.core.info.pet.update.PetUpdateSkillInfo;
   import com.robot.core.info.task.BossMonsterInfo;
   import com.robot.core.info.task.DayTalkInfo;
   import com.robot.core.info.task.ExchangeOreInfo;
   import com.robot.core.info.task.MiningCountInfo;
   import com.robot.core.info.task.TaskBufInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.info.team.DonateInfo;
   import com.robot.core.info.team.SimpleTeamInfo;
   import com.robot.core.info.team.TeamAddInfo;
   import com.robot.core.info.team.TeamInformInfo;
   import com.robot.core.info.team.TeamLogoInfo;
   import com.robot.core.info.team.TeamMemberListInfo;
   import com.robot.core.info.team.WorkInfo;
   import com.robot.core.info.teamPK.SeerChartsInfo;
   import com.robot.core.info.teamPK.SomeoneJoinInfo;
   import com.robot.core.info.teamPK.SuperNonoShieldInfo;
   import com.robot.core.info.teamPK.TeamChartsInfo;
   import com.robot.core.info.teamPK.TeamPKBeShotInfo;
   import com.robot.core.info.teamPK.TeamPKBuildingListInfo;
   import com.robot.core.info.teamPK.TeamPKFreezeInfo;
   import com.robot.core.info.teamPK.TeamPKJoinInfo;
   import com.robot.core.info.teamPK.TeamPKNoteInfo;
   import com.robot.core.info.teamPK.TeamPKResultInfo;
   import com.robot.core.info.teamPK.TeamPKSignInfo;
   import com.robot.core.info.teamPK.TeamPkHistoryInfo;
   import com.robot.core.info.teamPK.TeamPkStInfo;
   import com.robot.core.info.teamPK.TeamPkWeekyHistoryInfo;
   import com.robot.core.info.transform.TransformInfo;
   import com.robot.core.temp.AresiaSpacePrize;
   import org.taomee.tmf.TMF;
   
   public class ClassRegister
   {
      public function ClassRegister()
      {
         super();
      }
      
      public static function setup() : void
      {
         TMF.registerClass(CommandID.CHANG_NICK_NAME,ChangeUserNameInfo);
         TMF.registerClass(CommandID.SYSTEM_TIME,SystemTimeInfo);
         TMF.registerClass(CommandID.SYSTEM_MESSAGE,SystemMsgInfo);
         TMF.registerClass(CommandID.MAP_HOT,MapHotInfo);
         TMF.registerClass(CommandID.GET_IMAGE_ADDRES,GetImgAddrInfo);
         TMF.registerClass(CommandID.LOAD_PERCENT,FightLoadPercentInfo);
         TMF.registerClass(CommandID.GET_PET_INFO,PetInfo);
         TMF.registerClass(CommandID.PET_RELEASE,PetTakeOutInfo);
         TMF.registerClass(CommandID.PET_SHOW,PetShowInfo);
         TMF.registerClass(CommandID.USE_PET_ITEM_OUT_OF_FIGHT,UsePetItemOutOfFightInfo);
         TMF.registerClass(CommandID.PET_BARGE_LIST,PetBargeListInfo);
         TMF.registerClass(CommandID.PET_FUSION,PetFusionInfo);
         TMF.registerClass(CommandID.ITEM_BUY,BuyItemInfo);
         TMF.registerClass(CommandID.MULTI_ITEM_BUY,BuyMultiItemInfo);
         TMF.registerClass(CommandID.NOTE_INVITE_TO_FIGHT,InviteNoteInfo);
         TMF.registerClass(CommandID.NOTE_HANDLE_FIGHT_INVITE,InviteHandleInfo);
         TMF.registerClass(CommandID.NOTE_READY_TO_FIGHT,NoteReadyToFightInfo);
         TMF.registerClass(CommandID.NOTE_START_FIGHT,FightStartInfo);
         TMF.registerClass(CommandID.NOTE_UPDATE_SKILL,PetUpdateSkillInfo);
         TMF.registerClass(CommandID.NOTE_UPDATE_PROP,PetUpdatePropInfo);
         TMF.registerClass(CommandID.NOTE_USE_SKILL,UseSkillInfo);
         TMF.registerClass(CommandID.FIGHT_OVER,FightOverInfo);
         TMF.registerClass(CommandID.CATCH_MONSTER,CatchPetInfo);
         TMF.registerClass(CommandID.CHANGE_PET,ChangePetInfo);
         TMF.registerClass(CommandID.USE_PET_ITEM,UsePetItemInfo);
         TMF.registerClass(CommandID.PEOPLE_TRANSFROM,TransformInfo);
         TMF.registerClass(CommandID.EAT_SPECIAL_MEDICINE,EatSpecialMedicineInfo);
         TMF.registerClass(CommandID.CHAT,ChatInfo);
         TMF.registerClass(CommandID.XIN_CHAT,ChatInfo);
         TMF.registerClass(CommandID.CHANGE_CLOTH,ChangeClothInfo);
         TMF.registerClass(CommandID.INFORM,InformInfo);
         TMF.registerClass(CommandID.COMPLETE_DAILY_TASK,NoviceFinishInfo);
         TMF.registerClass(CommandID.COMPLETE_TASK,NoviceFinishInfo);
         TMF.registerClass(CommandID.TALK_COUNT,MiningCountInfo);
         TMF.registerClass(CommandID.TALK_CATE,DayTalkInfo);
         TMF.registerClass(CommandID.EXCHANGE_ORE,ExchangeOreInfo);
         TMF.registerClass(CommandID.GET_DAILY_TASK_BUF,TaskBufInfo);
         TMF.registerClass(CommandID.GET_TASK_BUF,TaskBufInfo);
         TMF.registerClass(CommandID.GET_BOSS_MONSTER,BossMonsterInfo);
         TMF.registerClass(CommandID.PRIZE_OF_PETKING,PetKingPrizeInfo);
         TMF.registerClass(CommandID.GET_SOUL_BEAD_BUF,HatchTaskBufInfo);
         TMF.registerClass(CommandID.GET_GIFT_COMPLETE,GiftItemInfo);
         TMF.registerClass(CommandID.EXPERIENCESHARED_COMPLETE,ExperienceSharedInfo);
         TMF.registerClass(CommandID.MYEXPERIENCEPOND_COMPLETE,MyExperiencePondInfo);
         TMF.registerClass(CommandID.TEACHERREWARD_COMPLETE,TeacherAwardInfo);
         TMF.registerClass(CommandID.SEVENNOLOGIN_COMPLETE,SevenNoLoginInfo);
         TMF.registerClass(CommandID.GETMYEXPERIENCE_COMPLETE,GetExperienceInfo);
         TMF.registerClass(CommandID.CHOICE_FIGHT_LEVEL,ChoiceLevelRequestInfo);
         TMF.registerClass(CommandID.START_FIGHT_LEVEL,SuccessFightRequestInfo);
         TMF.registerClass(CommandID.FRESH_CHOICE_FIGHT_LEVEL,FreshChoiceLevelRequestInfo);
         TMF.registerClass(CommandID.FRESH_START_FIGHT_LEVEL,FreshSuccessFightRequestInfo);
         TMF.registerClass(CommandID.ARENA_GET_INFO,ArenaInfo);
         TMF.registerClass(CommandID.PRIZE_OF_ATRESIASPACE,AresiaSpacePrize);
         TMF.registerClass(CommandID.TEAM_INFORM,TeamInformInfo);
         TMF.registerClass(CommandID.TEAM_GET_INFO,SimpleTeamInfo);
         TMF.registerClass(CommandID.TEAM_ADD,TeamAddInfo);
         TMF.registerClass(CommandID.TEAM_GET_MEMBER_LIST,TeamMemberListInfo);
         TMF.registerClass(CommandID.TEAM_GET_LOGO_INFO,TeamLogoInfo);
         TMF.registerClass(CommandID.FB_GAME_OVER,FBGameOverInfo);
         TMF.registerClass(CommandID.ARM_UP_DONATE,DonateInfo);
         TMF.registerClass(CommandID.ARM_UP_WORK,WorkInfo);
         TMF.registerClass(CommandID.TEAM_CHAT,TeamChatInfo);
         TMF.registerClass(CommandID.HIT_STONE,BossMonsterInfo);
         TMF.registerClass(CommandID.NONO_IMPLEMENT_TOOL,NonoImplementsToolResquestInfo);
         TMF.registerClass(CommandID.TEAM_PK_SIGN,TeamPKSignInfo);
         TMF.registerClass(CommandID.TEAM_PK_NOTE,TeamPKNoteInfo);
         TMF.registerClass(CommandID.TEAM_PK_BE_SHOT,TeamPKBeShotInfo);
         TMF.registerClass(CommandID.TEAM_PK_JOIN,TeamPKJoinInfo);
         TMF.registerClass(CommandID.TEAM_PK_GET_BUILDING_INFO,TeamPKBuildingListInfo);
         TMF.registerClass(CommandID.TEAM_PK_FREEZE,TeamPKFreezeInfo);
         TMF.registerClass(CommandID.TEAM_PK_SITUATION,TeamPkStInfo);
         TMF.registerClass(CommandID.TEAM_PK_SOMEONE_JOIN_INFO,SomeoneJoinInfo);
         TMF.registerClass(CommandID.TEAM_PK_USE_SHIELD,SuperNonoShieldInfo);
         TMF.registerClass(CommandID.TEAM_PK_RESULT,TeamPKResultInfo);
         TMF.registerClass(CommandID.TEAM_PK_SEER_CHARTS,SeerChartsInfo);
         TMF.registerClass(CommandID.TEAM_PK_TEAM_CHARTS,TeamChartsInfo);
         TMF.registerClass(CommandID.TEAM_PK_WEEKY_SCORE,TeamPkWeekyHistoryInfo);
         TMF.registerClass(CommandID.TEAM_PK_HISTORY,TeamPkHistoryInfo);
         TMF.registerClass(CommandID.MONEY_BUY_PRODUCT,MoneyBuyProductInfo);
         TMF.registerClass(CommandID.GOLD_BUY_PRODUCT,GoldBuyProductInfo);
         TMF.registerClass(CommandID.MAIL_GET_LIST,MailListInfo);
         TMF.registerClass(CommandID.MEDAL_GET_COUNT,GetPlateInfo);
         TMF.registerClass(CommandID.PET_ROOM_INFO,RoomPetInfo);
      }
   }
}

