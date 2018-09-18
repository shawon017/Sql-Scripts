-- select * from fn_trace_getinfo(default)
USE Internship
GO
SELECT * INTO query_trc
FROM fn_trace_gettable('C:\Users\Public\Desktop.trc', default);
GO
