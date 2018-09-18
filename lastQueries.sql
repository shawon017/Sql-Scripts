USE master
go

DECLARE @query_attachement_filename NVARCHAR(500)
DECLARE @sub VARCHAR(100)
DECLARE @msg VARCHAR(1000)
DECLARE @query VARCHAR(2048)
SET @query = ''
SELECT sdest.DatabaseName
--    ,sdes.session_id
--   ,sdes.[host_name]
--   ,sdes.[program_name]
    ,sdes.login_name
    ,sdes.login_time
--    ,sdes.nt_domain
    ,sdes.nt_user_name
 --   ,sdec.client_net_address
 --   ,sdec.local_net_address
--    ,sdest.ObjName
    ,sdest.Query
FROM sys.dm_exec_sessions AS sdes
INNER JOIN sys.dm_exec_connections AS sdec ON sdec.session_id = sdes.session_id
CROSS APPLY (
    SELECT db_name(dbid) AS DatabaseName
      --  ,object_id(objectid) AS ObjName
        ,ISNULL((
                SELECT TEXT AS [processing-instruction(definition)]
                FROM sys.dm_exec_sql_text(sdec.most_recent_sql_handle)
                FOR XML PATH('')
                    ,TYPE
                ), '') AS Query

    FROM sys.dm_exec_sql_text(sdec.most_recent_sql_handle)
    ) sdest
where sdes.session_id <> @@SPID and login_time >= DATEADD(HOUR, -1, GETDATE())
--and sdes.nt_user_name = '' -- Put the username here !
ORDER BY sdec.session_id
SELECT @query_attachement_filename = 'test.csv'
SELECT @msg = 'User performed query'
SELECT @sub = 'Query'
EXEC msdb.dbo.sp_send_dbmail
	@profile_name = 'DBA_Notifications',
	@recipients = 'shawonpathan@hotmail.com',
--	@copy_recipients = 'shawonpathan@hotmail.com',
	@subject = @sub,
	@body = @msg,
	@query = Query,
	@query_attachment_filename = @query_attachement_filename,	
	@attach_query_result_as_file = 1,
	@query_result_header = 1,
	@query_no_truncate = 1,
	@query_result_width = 256,
	@query_result_separator = '	   ';
--	@query_result_no_padding=1;



