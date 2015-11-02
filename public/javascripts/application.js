var knotebooks = {
  setupAjax: function(){
    $.ajaxSetup({ beforeSend: function(xhr){ xhr.setRequestHeader("Accept", "text/javascript"); } });
  },
  
  setupAjaxCallbacks: function () {
    knotebooks.status = $('#ajax-message');
    $('#ajax-status').ajaxStart(function() {
      $(this).show();
    }).ajaxStop(function(){
      $(this).fadeOut();
    }).ajaxError(function (event, xhr, ajaxOptions, thrownError) {
      // if (xhr.status === 401) {
      //   if ($("#login").is(":hidden")) {
      //     app.showLoginForm();
      //   }
        alert("Sorry, " + xhr.responseText.toLowerCase());
      //   // Focus cursor on field after showing alert.
      //   $("#login").find("input[type='text']:first").focus();
      // }
      console.log("XHR Response: " + JSON.stringify(xhr));
    });
  },
  
  character_counter: function(el, max) {
    var el = el, max = max;
    return {
      increment: function(e) {
        el.text(max - e.value.length);
        if (e.value.length > max) {
          el.addClass('over');
        } else {
          el.removeClass('over');
        }
      }
    }
  },
  
  setupKnotes: function(){
    $('.knote').each(function(i){
      var knote = $(this);
      knote.wrap('<div class="coda-slider-wrapper"><div class="coda-slider" id="coda-slider-' + (i + 1) + '"><div class="panel-container"><div class="panel"><div class="panel-wrapper"/></div></div></div></div>');
      var wrapper = knote.parents('.knote-slider-wrapper');
      // knote.after(knote.clone());
    });
    
    // $(".coda-slider-wrapper").each(function(){
    //   var slider = $(this);
    //   
    //      var panelWidth = slider.find(".panel").width();
    //      var panelCount = slider.find(".panel").size();
    //      var panelContainerWidth = panelWidth * panelCount;
    // 
    //      // Specify the width of the container div (wide enough for all knotes to be lined up end-to-end)
    //      $(".panel-container", slider).css({ width: panelContainerWidth });
    // 
    //      // Specify the current knote.
    //      var currentPanel = 1;
    // 
    //      function easier() {
    //        if (slider.index()) {
    //          offset = - (panelWidth*(panelCount - 1));
    //          alterPanelHeight(panelCount - 1);
    //          currentPanel = panelCount;
    //        } else {
    //          currentKnote -= 1;
    //          alterKnoteHeight(currentKnote - 1);
    //          offset = - (knoteWidth*(currentKnote - 1));
    //        };
    //        $('.knote-container', slider).animate({ marginLeft: offset }, settings.slideEaseDuration, settings.slideEaseFunction);
    //        return false;
    //      };
    // 
    //      function harder() {
    //        if (currentKnote == knoteCount) {
    //          offset = 0;
    //          currentKnote = 1;
    //          alterKnoteHeight(0);
    //        } else {
    //          offset = - (knoteWidth*currentKnote);
    //          alterKnoteHeight(currentKnote);
    //          currentKnote += 1;
    //        };
    //        $('.knote-container', slider).animate({ marginLeft: offset }, settings.slideEaseDuration, settings.slideEaseFunction);
    //        if (settings.crossLinking) { location.hash = currentKnote }; // Change the URL hash (cross-linking)
    //        return false;
    //      };
    // 
    //      // Set the height of the first knote
    //      if (settings.autoHeight) {
    //        knoteHeight = $('.knote:eq(' + (currentKnote - 1) + ')', slider).height();
    //        slider.css({ height: knoteHeight });
    //      };
    // 
    //      function alterKnoteHeight(x) {
    //        if (settings.autoHeight) {
    //          knoteHeight = $('.knote:eq(' + x + ')', slider).height()
    //          slider.animate({ height: knoteHeight }, settings.autoHeightEaseDuration, settings.autoHeightEaseFunction);
    //        };
    //      };
    // 
    //      sliderCount++;
    //   
    //   wrapper.find('a.restore, a.harder_knote, a.easier_knote').live('click', function(){
    //     if ($(this).hasClass('restore')) {
    //       alert('Trying to restore?');
    //       return false;
    //     } else {
    //       alert('Trying to swap?');
    //       return false;
    //     }
    //   })
    // });
  },
  
  unload_tinymce: function(el){
    el = (typeof(el) == "object") ? el.attr('id') : el;
    
    if(typeof(window.tinyMCE) != "undefined") {
      window.tinyMCE.execCommand('mceRemoveControl', false, el);
    }
  },
  
  load_tinymce: function(el) {
    el = (typeof(el) == "object") ? el.attr('id') : el;
    
    if(typeof(window.tinyMCE) != "undefined") {
      window.tinyMCE.execCommand('mceAddControl', false, el)
    } else {
      $("#" + el).tinymce({
        script_url: '/javascripts/tiny_mce/tiny_mce.js',
        // editor_selector : 'RTE',
        // mode : 'none',
        plugins : "safari,media,spellchecker,table,save,fullscreen,iespell,paste,contextmenu,latex",
        // spellchecker_rpc_url : '/lessons/spellchecker',
        theme : 'advanced',
        theme_advanced_buttons1 : 'undo,|,bold,italic,underline,|,pasteword,bullist,numlist,image,table,|,link,unlink,|,latex,|,fullscreen',
        theme_advanced_buttons2 : '',
        theme_advanced_buttons3 : '',
        theme_advanced_resize_horizontal : false,
        theme_advanced_resizing : true,
        theme_advanced_statusbar_location : 'bottom',
        theme_advanced_toolbar_align : 'left',
        theme_advanced_toolbar_location : 'top',
        valid_elements : '@[id|class|style|title|dir<ltr?rtl|lang|xml::lang],a[rel|rev|charset|hreflang|accesskey|type|name|href|target|title|class|onfocus|onblur],strong/b,em/i,strike,u,#p[align],-ol[type|compact],-ul[type|compact],-li,br,img[longdesc|usemap|src|border|alt=|title|hspace|vspace|width|height|align],-sub,-sup,-blockquote,-table[border=0|cellspacing|cellpadding|width|frame|rules|height|align|summary|bgcolor|background|bordercolor],-tr[rowspan|width|height|align|valign|bgcolor|background|bordercolor],tbody,thead,tfoot,#td[colspan|rowspan|width|height|align|valign|bgcolor|background|bordercolor|scope],#th[colspan|rowspan|width|height|align|valign|scope],caption,-div,-span,-code,-pre,address,-h1,-h2,-h3,-h4,-h5,-h6,hr[size|noshade],dd,dl,dt,cite,abbr,acronym,del[datetime|cite],ins[datetime|cite],map[name],area[shape|coords|href|alt|target],bdo,col[align|char|charoff|span|valign|width],colgroup[align|char|charoff|span|valign|width],dfn,kbd,q[cite],samp,small,tt,var,big'
      });
    }
  }
};

