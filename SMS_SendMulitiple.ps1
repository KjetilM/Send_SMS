function BuildXML
#supply username and password and HashTable with Reciever/Message pairs.
#the function will generate a XML object that can be used to submitt messages to PSWinCom SMS Gateway (www.pswin.com)
{
	param
	(
		[string]$UserName = $(Throw 'No username provided'),
		[string]$Password = $(Throw 'No Password provided'),
		[Hashtable]$HTBL_RCV_MSG= $(Throw 'No message provided')
		
	)
	$SMS_XML = New-Object XML
	$XML_Session = $SMS_XML.CreateElement('SESSION')
	$XML_Client = $SMS_XML.CreateElement('CLIENT')
	$XML_Client.set_InnerText($UserName)
	$XML_PW = $SMS_XML.CreateElement('PW')
	$XML_PW.set_InnerText($Password)	
	#MessageList_Block
	$XML_MSGLST = $SMS_XML.CreateElement('MSGLST')
	$ID=1
	foreach ($Message in $HTBL_RCV_MSG.keys)
	{
		
		$XML_MSG = $SMS_XML.CreateElement('MSG')
		$XML_ID = $SMS_XML.CreateElement('ID')
		$XML_ID.set_innerText($ID)
		$XML_Text = $SMS_XML.CreateElement('TEXT')
		$XML_Text.Set_innerText($HTBL_RCV_MSG.$Message)
		$XML_RCV = $SMS_XML.CreateElement('RCV')
		$XML_RCV.Set_InnerText($Message)
		
			$XML_MSGLST.AppendChild($XML_MSG)
			$XML_MSG.AppendChild($XML_ID)
			$XML_MSG.AppendChild($XML_TEXT)
			$XML_MSG.AppendChild($XML_RCV)
		$ID++
	}
	#/MessageList_Block		
	$SMS_XML.AppendChild($XML_Session)
	$SMS_XML["SESSION"].AppendChild($XML_Client)
	$SMS_XML["SESSION"].AppendChild($XML_PW)
	$SMS_XML["SESSION"].AppendChild($XML_MSGLST)
	
	
	return $SMS_XML
	
	
}

Function SendSMS 
#Function that submitts the SMS to PSWinCom Gateway (www.pswin.com). 
#XMLBLOCK should be a String containing XML code. not an XML object.
{
	Param
	(
	[string]$XMLBLOCK,
	[Boolean]$Debug,
	[STRING]$Url = 'http://gw2-fro.pswin.com:81/'
	)
	
	If($Debug -eq 'TRUE')
	{
		write-host $XMLBLOCK
	}
	
	$Http = New-Object System.Net.WebClient
	$HttpResponse = $Http.UploadString($Url,'POST',$XMLBLOCK)
	return $HttpResponse

}
$MSG_RCV = @{}
$MSG_RCV.'[RECEIVER1]' = '[MESSAGE1]'
$MSG_RCV.'[RECEIVER2]' = '[MESSAGE2]'
$MSG_RCV.'[RECEIVER3]' = '[MESSAGE3]'

#build the XML to be submitted.
#Powershell collects the resulting XML from the function and stuffs it in an array so we need to itterate that afterwards.
$XML_DATA = BuildXML -UserName 'username' -Password 'password' -HTBL_RCV_MSG $msg_rcv

#submit XML as string to sender.
#The sender uses UploadString method so we need to send outerXml as string.
#[-1] is last element in Array, and will be the one containg the OuterXml we need. 
SendSMS -XMLBLOCK $XML_DATA[-1].Outerxml.tostring() -Debug $true -Url 'http://gw2-fro.pswin.com:81'
