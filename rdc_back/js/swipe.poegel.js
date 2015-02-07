/* 
 * Swipe Without Jquery Mobile
 * Adapted by: Poegel
 * 05-06-2014
 */

;(function($) {

  $.fn.swipe = function(sw) {
    return this.each(function() {
      var $this = $(document),
              isTouching = false,
              debut, debut_horizontal;

      $this.on('touchstart', debutTouch);
      
      function debutTouch() {
        if (event.touches.length == 1) {
          debut = event.touches[0].pageY;
          debut_horizontal = event.touches[0].pageX;
          isTouching = true;
          $this.on('touchmove', touch);
        }
      }

      function endTouch() {
        $this.off('touchmove');
        isTouching = false;
        debut = null;
        debut_horizontal = null;
      }

      function touch() {
        if (isTouching) {
          var actuel = event.touches[0].pageY;
          var delta = debut - actuel;

          var actuel_horizontal = event.touches[0].pageX;
          var delta_horizontal = debut_horizontal - actuel_horizontal;

          if (Math.abs(delta) >= 30) {
            if (delta > 0) {
              sw.up();
            } else {
              sw.down();
            }
            endTouch();
          }

          if (Math.abs(delta_horizontal) >= 30) {
            if (delta_horizontal > 0) {
              sw.left();
            } else {
              sw.right();
            }
            endTouch();
          }
        }
        event.preventDefault();
      }
    });
  };
  
  
})(jQuery);
