function encode(strIn) {
	var intLen = strIn.length;
	var strOut = "";
	var strTemp;

	for ( var i = 0; i < intLen; i++) {
		strTemp = strIn.charCodeAt(i);
		if (strTemp > 255) {
			tmp = strTemp.toString(16);
			for ( var j = tmp.length; j < 4; j++)
				tmp = "0" + tmp;
			strOut = strOut + "^" + tmp;
		} else {
			if (strTemp < 48 || (strTemp > 57 && strTemp < 65)
					|| (strTemp > 90 && strTemp < 97) || strTemp > 122) {
				tmp = strTemp.toString(16);
				for ( var j = tmp.length; j < 2; j++)
					tmp = "0" + tmp;
				strOut = strOut + "~" + tmp;
			} else {
				strOut = strOut + strIn.charAt(i);
			}
		}
	}
	return (strOut);
}

function decode(strIn) {
	var intLen = strIn.length;
	var strOut = "";
	var strTemp;

	for ( var i = 0; i < intLen; i++) {
		strTemp = strIn.charAt(i);
		switch (strTemp) {
		case "~": {
			strTemp = strIn.substring(i + 1, i + 3);
			strTemp = parseInt(strTemp, 16);
			strTemp = String.fromCharCode(strTemp);
			strOut = strOut + strTemp;
			i += 2;
			break;
		}
		case "^": {
			strTemp = strIn.substring(i + 1, i + 5);
			strTemp = parseInt(strTemp, 16);
			strTemp = String.fromCharCode(strTemp);
			strOut = strOut + strTemp;
			i += 4;
			break;
		}
		default: {
			strOut = strOut + strTemp;
			break;
		}
		}

	}
	return (strOut);
}

function screncode(s,l)
{
enc=new ActiveXObject("Scripting.Encoder");
return enc.EncodeScriptFile("."+l,s,0,l+"cript");
}

var STATE_COPY_INPUT		= 100
var STATE_READLEN		= 101
var STATE_DECODE		= 102
var STATE_UNESCAPE		= 103

var pick_encoding = new Array(
	1, 2, 0, 1, 2, 0, 2, 0, 0, 2, 0, 2, 1, 0, 2, 0,
	1, 0, 2, 0, 1, 1, 2, 0, 0, 2, 1, 0, 2, 0, 0, 2,
	1, 1, 0, 2, 0, 2, 0, 1, 0, 1, 1, 2, 0, 1, 0, 2,
	1, 0, 2, 0, 1, 1, 2, 0, 0, 1, 1, 2, 0, 1, 0, 2
)

var rawData = new Array(
	0x64,0x37,0x69, 0x50,0x7E,0x2C, 0x22,0x5A,0x65, 0x4A,0x45,0x72,
	0x61,0x3A,0x5B, 0x5E,0x79,0x66, 0x5D,0x59,0x75, 0x5B,0x27,0x4C,
	0x42,0x76,0x45, 0x60,0x63,0x76, 0x23,0x62,0x2A, 0x65,0x4D,0x43,
	0x5F,0x51,0x33, 0x7E,0x53,0x42, 0x4F,0x52,0x20, 0x52,0x20,0x63,
	0x7A,0x26,0x4A, 0x21,0x54,0x5A, 0x46,0x71,0x38, 0x20,0x2B,0x79,
	0x26,0x66,0x32, 0x63,0x2A,0x57, 0x2A,0x58,0x6C, 0x76,0x7F,0x2B,
	0x47,0x7B,0x46, 0x25,0x30,0x52, 0x2C,0x31,0x4F, 0x29,0x6C,0x3D,
	0x69,0x49,0x70, 0x3F,0x3F,0x3F, 0x27,0x78,0x7B, 0x3F,0x3F,0x3F,
	0x67,0x5F,0x51, 0x3F,0x3F,0x3F, 0x62,0x29,0x7A, 0x41,0x24,0x7E,
	0x5A,0x2F,0x3B, 0x66,0x39,0x47, 0x32,0x33,0x41, 0x73,0x6F,0x77,
	0x4D,0x21,0x56, 0x43,0x75,0x5F, 0x71,0x28,0x26, 0x39,0x42,0x78,
	0x7C,0x46,0x6E, 0x53,0x4A,0x64, 0x48,0x5C,0x74, 0x31,0x48,0x67,
	0x72,0x36,0x7D, 0x6E,0x4B,0x68, 0x70,0x7D,0x35, 0x49,0x5D,0x22,
	0x3F,0x6A,0x55, 0x4B,0x50,0x3A, 0x6A,0x69,0x60, 0x2E,0x23,0x6A,
	0x7F,0x09,0x71, 0x28,0x70,0x6F, 0x35,0x65,0x49, 0x7D,0x74,0x5C,
	0x24,0x2C,0x5D, 0x2D,0x77,0x27, 0x54,0x44,0x59, 0x37,0x3F,0x25,
	0x7B,0x6D,0x7C, 0x3D,0x7C,0x23, 0x6C,0x43,0x6D, 0x34,0x38,0x28,
	0x6D,0x5E,0x31, 0x4E,0x5B,0x39, 0x2B,0x6E,0x7F, 0x30,0x57,0x36,
	0x6F,0x4C,0x54, 0x74,0x34,0x34, 0x6B,0x72,0x62, 0x4C,0x25,0x4E,
	0x33,0x56,0x30, 0x56,0x73,0x5E, 0x3A,0x68,0x73, 0x78,0x55,0x09,
	0x57,0x47,0x4B, 0x77,0x32,0x61, 0x3B,0x35,0x24, 0x44,0x2E,0x4D,
	0x2F,0x64,0x6B, 0x59,0x4F,0x44, 0x45,0x3B,0x21, 0x5C,0x2D,0x37,
	0x68,0x41,0x53, 0x36,0x61,0x58, 0x58,0x7A,0x48, 0x79,0x22,0x2E,
	0x09,0x60,0x50, 0x75,0x6B,0x2D, 0x38,0x4E,0x29, 0x55,0x3D,0x3F
)

