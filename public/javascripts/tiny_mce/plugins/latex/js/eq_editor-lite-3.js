/* Copyright 2004-2009 CodeCogs */
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
    return '<img id="equationview" class="latex_inline" src="http://chart.apis.google.com/chart?cht=tx&chf=bg,s,FFFFFF00&chco=000000&chl=$' + text + '$" />';
    // return '<img class="latex_inline" src="http://latex.codecogs.com/png.latex?\\inline%20' + text + '" />';
  } else {
    // return '<img class="latex_center" src="/images/latex/' + text + '" />';
    return '<img id="equationview" class="latex_center" src="http://chart.apis.google.com/chart?cht=tx&chf=bg,s,FFFFFF00&chco=000000&chl=' + text + '" />';
    // return '<img class="latex_inline" src="http://latex.codecogs.com/png.latex?' + text + '" />';
  }
}
/*---- /equationeditor/js/eq_fck.js ----*/
var oEditor = window.opener;
var FCKEquation = null;
var eSelected = null;
function LoadSelected() {
    if (oEditor && typeof(oEditor.FCKEquation) != 'undefined') {
        FCKEquation = oEditor.FCKEquation;
        if (FCKEquation) eSelected = oEditor.FCKSelection.GetSelectedElement();
        else alert('Can not find FCK');
        if (eSelected && eSelected.tagName == 'IMG' && eSelected._fckequation) {
            var comm = unescape(eSelected._fckequation);
            var parts = comm.match(/(\\\[|\$)(.*?)(\\\]|\$)/);
            document.getElementById('src').value = parts[2];
            if (parts[1] == '[') document.getElementById('eqstyle2').checked = true;
            else document.getElementById('eqstyle1').checked = true;
            renderEqn(null);
        } else {
            document.getElementById('src').value = '';
            eSelected = null;
        }
    }
}

