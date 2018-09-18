USE [master]
GO
sp_configure 'show advanced options',1
GO
RECONFIGURE WITH OVERRIDE
GO
sp_configure 'Database Mail XPs',1
GO
RECONFIGURE 
GO
-- Create a New Mail Profile for Notifications
EXECUTE msdb.dbo.sysmail_add_profile_sp
       @profile_name = 'DBA_Notifications',
       @description = 'Profile for sending Automated DBA Notifications'
GO
-- Set the New Profile as the Default
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'DBA_Notifications',
    @principal_name = 'public',
    @is_default = 1 ;
GO
-- Create an Account for the Notifications
EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = 'SQLMonitor',
    @description = 'Account for Automated DBA Notifications',
    @email_address = 'mpathan4@slb.com',  -- Change This
    @display_name = 'SQL Monitor',
    @mailserver_name = 'mail.slb.com'  -- Change This
GO
-- Add the Account to the Profile
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'DBA_Notifications',
    @account_name = 'SQLMonitor',
    @sequence_number = 1
GO