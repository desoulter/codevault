function checkLang() {
	data = $("#code_snippet").text();
	hl = hljs.highlightAuto(data);
	firstLng = hl.language;
	//secondLng = hl.second_best.language;
	var lang = new Object();
	lang.firstLanguage  = firstLng;
	//lang.secondLanguage = secondLng;
	return lang;
}


$(function () {
    $('#myTab a:first').tab('show');
  });

$('a[data-toggle="tab"]').on('show', function (e) {

	if ($(e.target).attr("href")=="#preview") {
		_gaq.push(['_trackEvent', 'tab', 'preview', 'show']);
		manualSelect = true;
		text = $("#textarea").val();
		if (text.length > 0) {
			if (text != currentText ) {				
				currentText = text;
				$("#code_snippet").text(text);	
				$('#code_snippet').each(function(i, e) {hljs.highlightBlock(e)});
			
				var current = checkLang();

				$("#lang_list option[value="+current.firstLanguage+"]").attr('selected', 'selected');
			}
		} else {
			e.preventDefault();
			$('#myTab a:first').tab('show');
			$("#text_container").addClass("error");
			_gaq.push(['_trackEvent', 'tab', 'preview', 'empty']);
		}
	} else {
		$("#code_snippet").removeClass();
		_gaq.push(['_trackEvent', 'tab', 'code', 'show']);
	}
});

var currentText = "";
var manualSelect = false;

$(document).ready(function(){
	var languages = hljs.LANGUAGES;
	
	$("#lang_list").append('<option value="no-highlight">plain</option>');
	for(var index in languages) {
		$('#lang_list').append('<option value="'+index+'">'+index+'</option>');
	}
	
	$("#textarea").click(function() {
		_gaq.push(['_trackEvent', 'textarea', 'click']);
		if($("#text_container").hasClass("error"))
			$("#text_container").removeClass("error");
	});
	
	$("#code_submit").submit(function(){
		if (!manualSelect) {
			_gaq.push(['_trackEvent', 'button', 'submit']);
			text = $("#textarea").val();
			$("#code_snippet").text(text);	
			$('#code_snippet').each(function(i, e) {hljs.highlightBlock(e)});
		
			var current = checkLang();

			$("#lang_list option[value="+current.firstLanguage+"]").attr('selected', 'selected');
		};
		return true;
	});
	
	$("#lang_list").change(function(){
		$("#code_snippet").removeClass();
		$("#code_snippet").text(text);
		$("#code_snippet").addClass($(this).val());
		$('#code_snippet').each(function(i, e) {hljs.highlightBlock(e)});
	});
	
});