/*---- /equationeditor/js/eq_editor-1.js ----*/
var changed = false;
var orgtxt = '';
var EQUATION_ENGINE = 'http://www.google.com/chart?cht=tx&chl=';
var panellock = null;
var panelcount = 0;
var paneltimer = null;
var cctype = 'doxygen';
var cctarget = '';
var ccSID = 0;
function $(name) {
    return document.getElementById(name);
}
function opanel(id) {
    if (panellock == null) panellock = id;
    else {
        if (id == panellock && paneltimer != null) {
            clearTimeout(paneltimer);
            paneltimer = null;
        }
    }
    id.style.overflow = 'visible';
}
function cpaneldo() {
    if (panellock != null) {
        panellock.style.overflow = 'hidden';
        hidehover();
    }
    panellock = null;
}
function cpanel(id) {
    if (id == panellock || id === null) {
        if (paneltimer != null) clearTimeout(paneltimer);
        paneltimer = setTimeout('cpaneldo()', (id === null ? 200: 600));
    } else id.style.overflow = 'hidden';
}
function cleartext() {
    var id = $('src');
    id.value = "";
    id.focus();
    changed = false;
    if ($('copybutton')) $('copybutton').className = 'greybutton';
    if ($('renderbutton')) $('renderbutton').className = 'greybutton';
    $('equationview').src = 'images/spacer.gif';
}
function textchanged() {
    var txt = getEquationStr();
    if (txt != orgtxt) {
        orgtxt = txt;
        if ($('copybutton')) $('copybutton').className = 'lightbluebutton';
        if ($('renderbutton')) $('renderbutton').className = 'bluebutton';
        changed = true;
    }
}
function formatchanged() {
    var action = false;
    var format = $('format');
    if (format) {
        var type = format.value;
        switch (type) {
        case 'gif':
            action = false;
            break;
        case 'png':
            action = false;
            break;
        case 'pdf':
            action = true;
            break;
        case 'swf':
            action = true;
            break;
        }
    }
    $('dpi').disabled = action;
    $('dpi').readonly = action;
    changed = true;
    renderEqn();
}
function addText(wind, textbox, txt) {
    myField = wind.getElementById(textbox);
    if (wind.selection) {
        myField.focus();
        sel = wind.selection.createRange();
        sel.text = txt;
    } else {
        var scrolly = myField.scrollTop;
        if (myField.selectionStart || myField.selectionStart == '0') {
            var startPos = myField.selectionStart;
            var endPos = myField.selectionEnd;
            var cursorPos = startPos + txt.length;
            myField.value = myField.value.substring(0, startPos) + txt + myField.value.substring(endPos, myField.value.length);
            pos = txt.length + endPos - startPos;
            myField.selectionStart = cursorPos;
            myField.selectionEnd = cursorPos;
            myField.focus();
            myField.setSelectionRange(startPos + pos, startPos + pos);
        } else myField.value += txt;
        myField.scrollTop = scrolly;
    }
}
function insertText(txt, pos, inspos) {
    if (pos == 1000) {
        pos = txt.length - 1;
    }
    if (pos == null) {
        pos = txt.indexOf('{') + 1;
        if (pos <= 0) {
            txt += ' ';
            pos = txt.length;
        }
    }
    var insert_pos = (inspos == null) ? pos: inspos;
    var i;
    var startPos;
    myField = $('src');
    if (document.selection) {
        myField.focus();
        var sel = document.selection.createRange();
        i = myField.value.length + 1;
        theCaret = sel.duplicate();
        while (theCaret.parentElement() == myField && theCaret.move("character", 1) == 1)--i;
        startPos = i - myField.value.split("\n").length + 1;
        if ((txt.substring(1, 5) == "left" || insert_pos >= 0) && sel.text.length) {
            if (txt.substring(1, 5) == "left") ins_point = 7;
            else ins_point = insert_pos;
            if (insert_pos == null) pos = txt.length + sel.text.length + 1;
            else if (insert_pos < pos) pos += sel.text.length;
            sel.text = txt.substring(0, ins_point) + sel.text + txt.substr(ins_point);
        } else sel.text = txt;
        var range = myField.createTextRange();
        range.collapse(true);
        range.moveEnd('character', startPos + pos);
        range.moveStart('character', startPos + pos);
        range.select();
    } else {
        if (myField.selectionStart || myField.selectionStart == '0') {
            startPos = myField.selectionStart;
            var endPos = myField.selectionEnd;
            var cursorPos = startPos + txt.length;
            if ((txt.substring(1, 5) == "left" || insert_pos >= 0) && endPos > startPos) {
                if (txt.substring(1, 5) == "left") ins_point = 7;
                else ins_point = insert_pos;
                if (insert_pos == null) pos = txt.length + endPos - startPos + 1;
                else if (insert_pos < pos) pos += endPos - startPos;
                txt = txt.substring(0, ins_point) + myField.value.substring(startPos, endPos) + txt.substr(ins_point);
            }
            myField.value = myField.value.substring(0, startPos) + txt + myField.value.substring(endPos, myField.value.length);
            myField.selectionStart = cursorPos;
            myField.selectionEnd = cursorPos;
            myField.focus();
            myField.setSelectionRange(startPos + pos, startPos + pos);
        } else myField.value += txt;
    }
    textchanged();
    autorenderEqn(10);
    cpanel(null);
    myField.focus();
}
function getEquationStr() {
    var val = $('src').value;
    val = val.replace(/^\s+|\s+$/g, "");
    val = val.replace(/\s+/g, " ");
    var size = $('fontsize');
    if (size) {
        var txt = size.options[size.selectedIndex].value;
        if (txt !== '') val = txt + ' ' + val;
    }
    if ($('dpi')) {
        var dpi = $('dpi').value;
        if (dpi != '100') val = '\\' + dpi + 'dpi ' + val;
    }
    if ($('bg')) {
        var bg = $('bg').value;
        if (bg != 'transparent') val = '\\bg_' + bg + ' ' + val;
    }
    return val;
}
function exportEquation(type) {
    var format_index;
    var format;
    if ($('format')) {
        format_index = $('format').selectedIndex;
        format = $('format').options[format_index].value;
    } else {
        format_index = 0;
        format = 'gif';
    }
    if (type == 'phpBB') {
        text = getEquationStr();
        return ('[tex]' + text + '[/tex]\n');
    } else if (type == 'tw') {
        text = getEquationStr();
        text = text.replace(/\[/g, '%5B');
        text = text.replace(/\]/g, '%5D');
        return ('[img[' + EQUATION_ENGINE + text + ']]');
    } else if (type == 'html') {
        text = getEquationStr();
        return ('<a href="http://www.google.com/chart?cht=tx&chl=' + text.replace(/\+/g, '@plus;') + '" target="_blank"><img src="http://www.google.com/chart?cht=tx&chl=' + text + '" title="' + text + '" /></a>');
    } else if (type == 'url') {
        text = getEquationStr();
        text = text.replace(/\s/g, '&space;');
        text = text.replace(/\+/g, '&plus;');
        if (format != 'gif' && format != 'png') format = 'gif';
        return (EQUATION_ENGINE + text);
    } else if (type == 'pre') {
        text = $('src').value;
        size = $('fontsize');
        if (size && size.selectedIndex != 2) text = size.options[size.selectedIndex].value + ' ' + text;
        if ($('inline').checked) {
            if (!$('compressed').checked) text = '\\displaystyle ' + text;
            return ('<code xml:lang="latex">' + text + '</code> ');
        } else {
            if ($('compressed').checked) text = '\\inline ' + text;
            return ('<pre xml:lang="latex">' + text + '</pre>\n');
        }
    } else if (type == 'doxygen') {
        text = $('src').value;
        size = $('fontsize');
        if (size && size.selectedIndex != 2) text = size.options[size.selectedIndex].value + ' ' + text;
        if ($('inline').checked) {
            if (!$('compressed').checked) text = '\\displaystyle ' + text;
            text = '\\f$' + text + '\\f$ ';
        } else {
            if ($('compressed').checked) text = '\\inline ' + text;
            text = '\\f[' + text + '\\f]\n';
        }
    } else {
        text = $('src').value;
        size = $('fontsize');
        if (size && size.selectedIndex != 2) text = size.options[size.selectedIndex].value + ' ' + text;
        if ($('inline').checked) {
            if (!$('compressed').checked) text = '\\displaystyle ' + text;
            return ('$' + text + '$ ');
        } else {
            if ($('compressed').checked) text = '\\inline ' + text;
            return ('\\[' + text + '\\]\n');
        }
    }
    return text;
}
function renderEqn(callback) {
  $('equationview').replaceWith(latex(selection_sanitize($('src').val)));
  //   ed.selection.getNode();
  //   text = selection_sanitize(sel.getContent({format:'text'}));
  // ed.execCommand("mceReplaceContent", false, latex(text))
  // ed.execCommand('mceRepaint');
	
    // var val = $('src').value;
    // val = val.replace(/^\s+|\s+$/g, "");
    // if (val.length == 0)
    // return true;
    // var bracket = 0;
    // var i;
    // for (i = 0; i < val.length; i++) {
    //     switch (val.charAt(i)) {
    //     case '{':
    //         if (i == 0 || val[i - 1] != '\\') bracket++;
    //         break;
    //     case '}':
    //         if (i == 0 || val[i - 1] != '\\') bracket--;
    //         break;
    //     }
    // }
    // var div;
    // if (bracket == 0) {
    //     $('renderbutton').className = 'greybutton';
    //     val = $('src').value;
    //     var img = $('equationview');
    //     val = getEquationStr();
    //     sval = val.replace(/"/g, '\\"').replace(/\s/g, "&space;");
    //     var format_index;
    //     var format;
    //     if ($('format')) {
    //         format_index = $('format').selectedIndex;
    //         format = $('format').options[format_index].value;
    //     } else {
    //         format_index = 0;
    //         format = 'gif';
    //     }
    //     switch (format_index) {
    //     case 0:
    //     case 1:
    //         if (changed) {
    //             img.src = EQUATION_ENGINE + val;
    //             img.onclick = function() {
    //                 document.location.href = EQUATION_ENGINE + '/' + format + '.download?' + sval;
    //             }
    //         }
    //         break;
    //     case 2:
    //         if (changed) img.src = EQUATION_ENGINE + '/gif.latex?' + val;
    //         break;
    //     }
    // } else {
    //     div = $('equationcomment');
    //     if (bracket < 0) div.innerHTML = "<br/><span class=\"orange\">You have more <strong>closed '}' brackets</strong> than open '{' brackets</span>";
    //     else div.innerHTML = "<br/><span class=\"orange\">You have more <strong>open '{' brackets</strong> than closed '}' brackets</span>";
    // }
    // changed = false;
}
var auton = 0;
function renderCountdown() {
    if (auton > 0) {
        auton--;
        setTimeout('renderCountdown()', 100);
    } else renderEqn(null);
}
function autorenderEqn(n) {
    if ($('format')) format_index = $('format').selectedIndex;
    else format_index = 0;
    if (format_index < 3) {
        if (auton > 0 && n > 0) auton = n;
        else {
            auton = n;
            renderCountdown();
        }
    }
}
function addfavorite() {
    text = $('src').value;
    text = escape(text.replace(/\+/g, "@plus;"));
    if (text != '') {
        var head = document.getElementsByTagName("head")[0];
        var script = document.createElement("script");
        var d = new Date();
        script.src = 'http://latex.codecogs.com/favorite_json.php?sid=' + ccSID + '&add&rand=' + d.getTime() + '&eqn=' + text;
        head.appendChild(script);
        setTimeout('show_example(null, \'fav\')', 200);
    }
}
function deletefavorite(name) {
    var head = document.getElementsByTagName("head")[0];
    var script = document.createElement("script");
    var d = new Date();
    script.src = 'http://latex.codecogs.com/favorite_json.php?sid=' + ccSID + '&rand=' + d.getTime() + '&delete=' + name;
    head.appendChild(script);
    setTimeout('show_example(null, \'fav\')', 200);
}
function add_eq_history() {
    text = $('src').value;
    text = escape(text.replace(/\+/g, "@plus;"));
    var head = document.getElementsByTagName("head")[0];
    var script = document.createElement("script");
    var d = new Date();
    script.src = 'http://latex.codecogs.com/history_json.php?sid=' + ccSID + '&add' + '&rand=' + d.getTime() + '&eqn=' + text;
    head.appendChild(script);
}
function makeEquationsMatrix(type, isNumbered, isConditional) {
    if (isNumbered === undefined) isNumbered = false;
    if (isConditional === undefined) isNumbered = false;
    var eqns = "\\begin{" + type + ((isNumbered) ? "": "*") + "}";
    var eqi = "\n &" + ((isNumbered) ? " ": "= ") + ((isConditional) ? "\\text{ if } x= ": "");
    var eqEnd = "\n\\end{" + type + ((isNumbered) ? "": "*") + "}";
    var i = 0;
    var dim = prompt('Enter the number of lines:', '');
    if (dim != '' && dim !== null) {
        n = parseInt(dim);
        if (!isNaN(n)) {
            for (i = 1; i <= n - 1; i++) eqns = eqns + (eqi + "\\\\ ");
            eqns = (eqns + eqi) + eqEnd;
            insertText(eqns, type.length + ((isNumbered) ? 0: 1) + 9);
        }
    }
}
function makeArrayMatrix(type, start, end) {
    var matr = start + '\\begin{' + type + 'matrix}';
    var row = "\n";
    var mend = "\n\\end{" + type + "matrix}" + end;
    var i = 0;
    var dim = prompt('Enter the array dimensions separated by a comma (e.g. "2,3" for 2 rows and 3 columns):', '');
    if (dim !== '' && dim !== null) {
        dim = dim.split(',');
        m = parseInt(dim[0]);
        n = parseInt(dim[1]);
        if (!isNaN(m) && !isNaN(n)) {
            for (i = 2; i <= n; i++) row = row + ' & ';
            for (i = 1; i <= m - 1; i++) matr = matr + row + '\\\\ ';
            matr = matr + row + mend;
            insertText(matr, type.length + start.length + 15);
        }
    }
}
var hoverlock = false;
function hidehover() {
    if (!hoverlock) $('hover').style.display = 'none';
}
function hover(elm, e) {
    hoverlock = true;
    div = $('hover');
    if (window.XMLHttpRequest) div.innerHTML = '<img src="http://www.google.com/chart?cht=tx&chl=' + elm.alt + '"/>';
    else div.innerHTML = '<img src="http://www.google.com/chart?cht=tx&chl=' + elm.latex + '"/>';
    if (document.all) {
        div.style.top = (event.clientY - 10) + 'px';
        div.style.left = (event.clientX + 20) + 'px';
    } else {
        if (!e) e = window.event;
        div.style.top = (e.pageY - 10) + 'px';
        div.style.left = (e.pageX + 20) + 'px';
    }
    div.style.display = 'block';
    hoverlock = false;
    elm.onmouseout = hidehover;
}
function iObject() {
    this.i = 0;
    return this;
}
var myObject = new iObject();
var myObject2 = new iObject();
store_text = new Array();
store_text[0] = "";
function countclik(tag) {
    var x = tag.value;
    if (myObject.i == 0 || store_text[myObject.i] != x) {
        myObject.i++;
        var y = myObject.i;
        store_text[y] = x;
    }
    myObject2.i = 0;
    $('redobutton').src = "/images/buttons/redo-x.gif";
    $('undobutton').src = "/images/buttons/undo.gif";
}
function undo(box) {
    tag = $(box);
    if ((myObject2.i) < (myObject.i)) {
        myObject2.i++;
        if (myObject2.i == myObject.i) {
            $('undobutton').src = "/images/buttons/undo-x.gif";
        }
        $('redobutton').src = "/images/buttons/redo.gif";
    } else alert("Finish Undo Action");
    var z = store_text.length;
    z = z - myObject2.i;
    if (store_text[z]) {
        tag.value = store_text[z];
    } else {
        tag.value = store_text[0];
    }
    tag.focus();
}
function redo(box) {
    tag = $(box);
    if ((myObject2.i) > 1) {
        myObject2.i--;
        if (myObject2.i == 1) {
            $('redobutton').src = "/images/buttons/redo-x.gif";
        }
        $('undobutton').src = "/images/buttons/undo.gif";
    } else alert("Finish Redo Action");
    var z = store_text.length;
    z = z - myObject2.i;
    if (store_text[z]) tag.value = store_text[z];
    else tag.value = store_text[0];
    tag.focus();
}
function updateOpener(target, type) {
    var text;
    var size;
    if (target !== '') {
        text = exportEquation(type);
        addText(window.opener.document, target, text);
    } else {
        text = $('src').value;
        size = $('fontsize');
        if (size && size.selectedIndex != 2) text = size.options[size.selectedIndex].value + ' ' + text;
        if (text.length == 0) {
            alert(FCKLang.EquationErrNoEqn);
            return false;
        }
        if ($('inline').checked) {
            if (!$('compressed').checked) text = '\\displaystyle ' + text;
            text = '$' + text + '$ ';
        } else {
            if ($('compressed').checked) text = '\\inline ' + text;
            text = '\\[' + text + '\\]\n';
        }
        if (eSelected && eSelected._fckequation == text) return true;
        FCKEquation.Add(text);
    }
    add_eq_history();
    hide_example();
    window.blur();
    return true;
}
var gallery;
var lastbutton = null;
function show_example(button, group) {
    $('bar1').style.display = 'none';
    $('bar2').style.display = 'block';
    var div = $('photos');
    div.innerHTML = '';
    if (button !== null) {
        if (lastbutton !== null) lastbutton.className = 'lightbluebutton';
        button.className = 'greybutton';
        lastbutton = button;
    }
    gallery = new Scroll();
    if (group == 'fav' || group == 'history') {
        var d = new Date();
        gallery.init('photos', 'leftarrow', 'rightarrow', 'overview', 'http://latex.codecogs.com/example_json.php?fn=gallery&rand=' + d.getTime() + '&sid=' + ccSID);
    } else gallery.init('photos', 'leftarrow', 'rightarrow', 'overview', 'http://latex.codecogs.com/example_json.php?fn=gallery');
    gallery.visible_num = 1;
    gallery.new_offset = 5;
    gallery.maxpanels = 1;
    gallery.set_width(600, 100, 60);
    gallery.set_subtext('&type=' + group);
    gallery.add_panel();
    gallery.setarrow();
    gallery.setoverview();
}
function hide_example() {
    $('bar2').style.display = 'none';
    $('bar1').style.display = 'block';
    if (lastbutton !== null) lastbutton.className = 'lightbluebutton';
    lastbutton = null;
}
function keyHandler(e) {
    var TABKEY = 9;
    if (e.keyCode == TABKEY) {
        if (document.selection) {
            var sel = document.selection.createRange();
            var inp = $('src');
            i = inp.value.length + 1;
            theCaret = sel.duplicate();
            while (theCaret.parentElement() == myField && theCaret.move("character", 1) == 1)--i;
            startPos = i - inp.value.split("\n").length + 1;
            if (startPos == inp.value.length) return true;
            pos = inp.value.indexOf('{', startPos);
            if (pos == -1) pos = inp.value.length;
            else pos++;
            var range = inp.createTextRange();
            range.collapse(true);
            range.moveEnd('character', pos);
            range.moveStart('character', pos);
            range.select();
        } else {
            startPos = this.selectionStart;
            if (startPos == this.value.length) return true;
            pos = this.value.indexOf('{', startPos);
            if (pos == -1) pos = this.value.length;
            else pos++;
            this.setSelectionRange(pos, pos);
        }
        if (e.preventDefault) e.preventDefault();
        return false;
    }
}
function jsGet(type) {
    if (location.href.match(type + '=')) {
        return location.href.split(type + '=')[1].split('&')[0];
    }
}
function isGet(type) {
    if (location.href.indexOf('?') > 0) {
        var val = location.href.split('?')[1];
        var a = val.indexOf(type);
        return (a >= 0 && (a == 0 || val[a - 1] == '&'));
    }
    return false;
}
function editor_init(SID, target, type, initlatex) {
    var areas = document.getElementsByTagName('area');
    for (i = 0; i < areas.length; i++) areas[i].onmouseover = function(e) {
        hover(this, e);
    };
    if (!window.XMLHttpRequest) {
        for (i = 0; i < areas.length; i++) {
            areas[i].latex = areas[i].alt;
            areas[i].alt = '';
        }
    }
    ccSID = SID;
    var myInput = $('src');
    if (myInput.addEventListener) myInput.addEventListener('keydown', this.keyHandler, false);
    else if (myInput.attachEvent) myInput.attachEvent('onkeydown', this.keyHandler);
    if (target === undefined || target === null) {
        if (isGet('target')) cctarget = jsGet('target');
        else cctarget = '';
    } else cctarget = target;
    if (type === undefined) {
        if (isGet('type')) cctype = jsGet('type');
        else cctype = 'latex';
    } else cctype = type;
    var latex;
    if (initlatex === undefined) {
        if (isGet('latex')) {
            latex = unescape(jsGet('latex'));
            latex = latex.replace(/@plus;/, '+');
            latex = latex.replace(/&plus;/, '+');
            $('src').value = latex;
            renderEqn(null);
        } else LoadSelected();
    } else {
        latex = unescape(initlatex);
        latex = latex.replace(/@plus;/, '+');
        latex = latex.replace(/&plus;/, '+');
        $('src').value = latex;
    }
    $('src').focus();
}

