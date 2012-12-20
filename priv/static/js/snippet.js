function loadScript(url, callback)
{
    // adding the script tag to the head as suggested before
   var head = document.getElementsByTagName('head')[0];
   var script = document.createElement('script');
   script.type = 'text/javascript';
   script.src = url;

   // then bind the event to the callback function 
   // there are several events for cross browser compatibility
   script.onreadystatechange = callback;
   script.onload = callback;

   // fire the loading
   head.appendChild(script);
}

getElementsByClass = function(node, searchClass, tag) {
	var classElements = [];
	node = node || document;
	tag = tag || '*';
	var tagElements = node.getElementsByTagName(tag);
	var regex = new RegExp("(^|\\s)" + searchClass + "(\\s|$)");
	for (var i=0, j=0; i < tagElements.length; i++) {
		if (regex.test(tagElements[i].className)) {
			classElements[j] = tagElements[i];
			j++;
		}
	}
	return classElements;
};

htmlQuote = function (newValue, param) {
	newValue = newValue.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;")
	param = param || {};
	if(!param.title)
		newValue = newValue.replace(/ /,"&nbsp;");
	if(param.attribute)
		newValue = newValue.replace(/"/g,"&quot;");
	return newValue;
}

isChrome = function() {
	return (navigator.userAgent.toLowerCase().indexOf('chrome') != -1);
}

addCss = function(cssCode, name, content) {
	var doc = content || document;
	if(name) {
		name = "js-" + name + "-css";
		if (doc.getElementById(name)) return;
	}
	var se = doc.createElement("style");
	se.type = "text/css";
	if(name) se.id = name;
	if (se.styleSheet) se.styleSheet.cssText = cssCode;
	else se.appendChild(doc.createTextNode(cssCode));
	var hd = doc.getElementsByTagName("head");
	if(hd && hd[0]) hd[0].appendChild(se);
	else if (isChrome()) {
		doc.body.insertBefore(se, doc.body.firstChild);
	} else doc.write('<style>'+cssCode+'</style>');
}

var JSONP = (function(){
	var counter = 0, head, query, key, window = this, config = {};
	function load(url) {
		var script = document.createElement('script'),
			done = false;
		script.src = url;
		script.async = true;
 
		script.onload = script.onreadystatechange = function() {
			if ( !done && (!this.readyState || this.readyState === "loaded" || this.readyState === "complete") ) {
				done = true;
				script.onload = script.onreadystatechange = null;
				if ( script && script.parentNode ) {
					script.parentNode.removeChild( script );
				}
			}
		};
		if ( !head ) {
			head = document.getElementsByTagName('head')[0];
		}
		head.appendChild( script );
	}
	function encode(str) {
		return encodeURIComponent(str);
	}
	function jsonp(url, params, callback, callbackName) {
		query = (url||'').indexOf('?') === -1 ? '?' : '&';
		params = params || {};
		for ( key in params ) {
			if ( params.hasOwnProperty(key) ) {
				query += encode(key) + "=" + encode(params[key]) + "&";
			}
		}
		var jsonp = "json" + (++counter);
		window[ jsonp ] = function(data){
			callback(data);
			try {
				delete window[ jsonp ];
			} catch (e) {}
			window[ jsonp ] = null;
		};
 
		load(url + query + (callbackName||config['callbackName']||'callback') + '=' + jsonp);
		return jsonp;
	}
	function setDefaults(obj){
		config = obj;
	}
	return {
		get:jsonp,
		init:setDefaults
	};
}());

var injectCode = function() {
	
	addCss(
	".credits a {font-size: 12px; font-family: Menlo, Monaco, Consolas, \"Courier New\", monospace;" +
	" display: block; padding: 0.5em; background-color: transparent; color: #bc221f; width: 148px; position:absolute; right: 20px; top: 20px; }" +	
	"code,	pre {	  padding: 0 3px 2px;	  font-family: Menlo, Monaco, Consolas, \"Courier New\", monospace;" +
	"font-size: 12px;	  color: #333333;	  -webkit-border-radius: 3px;	     -moz-border-radius: 3px;	          border-radius: 3px;	}" +
	"code {	  padding: 2px 4px;	  color: #d14;	  background-color: #f7f7f9;	  border: 1px solid #e1e1e8;	}" +
	"pre {	  display: block;	  padding: 8.5px;	  margin: 0 0 9px;	  font-size: 12.025px;	  line-height: 18px;	  word-break: break-all;" +
	"word-wrap: break-word;	  white-space: pre;	  white-space: pre-wrap;	  background-color: #f5f5f5;	  border: 1px solid #ccc;" +
	"border: 1px solid rgba(0, 0, 0, 0.15);	  -webkit-border-radius: 4px;	     -moz-border-radius: 4px;	          border-radius: 4px;	}" +
	"pre.prettyprint { 	  margin-bottom: 18px;	}" +
	"pre code {	  padding: 0;	  color: inherit;	  background-color: transparent;	  border: 0;	}" +
	".pre-scrollable {	  max-height: 340px;	  overflow-y: scroll;	}	" +
			
	"pre code { display: block; padding: 0.5em; background: #002b36; color: #839496; }" +
	" pre .comment, pre .template_comment, pre .diff .header, pre .doctype, pre .pi, pre .lisp .string," +
	" pre .javadoc { color: #586e75; font-style: italic; }" +
	"pre .keyword,	pre .winutils,	pre .method, pre .addition,	pre .css .tag,	pre .request,	"+
	"pre .status,	pre .nginx .title {	  color: #859900;	}" +
	"pre .number,	pre .command,	pre .string,	pre .tag .value,	pre .phpdoc,	pre .tex .formula,"+
	"pre .regexp,	pre .hexcolor {	  color: #2aa198;	}" +
	"pre .title,	pre .localvars,	pre .chunk,	pre .decorator,	pre .builtin,	pre .built_in,	pre .identifier," +
	"pre .title .keymethods,	pre .vhdl .literal,	pre .id {	  color: #268bd2;	}" +
	"pre .attribute,	pre .variable,	pre .instancevar,	pre .lisp .body,	pre .smalltalk .number,	pre .constant," +
	"pre .class .title,	pre .parent,	pre .haskell .type {	  color: #b58900;	}" +
	"pre .preprocessor,	pre .preprocessor .keyword,	pre .shebang,	pre .symbol,	pre .diff .change,	pre .special," +
	"pre .keymethods,	pre .attr_selector,	pre .important,	pre .subst,	pre .cdata {	  color: #cb4b16;	}" +
	"pre .deletion {	  color: #dc322f;	}	pre .tex .formula {	  background: #073642;	}" 
	);
	
	var div = getElementsByClass(document, "codevault-snippet");
	
	for (var i=0; i< div.length; i++) {
		
		var current_div = div[i];
		var id = current_div.getAttribute('data');
		
		JSONP.get( 'http://cdv.lt/getData', {sn:id}, function(data){			
			highlighter(data);
		});
	}
	
	function hasClass(ele,cls) {
		return ele.className.match(new RegExp('(\\s|^)'+cls+'(\\s|$)'));
	}
	
	function highlighter(data)
	{
		for (var i=0; i< div.length; i++) {
			var current_div = div[i];
			var id = current_div.getAttribute('data');
			
			if (id==data.request && !hasClass(current_div, "already")) {
				current_div.className += " " + data.language;

				var parent = current_div.parentNode;

				var elDiv = document.createElement('div');
				elDiv.setAttribute('class', 'credits');

				var elA = document.createElement('a');
				elA.setAttribute('href', 'http://cdv.lt/'+id);
				elA.innerHTML = "powered by Code Vault";

				elDiv.appendChild(elA);

				console.log(elDiv);

				parent.insertBefore(elDiv, current_div);

				if(data.language)
					current_div.innerHTML = "<pre><code class=\""+data.language+"\">"+htmlQuote(data.code_record)+"</code></pre>";
				else
					current_div.innerHTML = "<pre><code>"+htmlQuote(data.code_record)+"</code></pre>";
				hljs.highlightBlock(current_div, null, false);		

				current_div.className += " already";
			}
		}
	}

};

loadScript("http://cdv.lt/static/js/highlight.pack.js", injectCode);