Create Trigger ddlTrigger_LogTable
On Database FOR DROP_TABLE

As
DECLARE @eventData XML,
		@oname nvarchar(100),
		@ouname nvarchar(50),
		@edate datetime
SET @eventData = EVENTDATA()

Select
 --EventType = EVENTDATA().value('(EVENT_INSTANCE/EventType)[1]', 'sysname'),
 @edate = @eventData.value('(EVENT_INSTANCE/PostTime)[1]', 'datetime'),
-- LoginName = EVENTDATA().value('(EVENT_INSTANCE/LoginName)[1]', 'sysname'),
 @ouname = @eventData.value('(EVENT_INSTANCE/UserName)[1]', 'sysname'),
-- DatabaseName = EVENTDATA().value('(EVENT_INSTANCE/DatabaseName)[1]', 'sysname'),
-- SchemaName = EVENTDATA().value('(EVENT_INSTANCE/SchemaName)[1]', 'sysname'),
 @oname = @eventData.value('(EVENT_INSTANCE/ObjectName)[1]', 'sysname')
-- ObjectType = EVENTDATA().value('(EVENT_INSTANCE/ObjectType)[1]', 'sysname'),
-- CommandText = EVENTDATA().value('(EVENT_INSTANCE//TSQLCommand[1]/CommandText)[1]', 'nvarchar(max)')
--IF @oname = 'DropTableCommandLogs'
--from CommandLogs Where TableName = 'DropTableCommandLogs5'
IF @oname IN ('DropTablecommandLogs1', 'DropTableCommandLogs3', 'DropTableCommandLogs5')
	
GO