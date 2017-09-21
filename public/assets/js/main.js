$(document).ready(function() {
  // declarations
    var animationEvent = whichAnimationEvent();
    var positions = []
    const scene = $("#scene")

  // helpers
    function whichAnimationEvent(){
      var t,
          el = document.createElement("fakeelement");

      var animations = {
        "animation"      : "animationend",
        "OAnimation"     : "oAnimationEnd",
        "MozAnimation"   : "animationend",
        "WebkitAnimation": "webkitAnimationEnd"
      }

      for (t in animations){
        if (el.style[t] !== undefined){
          return animations[t];
        }
      }
    }

    function resize() {
      var maxWidth = 0
      var sw = scene.width();
      $(".circle").each(function() {
        var c = $(this)

        c.removeAttr('data-animation')
        void this.offsetWidth;

        var mw = parseInt(c.css('maxWidth'));
        c.css('width', mw*sw/1745)
        if(maxWidth < mw) { maxWidth = mw }


      })
      positions = generatePositionsArray(sw-maxWidth*sw/1745, scene.height(), maxWidth*sw/1745, 10);
      startCircleAnimation()
    }

    function startCircleAnimation() {
      $(".circle").each(function(i, c) {
        setCircleAnimation($(c))
      })
    }
    function setCircleAnimation ($c, _id) {
      let id = _id

      if(typeof id === "undefined") {
        id = +$c.attr('data-id')
        $c.removeAttr('data-animation')
        void $c.get(0).offsetWidth;
        clearRandomPosition(id)
      }

      const pos = getRandomPosition(id)

      if(pos === null) {
        setTimeout(function () {
          setCircleAnimation($c, id)
        }, 100)
      } else {
        $c.css({top: pos.y, left: pos.x })
        $c.attr('data-animation', id)
      }
    }

    // Returns a random integer between min (included) and max (excluded)
    // Using Math.round() will give you a non-uniform distribution!
    function getRandomInt(min, max) {
      return Math.floor(Math.random() * (max - min)) + min;
    }

    // generate random positions
    function generatePositionsArray(maxX, maxY, safeRadius, irregularity) {
        // declarations
        var positionsArray = [];
        var r, c;
        var rows;
        var columns;
        // count the amount of rows and columns
        rows = Math.floor((maxY) / safeRadius);
        columns = Math.floor(maxX / safeRadius);
        // loop through rows
        for (r = 1; r <= rows; r += 1) {
          if(r >= 70*rows/100) {
            continue
          }
            // loop through columns
            for (c = 1; c <= columns; c += 1) {
              if(c >= 20*columns/100 && c <= 80*columns/100) {
                continue
              } else {
                // console.log('else')
              }
                // populate array with point object
                positionsArray.push({
                    x: Math.round(maxX * c / columns) + getRandomInt(irregularity * -1, irregularity),
                    y: Math.round(maxY * r / rows) + getRandomInt(irregularity * -1, irregularity),
                    takenBy: null
                });
            }
        }
        // return array
        return positionsArray;
    }

    // get random position from positions array
    function getRandomPosition( id) {

        // declarations
        var randomIndex;
        var coordinates;
        // get random index
        randomIndex = getRandomInt(0, positions.length - 1);
        // get random item from array
        coordinates = positions[randomIndex]

        if(coordinates.takenBy === null) { coordinates.takenBy = id }
        else { return null }
        // check if remove taken
        // if (removeTaken) {
        //     // remove element from array
        //     array.splice(randomIndex, 1);
        // }
        // return position
        return coordinates;
    }

    function clearRandomPosition (id) {
      positions.forEach(function(f,i) {
        if(f.takenBy === id) { positions[i].takenBy = null }
      })
    }

    function render(page) {
      var data = pageCache[page]
      $(".content-container").html( data.html )
      $(".app").get(0).scrollTop = 0
      document.title = data.title
      $("meta[property='og:title']").attr('content', data.title)
      $("meta[name='description']").attr('content', data.description)
      $("meta[property='og:description']").attr('content', data.description)
      b.attr('data-page', page);
      window.history.pushState({},"", page)
      dataFadeByIds()
      $nav.trigger('click')
    }

  // bind
    $(window).resize(function () {
      resize()
    })

    $(".circle").on(animationEvent, function(){
      setCircleAnimation($(this))
    })
    var pageCache = {};
    var b = $('body');
    var currentPage = b.attr('data-page');
    var $nav = $('nav')
    $("nav a").on('click', function(event){
      var t = $(this)
      var page = t.attr('href')
      $("nav a.active").removeClass('active')
      t.addClass('active')
      if(page.indexOf('http') === -1) {
        if (currentPage !== page) {
          currentPage = page
          if (!pageCache.hasOwnProperty(page)) {
            $.getJSON( "partial/" + page + ".json", function( data ) {
              pageCache[page] = data
              render(page)
            })
          } else {
            render(page)
          }
        }
        event.preventDefault()
      }
      event.stopPropagation();
    })

    $(document).on('click', '#viewMore', function () {
      var p = $(this).parent()
      var lis = p.find('.more')
      var ln = currentPage === 'partners' ? 1 :  2

      if (lis.length <= ln) {
        $('#viewMore').remove()
        p.append('<div class="space"></div>')
      }

      lis.each(function (i, d) {
        if(ln-- === 0) { return false; }
        $(d).removeClass('more');
      })
      lis.first().get(0).scrollIntoView(true);

    })

  // init
    setTimeout(resize, 1000);
    function dataFadeByIds () {
      $("[data-fade-id]").each(function() {
        var $t = $(this)
        $t.addClass("fadeIn" + $t.attr('data-fade-id'))
        $t.removeAttr('data-fade-id')
      })
    }
    dataFadeByIds()
    var $app = $('.app')
    var $nav = $('nav')


     var touch = ('ontouchstart' in window) || window.DocumentTouch && window.document instanceof DocumentTouch || window.navigator.maxTouchPoints || window.navigator.msMaxTouchPoints ? true : false
     if(touch) {
      $('nav').click(function() {
         $app.animate(
           {

             left: $app.hasClass('toggled') ? -Math.round($nav.width())-1 : '0'
           },
           {
             duration: 400,
             easing: "easeInOutCubic"
           });
        $app.toggleClass('toggled')
      })
      $('.grid .card').click(function(e) {
        $(this).toggleClass('hover')
      })
     }
     else {
       $('.grid .card').hover(function(e) {
         $(this).addClass('hover')
       }, function(e) {
         $(this).removeClass('hover')
       })
     }
  if(b.width() < 992) {
    $app.css('left', -Math.round($nav.width())-1)
  }
  $('.loader').remove();
})
