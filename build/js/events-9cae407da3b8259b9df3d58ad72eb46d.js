$(function() {

	$( window ).load(function(){
		setTimeout(function () {
      $('body').removeClass('preload');
    }, 200);

		wow.init();
		initSpeakersSlider();
		burgerBtn();
		scrolledHeader();
  });

  $(window).scroll(function(){
    scrolledHeader();
  });

});

var wow = new WOW({
	boxClass: 'wow',      // animated element css class (default is wow)
	animateClass: 'animated', // animation css class (default is animated)
	offset: 0,          // distance to the element when triggering the animation (default is 0)
	mobile: true,       // trigger animations on mobile devices (default is true)
	live: true,       // act on asynchronously loaded content (default is true)
	callback: function (box) {
	  // the callback is fired every time an animation is started
	  // the argument that is passed in is the DOM node being animated
	},
	scrollContainer: null // optional scroll container selector, otherwise use window
});

function burgerBtn(){
	$('header .burger-btn').click(function () {
    $(this).toggleClass('active');
    $('header .resp-menu').toggleClass('active');
  });
}

function scrolledHeader(){
  var scrollTop = $( window ).scrollTop();

  if (scrollTop > 0) {
    $('header').addClass('scrolled');
  }

  if (scrollTop == 0) {
    $('header').removeClass('scrolled');
  }
}


function initSpeakersSlider(){
  // global
	var interval;
	var initialized = false;
	// marquee logic
	function marq() {
	  // object references
	  $ctr = $('.marquee-container');

	  // duplicate images to make transition appear more seamless
	  //$ctr.children('ul.show').remove();
	  var scrollerContent = $ctr.children('ul');
	  if (!initialized) {
	    scrollerContent.children().clone().appendTo(scrollerContent);
	    initialized = true;
	  }
	  /*var $clone = scrollerContent.clone(true);
	  $clone.children().clone().appendTo($clone);
	  $clone.removeClass('ref').addClass('show');
	  $clone.appendTo($ctr);*/

	  // determine the width and loop breakpoint
	  var curX = 0;
	  scrollerContent.children().each(function() {
	    var $this = $(this);
	    $this.css('left', curX);
	    curX += $this.outerWidth(true);
	  });
	  var fullW = curX / 2;
	  var viewportW = $ctr.width();

	  // Scrolling speed management
	  var controller = {
	    curSpeed: 0,
	    fullSpeed: 2
	  };
	  var $controller = $(controller);
	  var tweenToNewSpeed = function(newSpeed, duration) {
	    if (duration === undefined)
	      duration = 600;
	    $controller.stop(true).animate({
	      curSpeed: newSpeed
	    }, duration);
	  };

	  // Pause on hover
	  /*$ctr.hover(function() {
	    tweenToNewSpeed(0);
	  }, function() {
	    tweenToNewSpeed(controller.fullSpeed);
	  });*/

	  // Scrolling management; start the automatic scrolling
	  var doScroll = function() {
	    var curX = $ctr.scrollLeft();
	    var newX = curX + controller.curSpeed;
	    if (newX > fullW * 2 - viewportW)
	      newX -= fullW;
	    $ctr.scrollLeft(newX);
	  };
	  interval = setInterval(doScroll, 40);
	  tweenToNewSpeed(1.5);
		//2019 tweenToNewSpeed(controller.fullSpeed);
	}

	if ($('.marquee-wrapper').length) {
	  // init marquee
	  marq();
	  // resize handler
	  $(window).resize(function() {
	    clearInterval(interval);
	    // re-init the marquee
	    marq();
	  });
	}
}


          