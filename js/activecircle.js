(function(){
  var activeCircle = {
    activeLink: $('header nav a.active'),
    activeCircle: $('header nav .activecircle').show(),
    link: $('header nav a'),

    init: function(){
      this.setStartPosition();
      this.switcher();
    },
    setStartPosition: function(link){
      var left = this.calculatePosition(this.activeLink),
          width = this.calculateWidth(this.activeLink);

      this.activeCircle.css({
        'transform': 'translateX('+(left + ((width / 2) + 1))+'px)'
      })
    },
    calculatePosition: function(link){
      var position = link.position();
          left = position.left;
      return left;
    },
    calculateWidth: function(link){
      var width = link.width();
      return width;
    },
    switcher: function(){
      var self = this;

      this.link.on('mouseover', function(){
        self.activeCircle.removeClass('notransition');

        var $this = $(this),
            left = self.calculatePosition($this),
            width = self.calculateWidth($this);  

        self.activeCircle.css({
          'transform': 'translateX('+(left + ((width / 2) + 1))+'px)'
        })        
      });

      this.link.on('mouseout', function(){
        var $this = $(this),
            left = self.calculatePosition(self.activeLink),
            width = self.calculateWidth(self.activeLink);       

        self.activeCircle.css({
          'transform': 'translateX('+(left + ((width / 2) + 1))+'px)'
        })        
      })
    }
  }

  $(window).load(function(){
    activeCircle.init();
  })
}())