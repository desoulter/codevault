$(document).ready(function(){
	
	$('button#share_button').zclip({
	        path:'/static/js/ZeroClipboard.swf',
	        copy:$('a#share_url').attr("href")
	    });
	$('button#share_code_button').zclip({
		        path:'/static/js/ZeroClipboard.swf',
		        copy:$('code#code_snippet').text()
		    });
});