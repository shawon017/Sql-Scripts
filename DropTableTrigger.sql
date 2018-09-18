--Trigger to notify user on drop of specific tables
CREATE TRIGGER [TR_ProtectCriticalTables]
ON all server
FOR 
 DROP_TABLE

AS
-- Decalre tha variables
DECLARE @eventData XML,
        @username NVARCHAR(50),
        @tablename NVARCHAR(100),
        @eventdate DATETIME

-- assigning eventdata() to variable
SET @eventData = eventdata()

SELECT
        @eventdate=GETDATE(),
        @username=@eventData.value('data(/EVENT_INSTANCE/UserName)[1]', 'SYSNAME'),
        @tablename=@eventData.value('data(/EVENT_INSTANCE/ObjectName)[1]', 'SYSNAME')

--Condition for selected tables to be taken
IF @tablename IN ('DropTablecommandLogs1','DropTablecommandLogs2','Droptable')
  BEGIN
	Insert into Internship.dbo.CommandLogs
	VALUES(
		@eventdate,
		@username,
		@tablename
	)

END
GO
ENABLE TRIGGER [TR_ProtectCriticalTables] ON all server