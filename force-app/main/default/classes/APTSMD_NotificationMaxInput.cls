/*************************************************************
@Name: APTSMD_NotificationMaxInput
******************************************************************/
Public class APTSMD_NotificationMaxInput{
    Public String NotificationType {get; set;}           // notification type
    Public String MaxToken {get; set;}            
    Public String ObjectName;
    Public List<MaxUserNotification> NotificationInfoList;
    Public String NotificationSequenceId;
    Public String BaseUrl;
   
    Public class MaxUserNotification {
        public String UserId;
        public String RecordId;
        public sObject lookupResult;
    }
}