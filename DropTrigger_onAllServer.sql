IF EXISTS(SELECT 1 FROM sys.server_triggers WHERE name = N'TR_ProtectCriticalTables')
BEGIN
    DROP TRIGGER TR_ProtectCriticalTables ON ALL SERVER;
END;