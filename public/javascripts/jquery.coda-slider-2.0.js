/*
	jQuery Coda-Slider v2.0 - http://www.ndoherty.biz/coda-slider
	Copyright (c) 2009 Niall Doherty
	This plugin available for use in all personal or commercial projects under both MIT and GPL licenses.
*/

$(function(){
	// Remove the coda-slider-no-js class from the body
	$("body").removeClass("coda-slider-no-js");
	// Preloader
  // $(".coda-slider").children('.knote').hide().end().prepend('<p class="loading">Loading...<br /><img src="images/ajax-loader.gif" alt="loading..." /></p>');
});

var sliderCount = 1;

$.fn.codaSlider = function(settings) {

	settings = $.extend({
		autoHeight: true,
		autoHeightEaseDuration: 1000,
		autoHeightEaseFunction: "easeInOutExpo",
		crossLinking: true,
		firstKnoteToLoad: 1,
		knoteTitleSelector: "h2.title",
		slideEaseDuration: 1000,
		slideEaseFunction: "easeInOutExpo"
	}, settings);
	
	return this.each(function(){
		var slider = $(this);
		
		var knoteWidth = slider.find(".knote").width();
		var knoteCount = slider.find(".knote").size();
		var knoteContainerWidth = knoteWidth*knoteCount;
		
		// Surround the collection of knote divs with a container div (wide enough for all knotes to be lined up end-to-end)
		$('.knote', slider).wrapAll('<div class="knote-container"></div>');
		// Specify the width of the container div (wide enough for all knotes to be lined up end-to-end)
		$(".knote-container", slider).css({ width: knoteContainerWidth });
		
		// Specify the current knote.
		var currentKnote = 1;
			
		// Left arrow click
		function easier() {
			if (currentKnote == 1) {
				offset = - (knoteWidth*(knoteCount - 1));
				alterKnoteHeight(knoteCount - 1);
				currentKnote = knoteCount;
			} else {
				currentKnote -= 1;
				alterKnoteHeight(currentKnote - 1);
				offset = - (knoteWidth*(currentKnote - 1));
			};
			$('.knote-container', slider).animate({ marginLeft: offset }, settings.slideEaseDuration, settings.slideEaseFunction);
			return false;
		};
			
		// Right arrow click
		function harder() {
			if (currentKnote == knoteCount) {
				offset = 0;
				currentKnote = 1;
				alterKnoteHeight(0);
			} else {
				offset = - (knoteWidth*currentKnote);
				alterKnoteHeight(currentKnote);
				currentKnote += 1;
			};
			$('.knote-container', slider).animate({ marginLeft: offset }, settings.slideEaseDuration, settings.slideEaseFunction);
			if (settings.crossLinking) { location.hash = currentKnote }; // Change the URL hash (cross-linking)
			return false;
		};
			
		// Set the height of the first knote
		if (settings.autoHeight) {
			knoteHeight = $('.knote:eq(' + (currentKnote - 1) + ')', slider).height();
			slider.css({ height: knoteHeight });
		};
		
		function alterKnoteHeight(x) {
			if (settings.autoHeight) {
				knoteHeight = $('.knote:eq(' + x + ')', slider).height()
				slider.animate({ height: knoteHeight }, settings.autoHeightEaseDuration, settings.autoHeightEaseFunction);
			};
		};
		
		sliderCount++;
	});
};