var LaTeXDialog = {
	init : function(ed) {
		var dom = ed.dom, f = document.forms[0], nl = f.elements, n = ed.selection.getNode(), w;
		if (n.nodeName == 'IMG' && n.className.match(/latex/)) {
		  src = dom.getAttrib(n, 'src');
			src = src.substring(76, src.length);
			if (src.match(/^\$.*\$$/)) {
			  nl.src.value = src = src.substring(1, src.length - 1);
			  nl.compressed.checked = 1;
			} else {
			  nl.compressed.checked = 0;
		  }
		  nl.src.value = unescape(src);
		}
		w = dom.getAttrib(n, 'src');
    // f.width.value = w ? parseInt(w) : (dom.getStyle('width') || '');
    // f.size.value = dom.getAttrib(n, 'size') || parseInt(dom.getStyle('height')) || '';
    // f.noshade.checked = !!dom.getAttrib(n, 'noshade') || !!dom.getStyle('border-width');
    // selectByValue(f, 'width2', w.indexOf('%') != -1 ? '%' : 'px');
	},

	update : function() {
		var ed = tinyMCEPopup.editor, h, f = document.forms[0], st = '';

		if (f.src.value === '') {
			if (ed.selection.getNode().nodeName == 'IMG') {
				ed.selection.getNode();
        text = selection_sanitize(sel.getContent({format:'text'}));
				ed.execCommand("mceReplaceContent", false, latex(text))
				ed.execCommand('mceRepaint');
			}

			tinyMCEPopup.close();
			return;
		}
	}
};

tinyMCEPopup.requireLangPack();
tinyMCEPopup.onInit.add(LaTeXDialog.init, LaTeXDialog);

function selection_sanitize(text) {
  return text.replace(/<\/p>$/,      '')
    .replace(/<\/p>/g,      "\n")
    .replace(/\s+/g,        " ")
    .replace(/<[^>]+>/g,    '')
    .replace(/&amp;/g,      '%26')
    .replace(/&/g,          '%26')
    .replace(/&gt;/g,       '>')
    .replace(/&lt;/g,       '<')
    .replace(/=/g,          '%3D')
    .replace(/[^\\]{2}\n/g, '%0A');
}

function latex(text, inline) {
  // text = encodeURIComponent(text);
  if (inline) {
    // return '<img class="latex_inline" src="/images/latex/inline/' + text + '" />';
    return '<img class="latex_inline" src="http://chart.apis.google.com/chart?cht=tx&chf=bg,s,FFFFFF00&chco=000000&chl=$' + text + '$" />';
    // return '<img class="latex_inline" src="http://latex.codecogs.com/png.latex?\\inline%20' + text + '" />';
  } else {
    // return '<img class="latex_center" src="/images/latex/' + text + '" />';
    return '<img class="latex_center" src="http://chart.apis.google.com/chart?cht=tx&chf=bg,s,FFFFFF00&chco=000000&chl=' + text + '" />';
    // return '<img class="latex_inline" src="http://latex.codecogs.com/png.latex?' + text + '" />';
  }
}