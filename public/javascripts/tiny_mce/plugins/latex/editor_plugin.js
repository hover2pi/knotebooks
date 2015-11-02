(function() {
  tinymce.create('tinymce.plugins.LatexPlugin', {
    init : function(ed, url) {
      // Register Commands
      ed.addCommand('mceLatex', function() {
        ed.windowManager.open({
					file : url + '/latex.html',
					width : 400 + parseInt(ed.getLang('latex.delta_width', 0)),
					height : 400 + parseInt(ed.getLang('latex.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
      });
      
      // Register Esc Keypress
      ed.onKeyDown.add(function(ed, e) {
        if (e.keyCode == 27) {
          // ed.execCommand("mceLatex", true);
          // If we don't have anything selected
          sel = ed.selection;
          d = ed.dom;
          if (sel.isCollapsed()) {
            // alert("Cursor Start: " + js_getCursorPosition(d).start + "\n" + 
            //       "Cursor End: "   + js_getCursorPosition(d).end);
            // This will turn the last word in the paragraph into a latex image,
            // but it moves the cursor to the beginning of the editor :(
            
            // inner = sel.getNode().innerHTML;
            // content = inner.reverse().match(/^([^<]+<)\s*([^>\s]+)(.*)/);
            // content.shift();
            // content[1] = latex(content[1].reverse(), true).reverse();
            // new_content = content.join('').reverse();
            // sel.select(sel.getNode());
            // ed.execCommand("mceReplaceContent", false, new_content);
            // moveCursorToEnd(ed.id);
          } else {
            // otherwise grab the selection

            inner_html = sel.getNode().innerHTML;
            
            // Get the three different versions of the selection and turn it into normal text
            text  = selection_sanitize(sel.getContent({format:'text'}));
            html  = selection_sanitize(sel.getContent({format:'html'}));
            inner = selection_sanitize(sel.getNode().innerHTML);
            
            if(text == inner && html == inner){
              ed.execCommand("mceReplaceContent", false, latex(text));
            } else {
              ed.execCommand("mceReplaceContent", false, latex(text, true));
            }
          }
          ed.execCommand("mceRepaint");
        }
      });
      
      // Register Buttons
      ed.addButton('latex', {
        title : 'Render LaTeX (Esc)',
        desc : 'LaTex Editor',
        image : '/images/LaTeX.png',
        cmd : 'mceLatex'
      });

			ed.onNodeChange.add(function(ed, cm, n) {
        cm.setActive('latex', n.className.match(/latex/));
			});

			ed.onClick.add(function(ed, e) {
				e = e.target;

				if (e.className.match(/latex/))
					ed.selection.select(e);
			});
		},

    getInfo : function() {
      return {
        longname : 'LaTeX Generator',
        author : 'Tom Clark',
        authorurl : 'http://knotebooks.com',
        infourl : 'http://knotebooks.github.com/mceLatex',
        version : 1
      };
    }
  });

  // Register Plugin
  tinymce.PluginManager.add('latex', tinymce.plugins.LatexPlugin);
})();

// ************************************************************************************************
// ************************************************************************************************
// ************************************************************************************************
// ************************************************************************************************

// function js_countTextAreaChars(text) {
//     var n = 0;
//     for (var i = 0; i < text.length; i++) {
//         if (text.charAt(i) != '\r') {
//             n++;
//         }
//     }
//     return n;
// }
// 
// function js_CursorPos(start, end) {
//     this.start = start;
//     this.end = end;
// }
// 
// function js_getCursorPosition(textArea) {
//     var start = 0;
//     var end = 0;
//     if (document.selection) { // IE...
//         textArea.focus();
//         var sel1 = document.selection.createRange();
//         var sel2 = sel1.duplicate();
//         sel2.moveToElementText(textArea);
//         var selText = sel1.text;
//         sel1.text = "01";
//         var index = sel2.text.indexOf("01");
//         start = js_countTextAreaChars((index == -1) ? sel2.text : sel2.text.substring(0, index));
//         end = js_countTextAreaChars(selText) + start;
//         sel1.moveStart('character', -1);
//         sel1.text = selText;
//     } else if (textArea.selectionStart || (textArea.selectionStart == "0")) { // Mozilla/Netscape...
//         start = textArea.selectionStart;
//         end = textArea.selectionEnd;
//     }
//     return new js_CursorPos(start, end);
// }
// 
// function js_setCursorPosition(textArea, cursorPos) {
//     if (document.selection) { // IE...
//         var sel = textArea.createTextRange();
//         sel.collapse(true);
//         sel.moveStart("character", cursorPos.start);
//         sel.moveEnd("character", cursorPos.end - cursorPos.start);
//         sel.select();
//     } else if (textArea.selectionStart || (textArea.selectionStart == "0")) { // Mozilla/Netscape...
//         textArea.selectionStart = cursorPos.start;
//         textArea.selectionEnd = cursorPos.end;
//     }
//     textArea.focus();
// }


if (typeof String.prototype.reverse!="function") {
   String.prototype.reverse=function() {
      var str=this.split(/.??/);
      for (var min=0,max=str.length-1; min<max; min++,max--) {
         var temp=str[min];
         str[min]=str[max];
         str[max]=temp;
      }
      return str.join('');
   }
}

function moveCursorToEnd(editor_id) {
    inst = tinyMCE.getInstanceById(editor_id);
    tinyMCE.execInstanceCommand(editor_id,"selectall", false, null);
    if (tinyMCE.isMSIE) {
        rng = inst.selection.getRng();
        rng.collapse(false);
        rng.select();
    }
    else {
        sel = inst.selection.getSel();
        sel.collapseToEnd();
    }
}

function selection_sanitize(text) {
  return text
    .replace(/<\/p>$/,   '')
    .replace(/<\/p>/g,   "\n")
    .replace(/\s+/g,     " ")
    .replace(/<[^>]+>/g, '')
    .replace(/&amp;/g,   '%26')
    .replace(/&/g,       '%26')
    .replace(/&gt;/g,    '>')
    .replace(/&lt;/g,    '<')
    .replace(/=/g,       '%3D')
    .replace(/\+/g,      '%2B');
    // .replace(/[^\\]{2}\n/g, '%0A');
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