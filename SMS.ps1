Function SendSMS
{
	Param
	(
		[string]$UserName = $(Throw 'No username provided'),
		[string]$Password = $(Throw 'No Password provided'),
		[string]$Receiver = $(Throw 'No Receivernumber provided'),
		[string]$Url = 'http://gw2-fro.pswin.com:81/',
		[string]$Message,
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

