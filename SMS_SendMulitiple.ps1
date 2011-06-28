function BuildXML
#supply username and password and HashTable with message objects built with function "CreateMessageObjects".#
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
		$XML_Text.Set_innerText($HTBL_RCV_MSG.item($Message).Message_text)
		$XML_RCV = $SMS_XML.CreateElement('RCV')
		$XML_RCV.Set_InnerText($HTBL_RCV_MSG.item($Message).Receiver)
		
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
	Write-Host $SMS_XML.OuterXml.ToString()
	
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
function CreateMessageObjects
#builds message objects that can be stored in a hashtable and then sent to the buildXML function.

{
	Param
	(
		[String]$Receiver,
		[String]$Message_text,
		[String]$Tarriff,
		[String]$MessageClass,
		[String]$Sender,
		[String]$TTL,
		[String]$deliverytime
		
	)
	$Message = New-Object PSObject
	Add-Member -Input $Message NoteProperty 'Receiver' $Receiver
	Add-Member -Input $Message NoteProperty 'Message_text' $Message_text
	Add-Member -Input $Message NoteProperty 'Tarriff' $Tarriff #not yet implemented
	Add-Member -Input $Message NoteProperty 'MessageClass' $MessageClass #not yet implemented
	Add-Member -Input $Message NoteProperty 'Sender' $Sender #not yet implemented
	Add-Member -Input $Message NoteProperty 'TTL' $TTL #not yet implemented
	Add-Member -Input $Message NoteProperty 'deliverytime' $deliverytime #not yet implemented
	
	Return $Message
}

#usage
$MSG_LIST = @{} #initialize Hashtable

#create message object
$MSG_OBJ = CreateMessageObjects -Receiver '4712345678' -Message_text 'Test Message'
#add object to Hashtable
$MSG_LIST.Add($MSG_LIST.Count + 1,$MSG_OBJ)

# and again
$MSG_OBJ = CreateMessageObjects -Receiver '4712345678' -Message_text 'Test Message2'
$MSG_LIST.Add($MSG_LIST.Count + 1,$MSG_OBJ)

# and again
$MSG_OBJ = CreateMessageObjects -Receiver '4712345678' -Message_text 'Test Message3'
$MSG_LIST.Add($MSG_LIST.Count + 1,$MSG_OBJ)

# and again
$MSG_OBJ = CreateMessageObjects -Receiver '4712345678' -Message_text 'Test Message4'
$MSG_LIST.Add($MSG_LIST.Count + 1,$MSG_OBJ)

# and again
$MSG_OBJ = CreateMessageObjects -Receiver '4712345678' -Message_text 'Test Message5'
$MSG_LIST.Add($MSG_LIST.Count + 1,$MSG_OBJ)

#send hashtable to BuildXML with username and password to get the XML
$Message_xml = buildxml -UserName 'username' -Password 'password' -HTBL_RCV_MSG $MSG_LIST

#grab the String version of the Xml and send that to sendSMS for submittion to PSWinCom Gateway.
sendSMS -XMLBLOCK $Message_xml[-1].outerxml.tostring()