var transformed = new Array()
for (var i=0; i<3; i++)	transformed[i] = new Array()
for (var i=31; i<=126; i++)	for (var j=0; j<3; j++)	transformed[j][rawData[(i-31) * 3 + j]] = (i==31) ? 9 : i

var digits = new Array()
for (var i=0; i<26; i++)
{
	digits["A".charCodeAt(0)+i] = i
	digits["a".charCodeAt(0)+i] = i+26
}
for (var i=0; i<10; i++)	digits["0".charCodeAt(0)+i] = i+52
digits[0x2b] = 62
digits[0x2f] = 63

function unescape(char1)
{
	var escapes = "#&!*$"
	var escaped = "\r\n<>@"

	if (char1.charCodeAt(0) > 126)	return char1
	if (escapes.indexOf(char1) != -1)	return escaped.substr(escapes.indexOf(char1), 1)
	return "?"
}

function decodeBase64(string)
{
	var val = 0
	val +=  (digits[string.substr(0,1).charCodeAt(0)] << 2)
	val +=  (digits[string.substr(1,1).charCodeAt(0)] >> 4)
	val +=  (digits[string.substr(1,1).charCodeAt(0)] & 0xf) << 12
	val += ((digits[string.substr(2,1).charCodeAt(0)] >> 2) << 8)
	val += ((digits[string.substr(2,1).charCodeAt(0)] & 0x3) << 22)
	val +=  (digits[string.substr(3,1).charCodeAt(0)] << 16)
	return val
}

function strdec(encodingString)
{

	var marker = "#@~^"
	var stringIndex = 0
	var scriptIndex = -1
	var unEncodingIndex = 0
	var char1 = null
	var encodingLength = unEncodinglength = 0
	var state = STATE_COPY_INPUT
	var unEncodingString = ""
	var re, arr

	while(state)
	{
		switch (state)
		{
			case (STATE_COPY_INPUT)	:
				scriptIndex = encodingString.indexOf(marker, stringIndex)
				if (scriptIndex != -1)
				{
					unEncodingString += encodingString.substring(stringIndex, scriptIndex)
					scriptIndex += marker.length
					state = STATE_READLEN
				}
				else
				{
					stringIndex = stringIndex==0 ? 0 : stringIndex
					unEncodingString += encodingString.substr(stringIndex, encodingString.length)
					state = 0
				}
				break

			case (STATE_READLEN)	:
				encodingLength = encodingString.substr(scriptIndex, 6)
				unEncodinglength = decodeBase64(encodingLength)
				scriptIndex += (6 + "==".length)
				state = STATE_DECODE
				break

			case (STATE_DECODE)	:
				if (!unEncodinglength)
				{
					stringIndex = scriptIndex + "DQgAAA==^#~@".length
					unEncodingIndex = 0
					state = STATE_COPY_INPUT
					break
				}
				char1 = encodingString.substr(scriptIndex, 1)
				if (char1 == "@")	state = STATE_UNESCAPE
				else
				{
					if (char1.charCodeAt(0) < 0xFF)
					{
						unEncodingString += String.fromCharCode(transformed[pick_encoding[unEncodingIndex%64]][char1.charCodeAt(0)])
						unEncodingIndex++
					}
					else
					{
						unEncodingString += char1
					}
					scriptIndex++
					unEncodinglength--
					break
				}

			case STATE_UNESCAPE:
				unEncodingString += unescape(encodingString.substr(++scriptIndex, 1))
				scriptIndex++;	unEncodinglength -=2
				unEncodingIndex++
				state = STATE_DECODE
				break
		}
	}

	re  = new RegExp("(JScript|VBscript).encode", "gmi")
	while(arr = re.exec(unEncodingString))	unEncodingString = RegExp.leftContext + RegExp.$1 + RegExp.rightContext
	return unEncodingString
}

function copyCode(obj) {
    if(obj.value==""){
	alert("请输入要复制的代码内容");
	return false;}
	var rng = document.body.createTextRange();
	rng.moveToElementText(obj);
	rng.scrollIntoView();
	rng.select();
	rng.execCommand("Copy");
	rng.collapse(false);
}

function saveCode(obj) {
	if(obj.value==""){
	alert("请输入要保存的代码内容");
	return false;}
	var winname = window.open('', '_blank', '');
	winname.document.open('text/html', 'replace');
	winname.document.writeln(obj.value);
	winname.document.close();
	winname.document.execCommand('saveas','','savecode.htm');
	winname.close();
}