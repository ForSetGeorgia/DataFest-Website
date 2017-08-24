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
        // console.log(this)
        var c = $(this)

        c.removeAttr('data-animation')
        void this.offsetWidth;

        var mw = parseInt(c.css('maxWidth'));
        c.css('width', mw*sw/1745)
        // console.log(mw, mw*sw/1745)
        if(maxWidth < mw) { maxWidth = mw }


      })
      // console.log(maxWidth)
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
        // console.log("end set", id)
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
        // console.log(rows, columns)
        for (r = 1; r <= rows; r += 1) {
          if(r >= 70*rows/100) {
            continue
          }
            // loop through columns
            for (c = 1; c <= columns; c += 1) {
                // console.log(c >= 30*columns/100 , c <= 70*columns/100, c , 30*columns/100, 70*columns/100)
              if(c >= 20*columns/100 && c <= 80*columns/100) {
                // console.log('continue')
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
        // console.log("get for", id)
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

  // bind
    $(window).resize(function () {
      resize()
    })

    $(".circle").on(animationEvent, function(){
      setCircleAnimation($(this))
    })

  // init
    setTimeout(resize, 1000);
    $("[data-fade-id]").each(function() {
      var $t = $(this);
      $t.addClass("fadeIn" + $t.attr('data-fade-id'));
    })
})