/*!
 * jQuery serializeObject - v0.2 - 1/20/2010
 * http://benalman.com/projects/jquery-misc-plugins/
 * 
 * Copyright (c) 2010 "Cowboy" Ben Alman
 * Dual licensed under the MIT and GPL licenses.
 * http://benalman.com/about/license/
 */

// Whereas .serializeArray() serializes a form into an array, .serializeObject()
// serializes a form into an (arguably more useful) object.

(function($,undefined){
  '$:nomunge'; // Used by YUI compressor.
  
  $.fn.serializeObject = function(){
    var obj = {};
    
    $.each( this.serializeArray(), function(i,o){
      var n = o.name,
        v = o.value;
        
        obj[n] = obj[n] === undefined ? v
          : $.isArray( obj[n] ) ? obj[n].concat( v )
          : [ obj[n], v ];
    });
    
    return obj;
  };
  
})(jQuery);


jQuery.fn.submitWithAjax = function(o) {
  knotebooks.status.text("Loading ...");
  var o = o || {};
  this.submit(function(){
    $.post($(this).attr('action'), $.extend({}, $(this).serializeObject(), o), null, "script");
    return false;
  });
  return this;
};

$(function() {
  knotebooks.setupAjax();
  knotebooks.setupAjaxCallbacks();
  // knotebooks.setupKnotes();
  
  // $("#error").animate({ backgroundColor : "#eeeeee" }, 3000, "easeInQuart", function(){
  //   $("#error div.peek-a-boo").hide("blind", {easing: "linear"}, 1500);
  // });
  
  $('.ajax').live('click', function(){
    knotebooks.status.text("Loading ...");
    var href = this.tagname == 'a' ? this.href : $(this).find('a').first().attr('href')
    $.ajax({
      url: href,
      dataType: "script"
    });
    return false;
  });
  
  $('#new_knotebook select#knote_knote_type').live('change', function(){
    $(this).closest('form').submitWithAjax({ commit: "Change Knote Type" }).submit();
  });
  
  $('a.easier_knote, a.harder_knote, a.restore').live("click", function(){
    switch($(this).attr('class')) {
      case "restore": knotebooks.status.text("Restoring original knote ..."); break;
      case "easier_knote": knotebooks.status.text("Searching for an easier knote ..."); break;
      case "harder_knote": knotebooks.status.text("Searching for a harder knote ..."); break;
    }
    var val = $(this).parents('div.knote_swap').find('form select').val();
    var pos = $('div.knote').index($(this).parents('div.knote'))
    // alert('Submitting form ... ' + $(this).attr('href') + val);
    $.ajax({
      url: $(this).attr('href'),
      data: { knote_type: val, position: pos },
      dataType: "script"
    });
    return false;
  });
  
  $('a.favorite').live("click", function() {
    knotebooks.status.text("Saving to favorites ...");
    var knotebook = $(this).parents('div#knotebook'),
        knotes    = knotebook.find("div.knote"),
        url       = $(this).attr("href"),
        method    = /user/.test(url) ? "PUT" : "POST";
    $.ajax({
      url: url,
      data: {
        "knote_ids[]": $.map(knotes, function(knote){ return($(knote).attr('id').split('_').pop()); }),
        "_method": method
      },
      dataType: "script",
      type: "POST"
    });
    return false;
  });
});