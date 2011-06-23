#Small and simple PowerShell function for sending SMS via the SMS gateway from pswincom (http://www.pswin.com)
#You need a valid account with pswincom, se homepage for details


Function SendSMS
{
	Param
	(
		[string]$UserName = $(Throw 'No username provided'),
		[string]$Password = $(Throw 'No Password provided'),
		[string]$Receiver = $(Throw 'No Receivernumber provided'),
		[string]$Url = 'http://gw2-fro.pswin.com:81/',
		[string]$Message= $(Throw 'No message provided'),
		[boolean]$Debug
		
	)
	$XML = "<SESSION><CLIENT>$UserName</CLIENT><PW>$Password</PW><MSGLST><MSG><ID>1</ID><TEXT>$Message</TEXT><RCV>$Receiver</RCV></MSG></MSGLST></SESSION>"
	If($Debug -eq 'TRUE')
	{
		write-host $XML
	}
	$Http = New-Object System.Net.WebClient
	$HttpResponse = $Http.UploadString($Url,'POST' ,$XML)
	return $HttpResponse

}

#usage:
#$Result = SendSMS -UserName 'Username' -Password 'Password' -Receiver '12345678' -Url 'http://gw2-fro.pswin.com:81' -Message 'Message to Send' -debug 'True' 
#You must provide a username, password, Receiver and message 
#Url is optional default is ok for most cases. 
#Debug will echo the XML to use in the 'POST' to console