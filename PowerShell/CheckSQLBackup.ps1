#This script scans network locations in an array which contain SQL backups. It sorts by date then compares the timestamp to the timestamp of the day before. If it is greter then the daily backup is considered complete. 
#List of SQL backup locations
$array = @("\\server1\d$\SQL Backup\\", "\\server2\d$\SQL Backup\\", "\\server3\d$\SQL Backup\", "\\server4\SQL Backup\")
foreach ($al in $array){
$a = dir -path $al | gci | sort LastWriteTime | select -last 1
if ($a.LastWriteTime -ge (Get-Date).AddDays(-1))
{
$tx = "Backup Completed Sucessfully"
$a,$tx | Out-File c:\pshelloutput\sqlbackup.txt -Append
}
Else 
{
$tx = "Backup Did Not Complete Sucessfully" 
$a,$tx | Out-File c:\pshelloutput\sqlbackup.txt -Append
}
}
$emailFrom = "email@company.com"
$emailTo = "emailreceipient@company.com"
$subject = "SQLServer Backup"
$body = "SQLServer Backup"
$smtpServer = "mail.company.com"
$filePath = "c:\pshelloutput\sqlbackup.txt"

#Email results
#Initate message
$email = New-Object System.Net.Mail.MailMessage 
$email.From = $emailFrom
$email.To.Add($emailTo)
$email.Subject = $subject
$email.Body = $body
#Initiate email attachment 
$emailAttach = New-Object System.Net.Mail.Attachment $filePath
$email.Attachments.Add($emailAttach) 
#Initiate sending email 
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($email)
$emailAttach.Dispose()
#remote attachment 
Remove-Item c:\pshelloutput\sqlbackup.txt
