
DECLARE @query_attachement_filename NVARCHAR(500)
DECLARE @sub VARCHAR(100)
DECLARE @msg VARCHAR(1000)
DECLARE @query VARCHAR(2048)
SET @query = ''
--INSERT INTO [Internship].[dbo].[query](database_name, login_name, login_time, nt_user_name, query)
SELECT sdest.DatabaseName
    ,sdes.login_name
    ,sdes.login_time
    ,sdes.nt_user_name
    ,sdest.Query
FROM sys.dm_exec_sessions AS sdes
INNER JOIN sys.dm_exec_connections AS sdec ON sdec.session_id = sdes.session_id
CROSS APPLY (
    SELECT db_name(database_id) AS DatabaseName
        ,(
                SELECT TEXT AS [processing-instruction(definition)]
                FROM sys.dm_exec_sql_text(sdec.most_recent_sql_handle)
                ) AS Query

    FROM sys.dm_exec_sql_text(sdec.most_recent_sql_handle)
    ) sdest
where sdes.session_id <> @@SPID and login_time >= DATEADD(HOUR, -1, GETDATE())
--	and Query like ('%SELECT%') -- take all the queries with select statement
	and Query not like ('%(@_%')
	and Query not like ('%if%')
	and Query not like ('%ALTER%')

--and sdes.nt_user_name = '' -- Put the username here !
ORDER BY sdec.session_id
SELECT @query_attachement_filename = 'test.csv'
SELECT @msg = 'User performed query'
SELECT @sub = 'Query'
--EXEC msdb.dbo.sp_send_dbmail
--	@profile_name = 'DBA_Notifications',
	--@recipients = 'shawonpathan@hotmail.com',
--	@copy_recipients = 'shawonpathan@hotmail.com',
	--@subject = @sub,
	--@body = @msg,
	--@query = Query,
	--@query_attachment_filename = @query_attachement_filename,	
	--@attach_query_result_as_file = 1,
	--@query_result_header = 1,
	--@query_no_truncate = 1,
	--@query_result_width = 256,
	--@query_result_separator = '	   ';
--	@query_result_no_padding=1;



