function pasteSelection() {
  chrome.tabs.getSelected(null, function(tab) {
    chrome.tabs.sendRequest(tab.id, {method: "getSelection"}, function (response) {
      var text = document.getElementById('textData'); 
      text.innerHTML = response.data;
    });
  });
}
pasteSelection();

document.addEventListener('DOMContentLoaded', function () {
  document.querySelector('button[id="btn-create"]').addEventListener('click', newSnippet);
  document.querySelector('button[id="back"]').addEventListener('click', resetForm);
});

function sendData(text, lang)
{
	var http = new XMLHttpRequest();
	http.open("POST", "http://vault.somecode.me/sendData", true);
	
	var params = "code=" + encodeURIComponent(text) + 
	             "&lang=" + lang;

	http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");	
	http.send(params);

	http.onreadystatechange = function() {
		if(http.readyState == 4 && http.status == 200) {
			var resp = JSON.parse(http.responseText);
			$("#btn-create").button('reset');
			if (resp.result=="-1") {
				$("#error").show();
			} else {
				$("#error").hide();
				$("#paste_area").hide();
				$("#result_area").show();
				$("#embed_code").text('<div class="codevault-snippet" data="'+resp.result+'"></div><'+'script'+' src="http://vault.somecode.me/static/js/snippetm.js"><'+'/'+'script>');
				$("#codevault_link").html('Codevault link: <a target="_blank" href="http://cdv.lt/'+resp.result+'">http://cdv.lt/'+resp.result+'</a>');
			}
		}
	}
}

function resetForm()
{
	$("#error").hide();
	$("#result_area").hide();
	$("#paste_area").show();
	$("#textData").val('');
}

function newSnippet() {
	var snippetText = document.getElementById('textData').value;
	var snippetType = document.getElementById('lang_list').value;
	
	if (snippetText.length > 0) {
		$("#btn-create").button('loading');
		sendData(snippetText, snippetType);
	}
}