/*---- /scroll/js/scroll-1.1.js ----*/
var oDiv = document.createElement('div');
var oImg = document.createElement('img');
var Scroll = function() {};
Scroll.prototype =
{
    init: function(maindiv, leftarrow, rightarrow, overview, newpanel_php) {
        this.panels = 0;
        this.maxpanels = 0;
        this.speed = 10;
        this.pause = 2;
        this.visible = 0;
        this.visible_num = 2;
        this.layers = new Array();
        this.layers_offset = new Array();
        this.new_offset = 0;
        this.subtext = '';
        this.vertical = false;
        this.left_arrow = document.getElementById(leftarrow);
        this.right_arrow = document.getElementById(rightarrow);
        this.maindiv = document.getElementById(maindiv);
        if (overview !== '') this.overview = document.getElementById(overview);
        else this.overview = null;
        if (newpanel_php.indexOf('_json') > -1) {
            this.ajax_php = null;
            this.json_php = newpanel_php;
            this.ajax_response_fn = null;
        } else {
            this.ajax_php = newpanel_php;
            this.json_php = null;
            var obj = this;
            this.ajax_response_fn = function() {
                obj.add_panel_response();
            };
        }
    },
    set_subtext: function(text) {
        this.subtext = text;
    },
    set_width: function(width, height, speed) {
        this.width = width;
        this.height = height;
        this.speed = speed;
        if (this.vertical) this.step = this.step_total = this.height / this.speed;
        else this.step = this.step_total = this.width / this.speed;
    },
    add: function(layer) {
        var offset = this.new_offset;
        if (this.vertical) this.new_offset += this.height;
        else this.new_offset += this.width;
        this.layers[this.panels] = layer;
        this.layers_offset[this.panels] = offset;
        this.panels++;
        if (this.panels > this.maxpanels) this.maxpanels = this.panels;
        layer.style.position = 'absolute';
        if (this.vertical) layer.style.top = offset + 'px';
        else layer.style.left = offset + 'px';
    },
    add_id: function(layer_id) {
        var lyr = document.getElementById(layer_id);
        if (lyr) this.add(lyr);
    },
    add_panel_div: function(newdiv) {
        this.add(newdiv);
        this.maindiv.appendChild(newdiv);
        if (this.visible + this.visible_num >= this.panels) this.add_panel();
    },
    add_panel_response: function() {
        if (req.readyState == 4) {
            if (req.status == 200 && req.responseText.length > 0) {
                var newdiv = oDiv.cloneNode(false);
                newdiv.innerHTML = req.responseText;
                this.add_panel_div(newdiv);
            }
            this.setarrow();
            this.setoverview();
        }
    },
    add_panel_json: function(info) {
        if (info.length > 0) {
            var newdiv = oDiv.cloneNode(false);
            newdiv.innerHTML = info;
            this.add_panel_div(newdiv);
        }
        this.setarrow();
        this.setoverview();
    },
    add_panel: function() {
        if (this.ajax_php && this.ajax_response_fn) {
            if (this.ajax_php.indexOf("?") == -1) loadXMLDoc(this.ajax_php + '?panel=' + this.panels + this.subtext, this.ajax_response_fn);
            else loadXMLDoc(this.ajax_php + '&panel=' + this.panels + this.subtext, this.ajax_response_fn);
        } else if (this.json_php) {
            var a = this.panels;
            var head = document.getElementsByTagName("head")[0];
            var script = document.createElement("script");
            if (this.json_php.indexOf("?") == -1) script.src = this.json_php + '?panel=' + a + this.subtext;
            else script.src = this.json_php + '&panel=' + a + this.subtext;
            head.appendChild(script);
        }
    },
    redraw: function() {
        if (this.json_php || (this.ajax_php && this.ajax_response_fn)) {
            this.panels = 0;
            this.visible = 0;
            this.new_offset = 0;
            while (this.maindiv.firstChild) {
                this.maindiv.removeChild(this.maindiv.firstChild);
            }
        }
        if (this.ajax_php && this.ajax_response_fn) {
            var obj = this;
            if (this.ajax_php.indexOf("?") == -1) loadXMLDoc(obj.ajax_php + '?panel=' + this.panels + this.subtext, obj.ajax_response_fn);
            else loadXMLDoc(obj.ajax_php + '&panel=' + this.panels + this.subtext, obj.ajax_response_fn);
        } else if (this.json_php) {
            var a = this.panels;
            var head = document.getElementsByTagName("head")[0];
            var script = document.createElement("script");
            if (this.json_php.indexOf("?") == -1) script.src = this.json_php + '?panel=' + a + this.subtext;
            else script.src = this.json_php + '&panel=' + a + this.subtext;
            head.appendChild(script);
        }
    },
    move: function(dx) {
        this.new_offset += dx;
        for (var p = 0; p < this.panels; p++) {
            this.layers_offset[p] += dx;
            if (this.vertical) this.layers[p].style.top = this.layers_offset[p] + 'px';
            else this.layers[p].style.left = this.layers_offset[p] + 'px';
        }
        this.step++;
        if (this.step < this.step_total) {
            var obj = this;
            window.setTimeout(function() {
                obj.move(dx);
            },
            this.pause);
        }
    },
    setoverview: function() {
        if (this.overview !== null) {
            this.overview.innerHTML = '';
            var txt = '';
            var obj = this;
            for (i = 0; i < this.maxpanels; i++) {
                newimg = oImg.cloneNode(false);
                newimg.className = 'overview';
                if (i >= this.visible && i < (this.visible + this.visible_num)) newimg.src = "http://www.codecogs.com/images/scroll/soliddot.gif";
                else {
                    newimg.src = "http://www.codecogs.com/images/scroll/emptydot.gif";
                    newimg.i = i;
                    newimg.onclick = function() {
                        obj.jump(this);
                    };
                }
                this.overview.appendChild(newimg);
            }
        }
    },
    setarrow: function() {
        this.left_arrow.src = 'http://www.codecogs.com/images/scroll/' + (this.visible <= 0 ? 'leftarrow_grey.gif': 'leftarrow.gif');
        this.right_arrow.src = 'http://www.codecogs.com/images/scroll/' + (this.visible >= (this.panels - 1) ? 'rightarrow_grey.gif': 'rightarrow.gif');
    },
    jump: function(obj) {
        if (this.step == this.step_total) {
            panel = obj.i;
            var gap = panel - this.visible;
            this.step = this.step_total - Math.abs(gap) * this.step_total;
            if (this.visible > panel) this.move(this.speed);
            else this.move( - this.speed);
            this.visible += gap;
            if (this.visible + this.visible_num >= this.panels) this.add_panel();
            else {
                this.setarrow();
                this.setoverview();
            }
        }
    },
    left: function() {
        if (this.step == this.step_total) {
            if (this.visible < (this.panels - 1)) {
                this.visible++;
                this.step = 0;
                this.move( - this.speed);
                if (this.visible + this.visible_num >= this.panels) this.add_panel();
                else {
                    this.setarrow();
                    this.setoverview();
                }
            }
        }
    },
    right: function() {
        if (this.step == this.step_total) {
            if (this.visible > 0) {
                this.step = 0;
                this.move(this.speed);
                this.visible--;
                this.setarrow();
                this.setoverview();
            }
        }
    },
    subsearch: function(text) {
        if (text !== '') this.subtext = ('&subtext=' + text);
        else this.subtext = '';
        this.redraw();
    }
};