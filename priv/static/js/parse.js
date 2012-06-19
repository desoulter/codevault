$(document).ready(function(){
	
	$('button#share_button').zclip({
	        path:'/static/js/ZeroClipboard.swf',
	        copy:$('a#share_url').attr("href"),
			beforeCopy:function() {
				_gaq.push(['_trackEvent', 'button', 'copy', 'url_link']);
			}
	    });
	$('button#share_code_button').zclip({
		        path:'/static/js/ZeroClipboard.swf',
		        copy:$('code#code_snippet').text(),
				beforeCopy:function() {
					_gaq.push(['_trackEvent', 'button', 'copy', 'code']);
				}
	    });
	$('button#script_code_button').zclip({
		        path:'/static/js/ZeroClipboard.swf',
		        copy:$('#embed_code').text(),
				beforeCopy:function() {
					_gaq.push(['_trackEvent', 'button', 'copy', 'embedded']);
				}
	    });
});