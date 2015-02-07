/********************************* START MAIN PROJECT *******************************************************************/

$.fn.preload = function(pre) {
  this.each(function() {
    $('<img/>')[0].src = this;
  });
  pre.complete();
}

var google_autocomplete, google_autocomplete_gererblog;
var swipeleft = 0, menu_lateral_open = 0, category_swipe = 0, article_open = 0;
var cat1_theme = '', cat2_theme = '', cat3_theme = '';

$(document).ready(function() {
  project = new Project();
});

function Project() {
  this.back_url = 'http://pin-up.dynip.sapo.pt/revue-de-copines/back/';



  this.loadPages();
  this.resize();
}

/*Project.prototype.googleMap = function() {
 var map_canvas = document.getElementById('googleMap');
 
 var mapOptions = {
 center: new google.maps.LatLng(51.508742, -0.120850),
 zoom: 5,
 mapTypeId: google.maps.MapTypeId.ROADMAP
 }
 
 var map = new google.maps.Map(map_canvas, mapOptions);
 }*/

Project.prototype.replaceSelect = function() {
  $('select.select').each(function() {
    var id = "#" + $(this).attr('id');
    var title = $(id + " option:selected").text();
    if ($('option:selected', this).val() != '')
      title = $('option:selected', this).text();

    $(this).css({
      'z-index': 10,
      'opacity': 0,
      '-khtml-appearance': 'none'
    }).after('<span class="select">' + title + '</span>').change(function() {
      val = $('option:selected', this).text();
      $(this).next().text(val);
    });
  });
}

var myScroll;
var myScroll2;
var myScroll3;
var myScroll4;
var myScroll5;
var myScroll6;

Project.prototype.changePage = function(page) {

  if (page == 'newsDiv')
    news.getFeeds();
  else if (page == 'registerDiv') {
    menulateral.hideMenu();
    $('mainDiv').attr('user_id', '');
    register.user = null;
  }

  if (page != 'artigoDiv') {
    $('#mainDiv > div').hide();
    $('#' + page).show();
  }

  var height = $(document).height();

  $('#artigoMainDiv').css({
    //'height': height + 'px',
    'height': height + 'px',
    'overflow-y': 'scroll'
  });

  $('#commentMainDiv').css({
    //'height': height + 'px',
    'height': height + 'px',
    'width': '100%',
    'overflow-y': 'scroll',
    'float': 'left'
  });

  $('#bloggerProfileDiv').css({
    'height': height + 'px'
  });

  $('#next-articles').css({
    'overflow': 'hidden'
  });


  if (page == 'bloggerProfileDiv') {

    if (parseInt($('#bloggerProfileDiv > div').height()) < parseInt($('#bloggerProfileDiv').height()))
      $('#bloggerProfileDiv > div').css('height', '100%');
    else
      $('#bloggerProfileDiv > div').css('height', 'auto');

  }



  myScroll2 = new IScroll('#commentMainDiv');
  myScroll3 = new IScroll('#bloggerProfileDiv');
  myScroll4 = new IScroll('#gererMonBlogDiv');

  myScroll5 = new IScroll('#discoverDiv');

  if (page == 'artigoDiv') {

    var pre_load_array = [];

    $('#artigoDiv #article-data-div img').each(function() {
      pre_load_array.push($(this).attr('src'));
    });

    $(pre_load_array).preload({
      complete: function() {

        window.setTimeout(function() {
          $('#mainDiv > div').hide();
          $('#' + page).show();

          myScroll = new IScroll('#artigoMainDiv');
          $('#artigoMainDiv').scrollTop(0);

        }, 1000);

      }
    });


  }

}

Project.prototype.resize = function() {
  var htRef = 640;
  var ht = $(window).width();
  if ($(window).height() < $(window).width())
    ht = $(window).height();
  if (ht > 640)
    ht = 640;
  var size = ((ht * 62.5) / htRef);
  $('html').css('font-size', size + '%');
}

Project.prototype.loadPages = function() {
  var self = this;

  var pages = ['news.html', 'artigo.html', 'mon_blog.html', 'notifications.html',
    'menu_lateral.html', 'explore.html', 'blogger_profile.html',
    'login_slider.html', 'register.html', 'comment.html', 'gerer_mon_blog.html', 'category.html', 'login.html',
    'discover.html', 'cat1.html', 'cat2.html', 'cat3.html'];

  $('#mainDiv').html('');

  $.map(pages, function(n, i) {

    $.get('pages/' + n, function(page) {

      $('#mainDiv').append(page);

      if (pages.length == parseInt(i) + 1) {
        self.replaceSelect();

        news = new News();
        login = new Login();
        menulateral = new MenuLateral();
        explore = new Explore();
        blogger = new Blogger();
        reader = new Reader();
        artigo = new Artigo();
        pocket = new Pocket();
        loginslider = new LoginSlider();
        register = new Register();
        gerermonblog = new GererMonBlog();
        comment = new Comment();
        category = new Category();
        discover = new Discover();

        cat1 = new Cat1();
        cat2 = new Cat2();
        cat3 = new Cat3();

        cat1_theme = '';
        cat2_theme = '';
        cat3_theme = '';

        project.events();

        project.changePage('registerDiv');

      }
    });



  });
}

Project.prototype.loadCat = function() {

  var dataToSend = new Object();
  dataToSend.id = $('#mainDiv').attr('user_id');

  $.post(project.back_url + 'user/getUser/', {data: dataToSend}, function(response) {

    if (response.success == '1') {

      var themes = response.user.themes.split(' ');
      $('#carroussel-div > img.copines').show();

      $.map(themes, function(theme, i) {
        if (i == 0) {
          cat1_theme = theme;
          $('#carroussel-div > img.cat1').show();
        }
        else if (i == 1) {
          cat2_theme = theme;
          $('#carroussel-div > img.cat2').show();
        }
        else if (i == 2) {
          cat3_theme = theme;
          $('#carroussel-div > img.cat3').show();
        }
      });
    }
    else
      console.log("No Session!");

  }, 'json');


}

Project.prototype.events = function() {

  var temp_placeholder = '';

  $('input').focus(function() {
    temp_placeholder = $(this).attr('placeholder');
    $(this).attr('placeholder', '');
    $('#comment-input-div').css('position', 'absolute');
    $('#comment-input-div').css('bottom', '0');
  });

  $('input').focusout(function() {
    $(this).attr('placeholder', temp_placeholder);
    $('#comment-input-div').css('position', 'fixed');
    $('#comment-input-div').css('bottom', '0');
    window.scrollTo(0, 0);
  });

  $('#menuLateral-Content .menu-lateral-submenu.search').on('touchstart', function(e) {
    menulateral.decouvrirClick();
  });


  /*$('.profile-image').click(function() {
   project.changePage('bloggerProfileDiv');
   });
   
   $('.menu-lateral-title').click(function() {
   project.changePage('bloggerProfileDiv');
   });
   
   
   $('.profile-image').on('touchstart', function(e) {
   e.preventDefault();
   project.changePage('bloggerProfileDiv');
   });
   
   $('.menu-lateral-title').on('touchstart', function(e) {
   e.preventDefault();
   project.changePage('bloggerProfileDiv');
   });*/

  /*
   $('#blogger-profile-controlDiv > img.close').click(function() {
   blogger.closeClick();
   });
   
   $('#blogger-profile-controlDiv > img.follow').click(function() {
   blogger.followClick();
   });
   */

  $('#blogger-profile-controlDiv > img.close').on('touchstart', function(e) {
    blogger.closeClick();
  });

  $('#blogger-profile-controlDiv > img.follow').on('touchstart', function(e) {
    blogger.followClick();
  });

  $('#gererMonBlogDiv .termine').on('touchstart', function(e) {
    gerermonblog.termineClick();
  });




  //$('#bloggerProfileDiv')

  /*$('#menu-bar-top-artigo > img:first').click(function(e) {
   artigo.backClick();
   });*/


  $('#menu-bar-top-artigo > img:first').on('touchstart', function(e) {
    artigo.backClick();
  });




  $('#categoryDiv #category-slider-div').swipe({
    left: function() {

      if (category_swipe == 0) {
        category_swipe = 1;

        var left = $('#categoryDiv #category-slider-div').css('margin-left');
        left = left.replace('px', '');

        //alert('left: ' + left);

        if (parseInt(left) <= -2120) {
          $('#categoryDiv #category-slider-div').animate({
            'margin-left': '+=-240px'
          }, 500, function() {
            $('#categoryDiv #category-slider-div').css('margin-left', '-200px');
            category.activateSwipe();
          });
        }
        else
        {
          $('#categoryDiv #category-slider-div').animate({
            'margin-left': '+=-240px'
          }, 500, function() {
            category.activateSwipe();
          });
        }





      }
    },
    right: function() {
      if (category_swipe == 0) {
        category_swipe = 1;

        var left = $('#categoryDiv #category-slider-div').css('margin-left');
        left = left.replace('px', '');

        if (parseInt(left) >= -200) {
          $('#categoryDiv #category-slider-div').animate({
            'margin-left': '+=+240px'
          }, 500, function() {
            $('#categoryDiv #category-slider-div').css('margin-left', '-2120px');
            category.activateSwipe();
          });

        }
        else {
          $('#categoryDiv #category-slider-div').animate({
            'margin-left': '+=+240px'
          }, 500, function() {
            category.activateSwipe();
          });
        }

      }
    }

  });




  /*$('#menuLateral-Content #gererMonBlog-button').click(function() {
   category.loadCategories();
   });*/

  $('#menuLateral-Content #gererMonBlog-button').on('touchstart', function(e) {
    menulateral.gererMonBlogClick();
  });

  $('#menuLateral-Content #AddCategories').on('touchstart', function(e) {
    category.loadCategories();
  });


}

Project.prototype.getFeedTimePast = function(update_at) {
  var update = update_at.match(/(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+)/);
  update = new Date(update[1], parseInt(update[2], 10) - 1, update[3], update[4], update[5], update[6]);

  var today = new Date();
  var result = new Date(today - update);
  var year = parseInt(result.getYear()) - 70;
  var month = result.getMonth();
  var day = result.getDate();
  var hours = result.getHours();
  var minutes = result.getMinutes();
  var seconds = result.getSeconds();

  if (year == 0 && month == 0) {
    if (day == 1 && today.getDate() == update.getDate())
      day = 0;

    if (day == 0 && today.getHours() == update.getHours())
      hours = 0;
  }

  //console.log(year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds);

  var timepast = '0sec';

  if (year > 0) {
    if (year == 1)
      timepast = year + ' year';
    else
      timepast = year + ' years';
  }
  else if (month > 0) {
    if (month == 1)
      timepast = month + ' month';
    else
      timepast = month + ' months';
  }
  else if (day > 0) {
    if (day == 1)
      timepast = day + ' day';
    else
      timepast = day + ' days';
  }
  else if (hours > 0) {
    timepast = hours + 'h';
  }
  else if (minutes > 0) {
    timepast = minutes + 'min';
  }
  else if (seconds > 0) {
    timepast = seconds + 'sec';
  }

  /* FIX Some error */
  if (timepast == '11 months' && update.getYear() == today.getYear() && update.getMonth() == today.getMonth() && update.getDate() == today.getDate()) {
    var newDate = new Date(update.getFullYear(), update.getMonth(), update.getDate(), update.getHours() + 1, update.getMinutes(), update.getSeconds(), update.getMilliseconds());
    //console.log('newDate: ' + newDate);
    update = newDate.getFullYear() + '-' + newDate.getMonth() + '-' + newDate.getDate() + ' ' + newDate.getHours() + ':' + newDate.getMinutes() + ':' + newDate.getSeconds();
    return project.getFeedTimePast(update);
  }

  return timepast;
}

Project.prototype.displayError = function(selector, message) {
  var errorDiv = '<div class="errorWindow left col-lg-12 col-md-12 col-sm-12 col-xs-12"><div class="box">' + message + '</div><div class="arrowDown"></div></div>';

  $('.errorWindow').remove();
  $(selector).prepend(errorDiv);

  $('input').click(function() {
    $('.errorWindow').slideUp(300);
  });

  $('input').focus(function() {
    $('.errorWindow').slideUp(300);
  });

  $('input').change(function() {
    $('.errorWindow').slideUp(300);
  });

  $('select').change(function() {
    $('.errorWindow').slideUp(300);
  });

  $('.errorWindow').slideDown(600);

}

Project.prototype.validateAlpha = function(alpha) {
  if (!/^[a-zA-Z-'áàâãÁÀÂÃéèêÉÈÊíìîÍÌÎóòôõÓÒÔÕúùûüÚÙÛñÑçÇ]+( [a-zA-Z-'áàâãÁÀÂÃéèêÉÈÊíìîÍÌÎóòôõÓÒÔÕúùûüÚÙÛñÑçÇ]+)*$/.test(alpha))
    return false;
  else
    return true;
}

Project.prototype.validateEmail = function(email) {
  if (!/^[a-zA-Z0-9_]+([_a-zA-Z0-9.-]+)*@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_]+)*\.[a-zA-Z]{2,4}$/.test(email))
    return false;
  else
    return true;
}

Project.prototype.validatePassword = function(password) {
  if (!/^[A-Za-z0-9'-_+?*']{6,20}$/.test(password))
    return false;
  else
    return true;
}

Project.prototype.validateURL = function(url) {
  if (!/(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?/.test(url))
    return false;
  else
    return true;
}


/********************************* END MAIN PROJECT *******************************************************************/

/********************************* START NEWS *******************************************************************/

var news_coordinate_category = "mes-copines";
var news_coordinate_feed = "";
var news_swipe = 0;

function News() {
  this.swipe();
}

News.prototype.swipe = function() {

  $("#menuLateral-Content").unbind('touchmove');
  $(".news-feeds-category-div").unbind('touchmove');
  $(document).unbind('touchmove');
  //$(document).unbind('touchstart');

  $(".news-feeds-category-div").swipe({
    up: function() {
      if (news_swipe == 1)
        return;

      if (menu_lateral_open == 1)
        return;

      if (article_open == 1)
        return;

      if (parseInt($('#newsDiv .news-article-page span.page-current').text()) >= parseInt($('#newsDiv .news-article-page span.page-total').text()))
        return;

      news_swipe = 1;

      var page = $('#newsDiv .news-article-page span.page-current').text(parseInt($('#newsDiv .news-article-page span.page-current').text()) + 1);

      $('.news-feeds-category-div.' + news_coordinate_category + ' .feed-div').hide();
      $('.news-feeds-category-div.' + news_coordinate_category + ' .feed-div#feed-' + page.text()).show();


      news.activateSwipe();
    },
    down: function() {
      if (news_swipe == 1)
        return;

      if (menu_lateral_open == 1)
        return;

      if (article_open == 1)
        return;

      if ($('#newsDiv .news-article-page span.page-current').text() == '1')
        return;


      news_swipe = 1;


      var page = $('#newsDiv .news-article-page span.page-current').text(parseInt($('#newsDiv .news-article-page span.page-current').text()) - 1);

      $('.news-feeds-category-div.' + news_coordinate_category + ' .feed-div').hide();
      $('.news-feeds-category-div.' + news_coordinate_category + ' .feed-div#feed-' + page.text()).show();


      news.activateSwipe();
    },
    left: function() {
      if (news_swipe == 1)
        return;
      news_swipe = 1;

      if (menu_lateral_open == 1)
        return;

      if ($('#newsDiv').is(':visible') && cat1_theme != '') {
        cat1.loadNews();
      }
      else if ($('#cat1Div').is(':visible') && cat2_theme != '') {
        cat2.loadNews();
      }
      else if ($('#cat2Div').is(':visible') && cat3_theme != '') {
        cat3.loadNews();
      }

      news.activateSwipe();
    },
    right: function() {
      if (news_swipe == 1)
        return;
      news_swipe = 1;

      if (menu_lateral_open == 1)
        return;

      if ($('#cat1Div').is(':visible')) {
        project.changePage('newsDiv');
      }
      else if ($('#cat2Div').is(':visible') && cat1_theme != '') {
        cat1.loadNews();
      }
      else if ($('#cat3Div').is(':visible') && cat2_theme != '') {
        cat2.loadNews();
      }

      news.activateSwipe();
    }
  });

}

News.prototype.activateSwipe = function() {
  setTimeout(function() {
    news_swipe = 0;
  }, 700);
}

News.prototype.shareClick = function(element) {
  var blog_id = element.parent().parent().find('input.blog-id').val();
  var feed_id = element.parent().parent().find('input.feed-id').val();

  console.log('news.shareClick() feed_id: ' + feed_id + ' and blog_id: ' + blog_id);
}

News.prototype.speechClick = function(element) {
  var blog_id = element.parent().parent().find('input.blog-id').val();
  var feed_id = element.parent().parent().find('input.feed-id').val();

  console.log('news.speechClick() on feed_id: ' + feed_id + ' and blog_id: ' + blog_id);
}

News.prototype.heartClick = function(element, article_id, blog_id) {
  var self = this;

  if (element.attr('src').indexOf('like.png') !== -1) {
    element.attr('src', element.attr('src').replace('like.png', 'like_line.png'));
    element.parent().find('.news-feeds-like').text(parseInt(element.parent().find('.news-feeds-like').text()) - 1);
    var dataToSend = new Object();
    dataToSend.user_id = $('#mainDiv').attr('user_id');
    dataToSend.article_id = article_id;
    dataToSend.blog_id = blog_id;
    $.post(project.back_url + 'blog/removeArticleLike/', {data: dataToSend});
  }
  else {
    element.attr('src', element.attr('src').replace('like_line.png', 'like.png'));
    element.parent().find('.news-feeds-like').text(parseInt(element.parent().find('.news-feeds-like').text()) + 1);

    var dataToSend = new Object();
    dataToSend.user_id = $('#mainDiv').attr('user_id');
    dataToSend.article_id = article_id;
    dataToSend.blog_id = blog_id;
    $.post(project.back_url + 'blog/makeArticleLike/', {data: dataToSend});
  }
}

News.prototype.menuClick = function() {
  swipeleft = 0;

  if (menu_lateral_open == 0) {
    menu_lateral_open = 1;

    menulateral.swipe();

    $('#newsDiv').css('overflow-y', 'hidden');

    $('#menuLateralDiv').css('left', '-100%');
    $('#menuLateral-Content').css('left', '-100%');

    $('#menuLateralDiv').show();
    $('#menuLateral-Content').show();

    $('#newsDiv').animate({
      'left': '+=85%'
    }, 300);

    $('#menu-bar-top').animate({
      'left': '+=85%'
    }, 300);

    $('#menuLateral-Content').animate({
      'left': '+=85%'
    }, 300);
  }

  var height = $(document).height();

  $('#menuLateral-Content').css({
    'height': height + 'px',
    'overflow-y': 'scroll'
  });

  myScroll2 = new IScroll('#menuLateral-Content');
}

News.prototype.topSubmenuChange = function(element) {
  element.parent().find('p').css('color', '#a5a5a5');
  element.css('color', '#F04657');
}

News.prototype.convertTimeFormat = function(time) {
  var frag = time.split(' ');
  var day = frag[0].split('-')[2];
  var month = frag[0].split('-')[1];
  var year = frag[0].split('-')[0];
  var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  var time = day + ' ' + months[parseInt(month) - 1] + ' ' + year;
  return time;
}

News.prototype.getFeedsPopulaire = function() {
  var self = this;

  $.get(project.back_url + 'blog/listBlogs/', function(listBlogs) {
    if (listBlogs.success == '1') {

      $('#feedsMainDiv').html('');

      $.map(listBlogs.blogs, function(blog) {
        var dataToSend = new Object();
        dataToSend.blog_id = blog.id;
        dataToSend.user_id = $('#mainDiv').attr('user_id');

        $.post(project.back_url + 'blog/listArticlesPopulaire/', {data: dataToSend}, function(response) {

          $.map(response.articles, function(article, i) {
            console.log(article);
            i = parseInt(i) + 1;
            var time = self.convertTimeFormat(article.created_at);
            console.log(time);

            var feed = '<div id="feed-' + i + '" feed_page="' + i + '" feed_id="' + article.id + '" class="feed-div"><img src="img/register/hardcoded/image4.png" /><div class="news-article-stats" onclick="artigo.loadArticle(' + article.id + ')">';
            feed += '<div class="stat"><img src="img/register/buttons/like.png" /><p>181</p></div><div class="stat"><img src="img/register/buttons/comment.png" />';
            feed += '<p class="news-feeds-comments">15</p></div></div><div class="news-feed-content"><div class="news-articleNewDiv" onclick="news.newArticlesClick()"><p>3 nouveaux articles</p>';
            feed += '</div><img class="news-blogger-photo" src="img/register/hardcoded/image5.png" /><p class="news-article-date">9 MAI 2014</p>';
            feed += '<p class="news-article-title">San Francisco</p><p class="news-article-blogname">Par <span>Le Blog de Sarah</span></p>';
            feed += '<p class="news-article-text">La semaine dernière, j\'ai eu la chance d\'aller à San Francisco pour quelques';
            feed += 'jours. Au gré de ses collines et de ses quartiers, Frisco dévoile un caractère ...</p></div></div>';



            if (article.user_has_like == 1)
              feed += '.png" /></div></div>';
            else
              feed += '2.png" /></div></div>';

            $('#feedsMainDiv').append(feed);
          });

        }, 'json');

      });

    }
  }, 'json');
}



News.prototype.getFeedsByUserId = function() {
  var self = this;

  $('#newsDiv #feedsMainDiv').html('');

  var dataToSend = new Object();
  dataToSend.user_id = $('#mainDiv').attr('user_id');

  $.post(project.back_url + 'blog/listArticlesByUserId/', {data: dataToSend}, function(response) {

    $.map(response.articles, function(article, i) {
      i = parseInt(i) + 1;
      var time = self.convertTimeFormat(article.created_at);


      var image = "";

      if (i == 1)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/selectionaccesoiresbureau_featured.png";
      else if (i == 2)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/1601319_425697720908397_251263012_n.jpg";
      else if (i == 3)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/painted-bottle-vases03-728x405.jpg";
      else if (i == 4)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/Gallery-S-Bensimon-X-La-Redoute-700x405.jpg";
      else if (i == 5)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/P1070665-760x405.jpg";

      var like_src = 'img/register/buttons/like_line.png';

      if (article.has_like == '1')
        like_src = 'img/register/buttons/like.png';

      var newArticlesDiv = '';

      if (parseInt(article.new_articles) > 0)
        newArticlesDiv = '<div class="news-articleNewDiv" style="visibility:visible" onclick="news.newArticlesClick()"><p>' + article.new_articles + ' nouveaux articles</p></div>';
      else
        newArticlesDiv = '<div class="news-articleNewDiv" style="visibility:hidden" onclick="news.newArticlesClick()"><p>' + article.new_articles + ' nouveaux articles</p></div>';

      var feed = '<div id="feed-' + i + '" feed_page="' + i + '" feed_id="' + article.id + '" blog_id="' + article.blog_id + '" class="feed-div"><img src="' + image + '" onclick="artigo.loadArticle(' + article.id + ')" /><div class="news-article-stats">';
      feed += '<div class="stat"><img onclick="news.heartClick($(this), ' + article.id + ', ' + article.blog_id + ')" src="' + like_src + '" /><p class="news-feeds-like">' + article.likes + '</p></div><div class="stat"><img onclick="artigo.loadComments($(this))" article_id="' + article.id + '" blog_id="' + article.blog_id + '" src="img/register/buttons/comment.png" />';
      feed += '<p class="news-feeds-comments">' + article.comments + '</p></div></div><div class="news-feed-content" onclick="artigo.loadArticle(' + article.id + ')">' + newArticlesDiv;
      feed += '<img class="news-blogger-photo" src="img/register/hardcoded/image5.png" /><p class="news-article-date">' + time + '</p>';
      feed += '<p class="news-article-title">' + article.title + '</p><p class="news-article-blogname">Par <span>' + article.blogname + '</span></p>';
      feed += '<p class="news-article-text">' + article.content + '</p></div></div>';

      $('#feedsMainDiv').append(feed);



    });

  }, 'json');

}

News.prototype.getFeeds = function() {
  var self = this;

  $('#newsDiv #feedsMainDiv').html('');

  $.post(project.back_url + 'blog/getFeeds/', function(response) {

    if (response.success == '0') {
      project.changePage('registerDiv');
      return;
    }

    $('#newsDiv .news-article-page span.page-total').text(response.articles.length);

    $.map(response.articles, function(article, i) {
      i = parseInt(i) + 1;
      var time = self.convertTimeFormat(article.created_at);

      var image = "";

      if (i == 1)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/selectionaccesoiresbureau_featured.png";
      else if (i == 2)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/1601319_425697720908397_251263012_n.jpg";
      else if (i == 3)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/painted-bottle-vases03-728x405.jpg";
      else if (i == 4)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/Gallery-S-Bensimon-X-La-Redoute-700x405.jpg";
      else if (i == 5)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/P1070665-760x405.jpg";

      var like_src = 'img/register/buttons/like_line.png';

      if (article.has_like == '1')
        like_src = 'img/register/buttons/like.png';

      var newArticlesDiv = '';

      if (parseInt(article.new_articles) > 0)
        newArticlesDiv = '<div class="news-articleNewDiv" style="visibility:visible" onclick="news.newArticlesClick()"><p>' + article.new_articles + ' nouveaux articles</p></div>';
      else
        newArticlesDiv = '<div class="news-articleNewDiv" style="visibility:hidden" onclick="news.newArticlesClick()"><p>' + article.new_articles + ' nouveaux articles</p></div>';

      var feed = '<div id="feed-' + i + '" feed_page="' + i + '" feed_id="' + article.id + '" blog_id="' + article.blog_id + '" class="feed-div"><img src="' + image + '" onclick="artigo.loadArticle(' + article.id + ')" /><div class="news-article-stats">';
      feed += '<div class="stat"><img onclick="news.heartClick($(this), ' + article.id + ', ' + article.blog_id + ')" src="' + like_src + '" /><p class="news-feeds-like">' + article.likes + '</p></div><div class="stat"><img onclick="artigo.loadComments($(this))" article_id="' + article.id + '" blog_id="' + article.blog_id + '" src="img/register/buttons/comment.png" />';
      feed += '<p class="news-feeds-comments">' + article.comments + '</p></div></div><div class="news-feed-content" onclick="artigo.loadArticle(' + article.id + ')">' + newArticlesDiv;
      feed += '<img class="news-blogger-photo" src="img/register/hardcoded/image5.png" /><p class="news-article-date">' + time + '</p>';
      feed += '<p class="news-article-title">' + article.title + '</p><p class="news-article-blogname">Par <span>' + article.blogname + '</span></p>';
      feed += '<p class="news-article-text">' + article.content + '</p></div></div>';

      $('#feedsMainDiv').append(feed);



    });

    $('#newsDiv #feedsMainDiv .feed-div').hide();
    $('#newsDiv #feedsMainDiv #feed-' + $('#newsDiv .news-article-page .page-current').text()).show();

  }, 'json');


}

News.prototype.goArticle = function(feed_id, blog_id) {
  var page = 'artigoDiv';
  $('#' + page).attr('artigoid', feed_id);
  $('#' + page).attr('blogid', blog_id);
  artigo.loadArticle(feed_id, blog_id);
  project.changePage(page);
}



/********************************* END NEWS *******************************************************************/

/********************************* START ARTIGO *******************************************************************/

/********************************* END ARTIGO *******************************************************************/

/********************************* START LOGIN *******************************************************************/

function Login() {

}


Login.prototype.loginClick = function() {
  var email = $('#loginDiv #login-input-email');
  var password = $('#loginDiv #login-input-password');

  if (email.val() == '') {
    project.displayError(email.parent(), "Le champ Mail est obligatoire");
    return;
  }

  if (!project.validateEmail(email.val())) {
    project.displayError(email.parent(), "Le champ Mail n'est pas valide");
    return;
  }

  if (password.val() == '') {
    project.displayError(password.parent(), "Le champ mot de passe est obligatoire");
    return;
  }

  if (password.val().length < 6 && password.val().length > 20) {
    project.displayError(password.parent(), "Le mot de passe doit être d'au moins 6 caractères et au plus 20");
    return;
  }

  if (!project.validatePassword(password.val())) {
    project.displayError(password.parent(), "Le champ mot de passe n'est pas valide");
    return;
  }

  var dataToSend = new Object();
  dataToSend.email = email.val();
  dataToSend.password = password.val();

  $.post(project.back_url + 'user/callLogin/', {data: dataToSend}, function(response) {

    if (response.success == '1') {
      $('#mainDiv').attr('user_id', response.user.id);
      project.loadCat();
      menulateral.loadMenu(response.user);
      project.changePage('newsDiv');
    }
    else
      project.displayError(email.parent(), response.msg);

  }, 'json');


}


Login.prototype.displayLoginDiv = function(type) {
  if (type == 'show') {

    $('#loginDiv').show(function() {

      $('#mainDiv #landingLoginDiv').css('overflow-y', 'scroll');

      $('#landingLoginDiv').animate({
        scrollTop: $(document).height()
      }, 1000);

    });
  }
  else {

    $('#landingLoginDiv').animate({
      scrollTop: 0
    }, 1000, function() {
      $('#loginDiv').hide();
      $('#mainDiv #landingLoginDiv').css('overflow-y', 'hidden');
    });
  }
}


/*********************************  END LOGIN *******************************************************************/

/*********************************  START MENU LATERAL *******************************************************************/

function MenuLateral() {

}

MenuLateral.prototype.load = function() {
  var self = this;

  if ($('mainDiv').attr('user_id') == '') {
    project.changePage('registerDiv');
    return;
  }

  var user_data = new Object();
  user_data.id = $('#mainDiv').attr('user_id');

  $.post(project.back_url + 'user/getUser/', {data: user_data}, function(response) {

    if (response.success == '1') {

      var user = response.user;

      if (user.type == '0') {
        $('#menuLateral-Content .menu-lateral-title').text(user.first_name + ' ' + user.name);
        $('#menuLateral-Content .menu-lateral-submenu-title > img').css('visibility', 'hidden');

        $('#menuLateral-Content .menu-lateral-submenu-copines').remove();

        var dataToSend = new Object();
        dataToSend.user = user;

        $.post(project.back_url + 'blog/loadMenuLateral/', {data: dataToSend}, function(response) {
          if (response.success == '1') {
            $.map(response.copines, function(blog_subscription, i) {
              $('#menuLateral-Content .menu-lateral-submenuDiv').append('<div class="menu-lateral-submenu-copines"><p blog_id="' + blog_subscription.blog_id + '">' + blog_subscription.blog_name + '</p></div>');
            });
          }
          else
            console.log("no session");

        }, 'json');
      }
      else {

        var dataToSend = new Object();
        dataToSend.user = user;

        $.post(project.back_url + 'blog/loadMenuLateral/', {data: dataToSend}, function(response) {

          if (response.success == '1') {

            $('#menuLateral-Content .menu-lateral-title').text(response.blog.name);
            $('#menuLateral-Content .menu-lateral-submenu-title > img').css('visibility', 'visible');
            $('#menuLateral-Content .menu-lateral-submenu-copines').remove();

            $.map(response.copines, function(blog_subscription, i) {
              $('#menuLateral-Content .menu-lateral-submenuDiv').append('<div class="menu-lateral-submenu-copines"><p blog_id="' + blog_subscription.blog_id + '">' + blog_subscription.blog_name + '</p></div>');
            });

            $('#menuLateral-Content .menu-lateral-submenu-copines').unbind();

            $('#menuLateral-Content .menu-lateral-submenu-copines').on('touchstart', function(e) {
              menulateral.loadBloggerProfile($(this).find('p').attr('blog_id'));
            });

          }
          else
            project.changePage('registerDiv');



        }, 'json');




      }

    }
    else
      project.changePage('registerDiv');

  }, 'json');
}

MenuLateral.prototype.loadMenu = function(user) {
  var self = this;

  if (user.type == '0') {
    $('#menuLateral-Content .menu-lateral-title').text(user.first_name + ' ' + user.name);
    $('#menuLateral-Content .menu-lateral-submenu-title > img').css('visibility', 'hidden');

    $('#menuLateral-Content .menu-lateral-submenu-copines').remove();

    var dataToSend = new Object();
    dataToSend.user = user;

    $.post(project.back_url + 'blog/loadMenuLateral/', {data: dataToSend}, function(response) {
      if (response.success == '1') {
        $.map(response.copines, function(blog_subscription, i) {
          $('#menuLateral-Content .menu-lateral-submenuDiv').append('<div class="menu-lateral-submenu-copines"><p blog_id="' + blog_subscription.blog_id + '">' + blog_subscription.blog_name + '</p></div>');
        });
      }
      else
        console.log("no session");

    }, 'json');
  }
  else {

    var dataToSend = new Object();
    dataToSend.user = user;

    $.post(project.back_url + 'blog/loadMenuLateral/', {data: dataToSend}, function(response) {

      if (response.success == '1') {

        $('#menuLateral-Content .menu-lateral-title').text(response.blog.name);
        $('#menuLateral-Content .menu-lateral-submenu-title > img').css('visibility', 'visible');
        $('#menuLateral-Content .menu-lateral-submenu-copines').remove();

        $.map(response.copines, function(blog_subscription, i) {
          $('#menuLateral-Content .menu-lateral-submenuDiv').append('<div class="menu-lateral-submenu-copines"><p blog_id="' + blog_subscription.blog_id + '">' + blog_subscription.blog_name + '</p></div>');
        });

        $('#menuLateral-Content .menu-lateral-submenu-copines').unbind();

        $('#menuLateral-Content .menu-lateral-submenu-copines').on('touchstart', function(e) {
          menulateral.loadBloggerProfile($(this).find('p').attr('blog_id'));
        });

      }
      else
        project.changePage('registerDiv');



    }, 'json');




  }




}

MenuLateral.prototype.loadBloggerProfile = function(blog_id) {
  var dataToSend = new Object();
  dataToSend.blog_id = blog_id;
  dataToSend.user_id = $('#mainDiv').attr('user_id');

  //alert('blog_id[' + dataToSend.blog_id + '] user_id[' + dataToSend.user_id + ']');

  $.post(project.back_url + 'blog/loadBloggerProfile/', {data: dataToSend}, function(response) {

    if (response.success == '1') {

      $('#bloggerProfileDiv').attr('blog_id', blog_id);
      $('#bloggerProfileDiv .blog-name').text(response.blog.name);
      $('#bloggerProfileDiv .blog-url').text(response.blog.url);
      $('#bloggerProfileDiv .user-gpoint').text(response.blog.locale);
      $('#bloggerProfileDiv .user-description').text(response.blog.user_description);

      if (response.blog.is_following == '1')
        $('#bloggerProfileDiv #blogger-profile-controlDiv .follow').attr('src', $('#bloggerProfileDiv #blogger-profile-controlDiv .follow').attr('src').replace('follow1', 'follow2'));
      else
        $('#bloggerProfileDiv #blogger-profile-controlDiv .follow').attr('src', $('#bloggerProfileDiv #blogger-profile-controlDiv .follow').attr('src').replace('follow2', 'follow1'));

      $('#bloggerProfileDiv #blogger-profile-stats .blogger-profile-articlesDiv > p').text(response.blog.articles);
      $('#bloggerProfileDiv #blogger-profile-stats .blogger-profile-followersDiv > p').text(response.blog.followers);
      $('#bloggerProfileDiv #blogger-profile-stats .blogger-profile-followingDiv > p').text(response.blog.user_following);

      project.changePage('bloggerProfileDiv');



    }
    else
      project.changePage('registerDiv');

  }, 'json');
}

MenuLateral.prototype.hideMenu = function() {
  swipeleft = 1;
  menu_lateral_open = 0;

  $('#newsDiv').css('overflow-y', 'scroll');

  $('#newsDiv').animate({
    'left': '+=0%'
  }, 300, function() {
    if ($(this).css('left') != '0px')
      $(this).css('left', '0%');
  });

  $('#cat1Div').animate({
    'left': '+=0%'
  }, 300, function() {
    if ($(this).css('left') != '0px')
      $(this).css('left', '0%');
  });

  $('#cat2Div').animate({
    'left': '+=0%'
  }, 300, function() {
    if ($(this).css('left') != '0px')
      $(this).css('left', '0%');
  });

  $('#cat3Div').animate({
    'left': '+=0%'
  }, 300, function() {
    if ($(this).css('left') != '0px')
      $(this).css('left', '0%');
  });

  $('#menu-bar-top').animate({
    'left': '+=-85%'
  }, 300);

  $('#menuLateral-Content').animate({
    'left': '+=-85%'
  }, 300, function() {

    $('#menuLateral-Content .relativeDiv').scrollTop(0);
    $('#menuLateral-Content #input-menu-lateral-search').val('');
    $('#menuLateral-Content #input-menu-lateral-search').focusout();
    $('#menuLateralDiv').hide();
    $('#menuLateral-Content').hide();

  });
}

MenuLateral.prototype.swipe = function() {
  var self = this;

  $("#menuLateral-Content").unbind('touchmove');
  $(".news-feeds-category-div").unbind('touchmove');
  $(document).unbind('touchmove');
  //$(document).unbind('touchstart');

  $("#menuLateral-Content").swipe({
    left: function() {

      if (swipeleft == 0) {

        swipeleft = 1;
        menu_lateral_open = 0;

        if ($('#newsDiv').is(':visible')) {

          $('#newsDiv').css('overflow-y', 'scroll');

          $('#newsDiv').animate({
            'left': '+=-85%'
          }, 300);
        }
        else if ($('#cat1Div').is(':visible')) {
          $('#cat1Div').css('overflow-y', 'scroll');

          $('#cat1Div').animate({
            'left': '+=-85%'
          }, 300);
        }
        else if ($('#cat2Div').is(':visible')) {
          $('#cat2Div').css('overflow-y', 'scroll');

          $('#cat2Div').animate({
            'left': '+=-85%'
          }, 300);
        }
        else if ($('#cat3Div').is(':visible')) {
          $('#cat3Div').css('overflow-y', 'scroll');

          $('#cat3Div').animate({
            'left': '+=-85%'
          }, 300);
        }



        $('#menu-bar-top').animate({
          'left': '+=-85%'
        }, 300);

        $('#menuLateral-Content').animate({
          'left': '+=-85%'
        }, 300, function() {

          $('#menuLateral-Content .relativeDiv').scrollTop(0);
          $('#menuLateral-Content #input-menu-lateral-search').val('');
          $('#menuLateral-Content #input-menu-lateral-search').focusout();
          $('#menuLateralDiv').hide();
          $('#menuLateral-Content').hide();

        });

        news.activateSwipe();

      }

    }
  });

}

MenuLateral.prototype.decouvrirClick = function() {

  var dataToSend = new Object();
  dataToSend.user_id = $('#mainDiv').attr('user_id');

  $.post(project.back_url + 'blog/loadPopularBlogs/', {data: dataToSend}, function(response) {

    if (response.success == '1') {

      $('#discoverDiv #discover-blogs-div').html('');

      $.map(response.blogs, function(blog) {

        var check_src = 'img/discover/add-categories.png';

        if (blog.isSubscribed == '1')
          check_src = 'img/discover/check-categories.png';

        var discover_blog = '<div class="discover-blog"><img onclick="menulateral.loadBloggerProfile(' + blog.id + ')" class="discover-blogphoto" src="img/discover/hardcoded/foto.png"><div onclick="menulateral.loadBloggerProfile(' + blog.id + ')">';
        discover_blog += '<p class="discover-blogname">' + blog.name + '</p><p class="discover-blogcategory">Populaire</p></div>';
        discover_blog += '<img blog_id="' + blog.id + '" class="discover-blogfollow" src="' + check_src + '"></div>';

        $('#discoverDiv #discover-blogs-div').append(discover_blog);

        $('#discoverDiv #discover-blogs-div .discover-blogfollow').unbind();

        $('#discoverDiv #discover-blogs-div .discover-blogfollow').on('touchstart', function(e) {
          discover.SubscribeBlog($(this).attr('blog_id'), $(this));
        });


      });
      project.changePage('discoverDiv');
    } else
      console.log("No Session!");

  }, 'json');

}

MenuLateral.prototype.gererMonBlogClick = function() {
  var dataToSend = new Object();
  dataToSend.id = $('#mainDiv').attr('user_id');

  $.post(project.back_url + 'blog/getBlogByUserId/', {data: dataToSend}, function(response) {
    $('#gererMonBlogDiv #register-input-blogname').val(response.blog.name);
    $('#gererMonBlogDiv #register-input-blogurl').val(response.blog.url);

    var themes = response.blog.themes.split(' ');

    $.map(themes, function(theme) {
      $('#gererMonBlogDiv #register-themes-content > div > img').each(function() {
        if (theme == $(this).attr('theme'))
          $(this).attr('src', $(this).attr('src').replace('Off_', 'On_'));
      });
    });
  }, 'json');

  $.post(project.back_url + 'user/getGpoint/', {data: dataToSend}, function(response) {
    //console.log(response.gpoint);
    $('#gererMonBlogDiv #register-input-localization-gerer').val(response.gpoint.description);
    $('#gererMonBlogDiv #register-input-localization-gerer').attr('latitude', response.gpoint.latitude);
    $('#gererMonBlogDiv #register-input-localization-gerer').attr('longitude', response.gpoint.longitude);
    $('#gererMonBlogDiv #register-input-localization-gerer').attr('reference', response.gpoint.reference);
  }, 'json');

  $.post(project.back_url + 'user/getUser/', {data: dataToSend}, function(response) {
    $('#gererMonBlogDiv #register-biographie-div textarea').val(response.user.description);

    $('#gererMonBlogDiv').css('overflow-y', 'scroll');

    gerermonblog.googleAutoCompleteGererBlog();
    project.changePage('gererMonBlogDiv');
  }, 'json');
}

/*
 MenuLateral.prototype.closeClick = function() {
 $('#newsDiv').css('overflow-y', 'scroll');
 
 $('#menuLateralDiv').animate({
 'left': '+=-100%'
 }, 300, function() {
 $('#menuLateral-Content .relativeDiv').scrollTop(0);
 $('#menu-bar-top').css('visibility', 'visible');
 $('#menuLateral-Content #input-menu-lateral-search').val('');
 $('#menuLateral-Content #input-menu-lateral-search').focusout();
 $('#menuLateralDiv').hide();
 $('#menuLateral-Content').hide();
 });
 
 $('#menuLateral-Content').animate({
 'left': '+=-100%'
 }, 300, function() {
 $('#menuLateralDiv').hide();
 $('#menuLateral-Content').hide();
 });
 
 
 }*/

/*********************************  END MENU LATERAL *******************************************************************/

/*********************************  START EXPLORE *******************************************************************/

function Explore() {


}

Explore.prototype.topSubmenuChange = function(element) {
  element.parent().find('p').css('color', '#a5a5a5');
  element.css('color', '#F04657');
  var get_url = project.back_url;
  if (element.text() == 'Copines')
    get_url += 'blog/listCopinesBlogs/';
  else
    get_url += 'blog/listPopulaireBlogs/';

  $.get(get_url, function(response) {

    $('#explore-copinesDiv').html('');

    $.map(response.blogs, function(blog, index) {

      if (index == 0) {
        $('#exploreDiv #explore-premiumPlace').find('.blogid').text(blog.blogid);
        $('#exploreDiv #explore-premiumPlace').find('.explore-title').text(blog.blogname);
        $('#exploreDiv #explore-premiumPlace').find('.explore-sets > p').each(function(i, value) {
          if (i == 0)
            $(value).text(blog.usercity);
          else
            $(value).text(blog.theme);
        });
      }
      else {
        var explorediv = '<div><span class="blogid">' + blog.blogid + '</span><img src="img/explore/image_3.png"><div class="explore-text-div"><p class="explore-title">' + blog.blogname + '</p>';
        explorediv += '<div class="explore-sets"><img src="img/explore/map.png"><p>' + blog.usercity + '</p><img class="explore-img-bag" src="img/explore/bag.png">';
        explorediv += '<p>' + blog.theme + '</p></div><img onclick="explore.subscribeClick($(this))" src="img/explore/plus.png"></div></div>';
        $('#explore-copinesDiv').append(explorediv);
      }
    });
  }, 'json');
}

Explore.prototype.subscribeClick = function(element) {
  var dataToSend = new Object();
  dataToSend.user_id = $('#mainDiv').attr('user_id');
  dataToSend.blog_id = element.parent().parent().find('.blogid').text();

  if (element.attr('src') == 'img/explore/check.png') {
    element.attr('src', element.attr('src').replace('check.png', 'plus.png'));
    $.post(project.back_url + 'blog/removeSubscriptionFromUserAndBlog', {data: dataToSend});
  }
  else {
    element.attr('src', element.attr('src').replace('plus.png', 'check.png'));
    $.post(project.back_url + 'blog/newSubscription/', {data: dataToSend});
  }
}

Explore.prototype.menuClick = function() {
  swipeleft = 0;
  $('#newsDiv').css('overflow-y', 'hidden');

  $('#menuLateralDiv').css('left', '-100%');
  $('#menuLateral-Content').css('left', '-100%');

  $('#menuLateralDiv').show();
  $('#menuLateral-Content').show();

  $('#menuLateralDiv').animate({
    'left': '+=100%'
  }, 300);

  $('#menuLateral-Content').animate({
    'left': '+=100%'
  }, 300);
}


/*********************************  END EXPLORE *******************************************************************/

/*********************************  START BLOGGER *******************************************************************/

function Blogger() {

}

Blogger.prototype.closeClick = function() {
  menulateral.hideMenu();
  project.changePage('newsDiv');
}

Blogger.prototype.followClick = function() {
  var btn_follow = $('#bloggerProfileDiv #blogger-profile-controlDiv .follow');

  var dataToSend = new Object();
  dataToSend.user_id = $('#mainDiv').attr('user_id');
  dataToSend.blog_id = $('#bloggerProfileDiv').attr('blog_id');

  if (btn_follow.attr('src').indexOf('follow1') != -1) {
    btn_follow.attr('src', btn_follow.attr('src').replace('follow1', 'follow2'));
    $.post(project.back_url + 'blog/newSubscription/', {data: dataToSend}, function(response) {
      console.log(response);
    }, 'json');
  }
  else {
    btn_follow.attr('src', btn_follow.attr('src').replace('follow2', 'follow1'));
    $.post(project.back_url + 'blog/removeSubscriptionByUserAndBlog/', {data: dataToSend}, function(response) {
      console.log(response);
    }, 'json');
  }


}

Blogger.prototype.bloggerButtonsClick = function(element) {
  element.parent().parent().find('#blogger-content > div').hide();
  element.parent().find('p').css('color', '#494949');
  element.css('color', '#ef3245');

  if (element.text() == 'Articles')
    element.parent().parent().find('#blogger-content > div#blogger-articles').show();
  else if (element.text() == 'Intêrets') {
    element.parent().parent().find('#blogger-content > div#blogger-interets').fadeIn(function() {

      var dataToSend = new Object();
      dataToSend.id = $('#mainDiv').attr('user_id');

      $.post(project.back_url + '/user/getGPoints/', {data: dataToSend}, function(response) {
        if (response.success == 1)
          blogger.loadGoogleMap(response.gpoints);
        else
          alert('Error getting data!');
      }, 'json');

    });

  }
  else if (element.text() == 'Copines')
    element.parent().parent().find('#blogger-content > div#blogger-copines').show();
}

Blogger.prototype.loadGoogleMap = function(gpoints) {
  var self = this;

  var longs = [];
  var lats = [];
  var references = [];
  $.map(gpoints, function(gpoint) {
    longs.push(gpoint.longitude);
    lats.push(gpoint.latitude);
    references.push(gpoint.reference);
  });

  var bounds = new google.maps.LatLngBounds();

  for (var i = 0; i < gpoints.length; i++) {
    var map = new google.maps.Map(document.getElementById('map-canvas'), {
      center: new google.maps.LatLng(lats[i], longs[i]),
      zoom: 8
    });

    var infowindow = new google.maps.InfoWindow();
    var service = new google.maps.places.PlacesService(map);
    service.getDetails({reference: references[i]}, function(place, status) {
      if (status == google.maps.places.PlacesServiceStatus.OK) {
        var marker = new google.maps.Marker({
          map: map,
          position: place.geometry.location,
        });
        google.maps.event.addListener(marker, 'click', function() {
          infowindow.setContent(place.name);
          infowindow.open(map, this);
        });
      }
    });
    bounds.extend(new google.maps.LatLng(lats[i], longs[i]));
  }
  map.fitBounds(bounds);
}

/*********************************  END BLOGGER *******************************************************************/

/*********************************  START READER *******************************************************************/

function Reader() {

}

Reader.prototype.readerButtonsClick = function(element) {
  element.parent().parent().find('#blogger-content > div').hide();
  element.parent().find('p').css('color', '#494949');
  element.css('color', '#ef3245');

  if (element.text() == 'Activité')
    element.parent().parent().find('#blogger-content > div#reader-activite').show();
  else if (element.text() == 'Pocket')
    element.parent().parent().find('#blogger-content > div#reader-pocket').show();
  else if (element.text() == 'Following')
    element.parent().parent().find('#blogger-content > div#reader-following').show();
}

/*********************************  END READER *******************************************************************/

/*********************************  START ARTIGO *******************************************************************/

function Artigo() {

}

/*Artigo.prototype.goToArticle = function(element) {
 var self = this;
 
 var blog_id = element.attr('blog_id');
 var feed_id = element.attr('feed_id');
 var user_id = $('#mainDiv').attr('user_id');
 
 $('#artigoDiv').hide(function() {
 
 $('#artigoDiv').attr('artigoid', element.find('.feed-id').val());
 $('#artigoDiv').attr('blogid', element.find('.blog-id').val());
 artigo.loadArticle(element.find('.feed-id').val(), element.find('.blog-id').val());
 project.changePage('artigoDiv');
 
 $("html, body").animate({
 scrollTop: 0
 }, 500, function() {
 $('#artigoDiv').show();
 });
 
 });
 }*/

Artigo.prototype.heartClick = function(element) {
  var self = this;

  var article_id = element.attr('article_id');
  var blog_id = element.attr('blog_id');

  if (element.attr('src').indexOf('like.png') !== -1) {
    element.attr('src', element.attr('src').replace('like.png', 'like_line.png'));
    var dataToSend = new Object();
    dataToSend.user_id = $('#mainDiv').attr('user_id');
    dataToSend.article_id = article_id;
    dataToSend.blog_id = blog_id;
    $.post(project.back_url + 'blog/removeArticleLike/', {data: dataToSend});
  }
  else {
    element.attr('src', element.attr('src').replace('like_line.png', 'like.png'));
    var dataToSend = new Object();
    dataToSend.user_id = $('#mainDiv').attr('user_id');
    dataToSend.article_id = article_id;
    dataToSend.blog_id = blog_id;
    $.post(project.back_url + 'blog/makeArticleLike/', {data: dataToSend});
  }
}

Artigo.prototype.loadComments = function(element) {
  var self = this;

  $('#commentMainDiv > div').html('');
  $('#commentDiv #comment-input-div > input').attr('article_id', element.attr('article_id'));
  $('#commentDiv #comment-input-div > input').attr('blog_id', element.attr('blog_id'));
  $('#commentDiv #comment-input-div > input').val('');

  var dataToSend = new Object();
  dataToSend.user_id = $('#mainDiv').attr('user_id');
  dataToSend.article_id = element.attr('article_id');
  dataToSend.blog_id = element.attr('blog_id');

  $.post(project.back_url + 'blog/getComments/', {data: dataToSend}, function(response) {

    if (response.success == '1') {

      $.map(response.comments, function(comment) {
        var comment_div = '<div class="comment"><img src="img/comment/image_1.png"><div class="comment-container"><div><p>' + comment.user_name + '</p>';
        comment_div += '<p class="timepast">' + comment.timePast + '</p></div><p>' + comment.content + '</p></div></div>';
        $('#commentMainDiv > div').append(comment_div);
      });

      $('#commentMainDiv > div').append('<div class="comment-bottom-spacer"></div>');

      project.changePage('commentDiv');

      $('#commentMainDiv > div').css('overflow', 'hidden');
      $('#commentMainDiv > div .comment').css('overflow', 'hidden');

      myScroll6 = new IScroll('#commentMainDiv');
    }
    else
      console.log('No Session!');

  }, 'json');

}

Artigo.prototype.backClick = function() {
  article_open = 0;
  project.changePage('newsDiv');
  menulateral.hideMenu();
}

Artigo.prototype.loadArticle = function(feed_id) {
  var self = this;

  if (menu_lateral_open == 1)
    return;

  article_open = 1;

  var dataToSend = new Object();
  dataToSend.user_id = $('#mainDiv').attr('user_id');
  dataToSend.article_id = feed_id;

  $.post(project.back_url + 'blog/getArticleInfo/', {data: dataToSend}, function(response) {
    var article = response.article;

    var image = "";

    if (article.id == 27)
      image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/selectionaccesoiresbureau_featured.png";
    else if (article.id == 28)
      image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/1601319_425697720908397_251263012_n.jpg";
    else if (article.id == 30)
      image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/painted-bottle-vases03-728x405.jpg";
    else if (article.id == 26)
      image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/Gallery-S-Bensimon-X-La-Redoute-700x405.jpg";
    else if (article.id == 29)
      image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/P1070665-760x405.jpg";

    if (article.has_like == '1')
      $('#artigoDiv .artigo-like').attr('src', $('#artigoDiv .artigo-like').attr('src').replace('like_line.png', 'like.png'));

    $('#artigoDiv .artigo-like, #artigoDiv .artigo-comment, , #artigoDiv .artigo-share').attr('article_id', article.id);
    $('#artigoDiv .artigo-like, #artigoDiv .artigo-comment, , #artigoDiv .artigo-share').attr('blog_id', article.blog_id);

    $('#artigoDiv #redir-btn-original').attr('href', article.url);

    $('#artigoDiv #artigo-date').text(news.convertTimeFormat(article.created_at));
    $('#artigoDiv #artigo-title').text(article.title);

    $('#artigoDiv #artigo-blogger-photo').attr('onclick', 'menulateral.loadBloggerProfile(' + article.blog_id + ')');

    $('#artigoDiv #artigo-revue-text').html('<span>Par</span> ' + article.blogname);
    $('#article-data-div').html(article.content);
    $("#galleryDiv > img").attr('src', image);

    var data_prochaine = new Object();
    data_prochaine.article_id = feed_id;

    $.post(project.back_url + 'blog/getProchainesHistoires/', {data: data_prochaine}, function(response) {

      if (response.success == '1') {

        $('#artigoDiv #next-articles .next-article-feed').remove();

        $.map(response.articles, function(art) {

          var next_story = '<div class="next-article-feed" article_id="' + art.id + '">';
          next_story += '<input class="article-id" type="hidden" value="' + art.id + '">';
          next_story += '<img src="img/news/image4.png">';
          next_story += '<p class="next-article-title">' + art.title + '</p>';
          next_story += '<p>' + art.content + '</p>';
          next_story += '<div class="next-article-feed-arrow-div">';
          next_story += '<img src="img/news/next.png">';
          next_story += '</div></div>';

          $('#artigoDiv #next-articles').append(next_story);
        });
        
        $('#artigoDiv #next-articles .next-article-feed').unbind();
        $('#artigoDiv #next-articles .next-article-feed').on('touchstart', function(e) {
          artigo.loadArticle($(this).attr('article_id'));
        });

        project.changePage('artigoDiv');

      }
      else
        project.changePage('registerDiv');

    }, 'json');


  }, 'json');
}

Artigo.prototype.loadNextFeed = function(feed_id, blog_id) {
  var nextFeed = '<div class="next-article-feed" onclick="artigo.loadArticle(' + feed_id + ')"><input class="feed-id" type="hidden" value="' + feed_id + '"><input class="blog-id" type="hidden" value="' + blog_id + '">';
  nextFeed += '<img onclick="" src="img/news/image3.png"><p class="next-article-title">NYC Fasion week</p>';
  nextFeed += '<p>I\'m just heading home after an awesome Fashion Week...</p><div class="next-article-feed-arrow-div" onclick="alert(\'go to this feed\')">';
  nextFeed += '<img src="img/news/next.png"></div></div>';
  $('#next-articles').append(nextFeed);
}

Artigo.prototype.likeClick = function(element) {
  var blog_id = $('#artigoDiv').attr('blogid');
  var feed_id = $('#artigoDiv').attr('artigoid');

  if (element.attr('src').indexOf('heart.png') !== -1) {
    element.attr('src', element.attr('src').replace('heart.png', 'heart2.png'));
    var current_likes = element.parent().find('.red').text();
    current_likes = parseInt(current_likes) - 1;
    element.parent().find('.red').text(current_likes);

    var dataToSend = new Object();
    dataToSend.user_id = $('#mainDiv').attr('user_id');
    dataToSend.article_id = feed_id;
    dataToSend.blog_id = blog_id;
    $.post(project.back_url + 'blog/removeArticleLike/', {data: dataToSend});
  }
  else {
    element.attr('src', element.attr('src').replace('heart2.png', 'heart.png'));
    var current_likes = element.parent().find('.red').text();
    current_likes = parseInt(current_likes) + 1;
    element.parent().find('.red').text(current_likes);

    var dataToSend = new Object();
    dataToSend.user_id = $('#mainDiv').attr('user_id');
    dataToSend.article_id = feed_id;
    dataToSend.blog_id = blog_id;
    $.post(project.back_url + 'blog/makeArticleLike/', {data: dataToSend});
  }

}

/*********************************  END ARTIGO *******************************************************************/

/*********************************  START POCKET *******************************************************************/

function Pocket() {

}

Pocket.prototype.search = function(input) {
  var keyword = input.val().toLowerCase();
  $('#pocketDiv .pocket-container > div.pocket').each(function() {
    var title = $(this).find('p.pocket-title').text().toLowerCase();
    var url = $(this).find('p.pocket-text').text().toLowerCase();

    if (title.indexOf(keyword) !== -1)
      $(this).show();
    else if (url.indexOf(keyword) !== -1)
      $(this).show();
    else
      $(this).hide();


  });

}

/*********************************  END POCKET *******************************************************************/

/*********************************  START LOGIN SLIDER *******************************************************************/

function LoginSlider() {
  this.etape = 1;
}

LoginSlider.prototype.next = function() {
  this.etape = parseInt(this.etape) + 1;
  $('#loginsliderDiv .sliderContent > div').hide();
  $('#loginsliderDiv .pointsDiv > div > img').attr('src', 'img/login_slider/bullet_2.png');
  $('#loginsliderDiv .pointsDiv > div > img.point-' + this.etape).attr('src', 'img/login_slider/bullet_1.png');
  $('#loginsliderDiv .sliderContent > div.etape-' + this.etape).show();

  if (this.etape == 3)
    $('#loginsliderDiv .nextsliderDiv > p').text("S'inscrire");
  else if (this.etape == 4)
    project.changePage('registerDiv');
}
/*********************************  END LOGIN SLIDER *******************************************************************/

/*********************************  START REGISTER *******************************************************************/

function Register() {

}

Register.prototype.socialAddClick = function(element) {

  if (element.attr('src').indexOf('add_') != -1)
    element.attr('src', element.attr('src').replace('add_', ''));
  else
    element.attr('src', element.attr('src').replace('social-icons/', 'social-icons/add_'));

}

Register.prototype.blogThemesClick = function(element) {

  var num_themes = 0;
  $(element).parent().find('img').each(function() {
    if ($(this).attr('src').indexOf('On_') != -1) {
      num_themes = parseInt(num_themes) + 1;
    }
  });

  if (element.attr('src').indexOf('Off') != -1) {
    if (num_themes >= 3)
      return;
    element.attr('src', element.attr('src').replace('Off', 'On'));
  }
  else
    element.attr('src', element.attr('src').replace('On', 'Off'));
}

Register.prototype.userThemeClick = function(element) {
  var self = this;
  var theme = element.attr('theme');

  var num_themes = 0;
  $(element).parent().find('div > img').each(function() {
    if ($(this).is(':visible')) {
      num_themes = parseInt(num_themes) + 1;
    }
  });

  if (element.find('img').is(':visible'))
    element.find('img').hide();
  else {

    if (num_themes >= 3)
      return;

    element.find('img').show();
  }
}

Register.prototype.getPhoto = function() {
  navigator.camera.getPicture(function(data) {
    $('#register-photo')
            .attr('src', 'data:image/jpeg;base64,' + data)
            .css('visibility', 'visible');

  }, function(error) {
    console.log('Error');
  }, {
    destinationType: Camera.DestinationType.DATA_URL,
    sourceType: Camera.PictureSourceType.PHOTOLIBRARY,
    allowEdit: false,
    targetWidth: 260,
    targetHeight: 435,
    mediaType: Camera.MediaType.PICTURE
  });
}

Register.prototype.getPhoto2 = function(source) {

  // Retrieve image file location from specified source
  navigator.camera.getPicture(onPhotoURISuccess, onFail, {quality: 50,
    destinationType: destinationType.FILE_URI,
    sourceType: source});


}

Register.prototype.stepOne = function() {
  var self = this;
  self.user = new Object();
  var themes = '';

  $('#register-etape1 #user-themes-div > div').each(function() {
    if ($(this).find('img').is(':visible'))
      themes += $(this).attr('theme') + ' ';
  });

  themes = themes.trim();
  var count = themes.split(' ').length;

  if (count < 3) {
    project.displayError($('#register-etape1 #user-themes-div'), "Vous devez choisir au moins 3 thémes");
    return;
  }

  self.user.user_themes = themes;
  self.changeStep('2');
}

Register.prototype.stepTwo = function(element) {
  var self = this;

  var input_name = $('#registerDiv #register-etape2 #register-input-name');
  var input_email = $('#registerDiv #register-etape2 #register-input-email');
  var input_password = $('#registerDiv #register-etape2 #register-input-password');

  if (input_name.val() == '') {
    project.displayError(input_name.parent(), "Le champ Nom est obligatoire");
    return;
  }

  if (input_name.val().split(' ').length < 2) {
    project.displayError(input_name.parent(), "Vous devez entrer votre nom complet");
    return;
  }

  if (!project.validateAlpha(input_name.val())) {
    project.displayError(input_name.parent(), "Le champ Nom n'est pas valide");
    return;
  }

  if (input_email.val() == '') {
    project.displayError(input_email.parent(), "Le champ Mail est obligatoire");
    return;
  }

  if (!project.validateEmail(input_email.val())) {
    project.displayError(input_email.parent(), "Le champ Mail n'est pas valide");
    return;
  }

  if (input_password.val() == '') {
    project.displayError(input_password.parent(), "Le champ Password est obligatoire");
    return;
  }

  if (input_password.val().length < 6 || input_password.val().length > 20) {
    project.displayError(input_password.parent(), "Le mot de passe doit être d'au moins 6 caractères et au plus 20");
    return;
  }

  if (!project.validatePassword(input_password.val())) {
    project.displayError(input_password.parent(), "Le champ Password n'est pas valide");
    return;
  }

  var dataToSend = new Object();
  dataToSend.firstname = input_name.val().split(' ')[0];
  dataToSend.name = '';

  for (var i = 1; i < input_name.val().split(' ').length; i++)
    dataToSend.name += input_name.val().split(' ')[i] + ' ';

  dataToSend.name = dataToSend.name.trim();
  dataToSend.email = input_email.val();
  dataToSend.password = input_password.val();
  dataToSend.themes = self.user.user_themes.trim();

  if (element.attr('id') == 'subscription-blogger-button')
    dataToSend.type = 1;
  else
    dataToSend.type = 0;

  $.post(project.back_url + 'user/newUser/', {data: dataToSend}, function(response) {

    if (response.success == 1) {
      // User saved on DB
      self.user.name = response.message.first_name + ' ' + response.message.name;
      self.user.email = response.message.email;
      self.user.password = response.message.password;
      self.user.user_id = response.message.id;
      self.user.type = response.message.type;

      input_name.val('');
      input_email.val('');
      input_password.val('');

      if (response.message.type == '1')
        self.changeStep('3');
      else
        project.changePage('newsDiv');

    }
    else if (response.field == 'themes')
      self.changeStep('1');
    else
      project.displayError($('#registerDiv #register-etape2 #register-input-' + response.field).parent(), response.message);
  }, 'json');
}

Register.prototype.stepThreeBlogger = function(element) {
  var self = this;

  var blogname = $('#register-etape3 #register-input-blogname');
  var blogurl = $('#register-etape3 #register-input-blogurl');
  var gpoint = $('#register-etape3 #register-input-localization');
  var biographie = $('#register-etape3 #register-biographie-div textarea');
  var themes = '';
  var num_themes = 0;

  if (blogname.val() == '') {
    project.displayError(blogname.parent(), "Le champ Nom du Blog est obligatoire");
    return;
  }

  if (!project.validateAlpha(blogname.val())) {
    project.displayError(blogname.parent(), "Le champ Nom du Blog n'est pas valide");
    return;
  }

  if (gpoint.val() == '') {
    project.displayError(gpoint.parent(), "Le champ Localisation est obligatoire");
    return;
  }

  if (gpoint.attr('reference') == '' || gpoint.attr('longitude') == '' || gpoint.attr('latitude') == '') {
    project.displayError(gpoint.parent(), "Le champ Localisation n'est pas valide");
    return;
  }

  if (blogurl.val() == '') {
    project.displayError(blogurl.parent(), "Le champ Adresse URL est obligatoire");
    return;
  }

  if (!project.validateURL(blogurl.val())) {
    project.displayError(blogurl.parent(), "Le champ Adresse URL n'est pas valide");
    return;
  }

  $('#register-etape3 #register-themes-content > div > img').each(function() {
    if ($(this).attr('src').indexOf('On_') != -1) {
      themes += $(this).attr('theme') + ' ';
      num_themes = parseInt(num_themes) + 1;
    }
  });

  themes = themes.trim();

  if (num_themes < 1) {
    project.displayError($('#register-etape3 #register-themes-content'), "Vous devez choisir au moins 1 catégorie");
    return;
  }

  if (num_themes > 3) {
    project.displayError($('#register-etape3 #register-themes-content'), "Vous devez choisir au plus trois catégories");
    return;
  }

  if (biographie.val() == '') {
    project.displayError(biographie.parent(), "Le champ À propos est obligatoire");
    return;
  }

  /*
   $('#register-etape3 #register-social-div img').each(function(){
   
   //if($(this).attr('src').indexOf('add_') == -1){
   
   //}
   
   });*/

  //console.log(self.user);

  var dataUser = new Object();
  dataUser.id = self.user.user_id;
  dataUser.description = biographie.val().trim();

  var dataToSend = new Object();
  dataToSend.user_id = self.user.user_id;
  dataToSend.name = blogname.val();
  dataToSend.url = blogurl.val();
  dataToSend.themes = themes.trim();

  var dataGpoint = new Object();
  dataGpoint.user_id = self.user.user_id;
  dataGpoint.description = gpoint.val().trim();
  dataGpoint.reference = gpoint.attr('reference').trim();
  dataGpoint.latitude = gpoint.attr('latitude').trim();
  dataGpoint.longitude = gpoint.attr('longitude').trim();

  $.post(project.back_url + 'user/updateUser/', {data: dataUser}, function(response) {

    if (response.success == '1') {

      $.post(project.back_url + 'blog/newBlog/', {data: dataToSend}, function(response) {

        if (response.success == 1) {

          self.user.themes = themes;
          self.user.blogname = blogname.val();
          self.user.blogurl = blogurl.val();
          self.user.blog_id = response.message.id;

          $.post(project.back_url + 'user/saveGPoint/', {data: dataGpoint}, function(response) {

            if (response.success == 1) {

              self.user.gpoint_description = response.gpoint.description;
              self.user.gpoint_reference = response.gpoint.reference;
              self.user.gpoint_latitude = response.gpoint.latitude;
              self.user.gpoint_longitude = response.gpoint.longitude;


              //project.changePage('newsDiv');
              self.autoLogin();
            }
            else
              console.log(response);

          }, 'json');

        }
        else if (response.field == 'themes')
          project.displayError($('#registerDiv #register-etape3b #register-themes-content'), response.message);
        else
          project.displayError($('#registerDiv #register-etape3b #register-input-' + response.field).parent(), response.message);
      }, 'json');

    }
    else
      console.log('No session!');

  }, "json");



}

/*Register.prototype.stepSevenBlogger = function() {
 var self = this;
 var count_places = 0, loop = 0;
 
 $('#register-etape7b input').each(function() {
 
 var dataToSend = new Object();
 dataToSend.description = $(this).val();
 dataToSend.user_id = self.user.user_id;
 dataToSend.latitude = $(this).attr('latitude');
 dataToSend.longitude = $(this).attr('longitude');
 dataToSend.reference = $(this).attr('reference');
 
 if (dataToSend.latitude == '' || dataToSend.description == '' || dataToSend.longitude == '' || dataToSend.reference == '') {
 
 if (loop >= 3 && count_places == 0)
 project.displayError($('#register-etape7b #register-input-gpoint1').parent(), "Le champ adresses préférées est obligatoire");
 
 loop++;
 return;
 }
 
 $.post(project.back_url + 'user/saveGPoints/', {data: dataToSend}, function() {
 count_places++;
 loop++;
 }, "json");
 });
 
 self.autoLogin();
 }*/

Register.prototype.autoLogin = function() {
  var self = this;
  $('#mainDiv').attr('user_id', self.user.user_id);

  var dataToSend = new Object();
  dataToSend.email = self.user.email;
  dataToSend.password = self.user.password;

  $.post(project.back_url + 'user/autoLogin/', {data: dataToSend}, function(response) {
    if (response.success == '1') {

      var frag_name = self.user.name.split(' ');
      self.user.first_name = frag_name[0];
      self.user.name = frag_name[1];

      project.loadCat();

      menulateral.loadMenu(self.user);
      project.changePage('newsDiv');
    } else
      project.changePage('landingLoginDiv');
  }, 'json');
}

Register.prototype.googleAutoComplete = function() {
  var self = this;

  var input_id = 'register-input-localization';

  google_autocomplete = new google.maps.places.Autocomplete((document.getElementById(input_id)), {types: ['geocode']});

  google.maps.event.addListener(google_autocomplete, 'place_changed', function() {
    var place = google_autocomplete.getPlace();
    $('#' + input_id).attr('latitude', place.geometry.location.lat());
    $('#' + input_id).attr('longitude', place.geometry.location.lng());
    $('#' + input_id).attr('reference', place.reference);
  });
}

Register.prototype.changeStep = function(num) {
  var self = this;
  //$('#registerDiv > div').hide();

  if (num == '3') {
    $('#registerDiv > div').hide();
    $('#registerDiv > #register-etape' + num).fadeIn(function() {
      self.googleAutoComplete();
    });
  }
  else if (num == '1') {
    var height = $('#registerDiv').height();

    $('#registerDiv > div').css('height', height);
    $('#registerDiv > #register-etape' + num).show();
    $('#registerDiv').css('height', (parseInt(height) * 2) + 'px');

    $('#registerDiv').animate({
      'margin-top': '+=-' + height + 'px'
    }, 1000, function() {

      $('#registerDiv > div').each(function() {
        if ($(this).attr('id') != 'register-etape' + num)
          $(this).hide();
      });

      $(this).css('margin-top', '0');
      $(this).css('height', '100%');
      $('#registerDiv > div').css('height', '100%');
      $('#registerDiv').css('height', '100%');
    });
  }
  else {
    $('#registerDiv > div').hide();
    $('#registerDiv > #register-etape' + num).fadeIn();
  }
}


/*********************************  END REGISTER *******************************************************************/

/*********************************  START GERER MON BLOG *******************************************************************/

function GererMonBlog() {

}

GererMonBlog.prototype.tabClick = function(element) {
  var self = this;

  console.log(element.attr('tab'));
  if (element.attr('tab') == 'profil') {

  }
  else if (element.attr('tab') == 'statistiques') {
  }
}

GererMonBlog.prototype.googleAutoCompleteGererBlog = function() {
  var self = this;

  var input_id = 'register-input-localization-gerer';

  google_autocomplete_gererblog = new google.maps.places.Autocomplete((document.getElementById(input_id)), {types: ['geocode']});

  google.maps.event.addListener(google_autocomplete_gererblog, 'place_changed', function() {
    var place = google_autocomplete_gererblog.getPlace();
    $('#' + input_id).attr('latitude', place.geometry.location.lat());
    $('#' + input_id).attr('longitude', place.geometry.location.lng());
    $('#' + input_id).attr('reference', place.reference);
  });
}

GererMonBlog.prototype.termineClick = function() {
  var self = this;

  var blogname = $('#gererMonBlogDiv #register-input-blogname');
  var blogurl = $('#gererMonBlogDiv #register-input-blogurl');
  var gpoint = $('#gererMonBlogDiv #register-input-localization-gerer');
  var biographie = $('#gererMonBlogDiv #register-biographie-div textarea');
  var themes = '';
  var num_themes = 0;

  if (blogname.val() == '') {
    project.displayError(blogname.parent(), "Le champ Nom du Blog est obligatoire");
    return;
  }

  if (!project.validateAlpha(blogname.val())) {
    project.displayError(blogname.parent(), "Le champ Nom du Blog n'est pas valide");
    return;
  }

  if (gpoint.val() == '') {
    project.displayError(gpoint.parent(), "Le champ Localisation est obligatoire");
    return;
  }

  if (gpoint.attr('reference') == '' || gpoint.attr('longitude') == '' || gpoint.attr('latitude') == '') {
    project.displayError(gpoint.parent(), "Le champ Localisation n'est pas valide");
    return;
  }

  if (blogurl.val() == '') {
    project.displayError(blogurl.parent(), "Le champ Adresse URL est obligatoire");
    return;
  }

  if (!project.validateURL(blogurl.val())) {
    project.displayError(blogurl.parent(), "Le champ Adresse URL n'est pas valide");
    return;
  }

  $('#gererMonBlogDiv #register-themes-content > div > img').each(function() {
    if ($(this).attr('src').indexOf('On_') != -1) {
      themes += $(this).attr('theme') + ' ';
      num_themes = parseInt(num_themes) + 1;
    }
  });

  themes = themes.trim();

  if (num_themes < 1) {
    project.displayError($('#gererMonBlogDiv #register-themes-content'), "Vous devez choisir au moins 1 catégorie");
    return;
  }

  if (num_themes > 3) {
    project.displayError($('#gererMonBlogDiv #register-themes-content'), "Vous devez choisir au plus trois catégories");
    return;
  }

  if (biographie.val() == '') {
    project.displayError(biographie.parent(), "Le champ À propos est obligatoire");
    return;
  }

  /*
   $('#register-etape3 #register-social-div img').each(function(){
   
   //if($(this).attr('src').indexOf('add_') == -1){
   
   //}
   
   });*/

  //console.log(self.user);

  var dataUser = new Object();
  dataUser.id = $('#mainDiv').attr('user_id');
  dataUser.description = biographie.val().trim();

  var dataToSend = new Object();
  dataToSend.user_id = $('#mainDiv').attr('user_id');
  dataToSend.name = blogname.val();
  dataToSend.url = blogurl.val();
  dataToSend.themes = themes.trim();

  var dataGpoint = new Object();
  dataGpoint.user_id = $('#mainDiv').attr('user_id');
  dataGpoint.description = gpoint.val().trim();
  dataGpoint.reference = gpoint.attr('reference').trim();
  dataGpoint.latitude = gpoint.attr('latitude').trim();
  dataGpoint.longitude = gpoint.attr('longitude').trim();

  $.post(project.back_url + 'user/updateUser/', {data: dataUser}, function(response) {

    if (response.success == '1') {

      $.post(project.back_url + 'blog/updateBlogByUserId/', {data: dataToSend}, function(response) {

        if (response.success == 1) {

          $.post(project.back_url + 'user/updateGpointByUserId/', {data: dataGpoint}, function(response) {

            if (response.success == 1) {
              menulateral.load();
              menulateral.hideMenu();
              project.changePage('newsDiv');
            }
            else
              project.changePage('registerDiv');

          }, 'json');

        }
        else if (response.field == 'themes')
          project.displayError($('#gererMonBlogDiv #register-themes-content'), response.message);
        else
          project.displayError($('#gererMonBlogDiv #register-input-' + response.field).parent(), response.message);
      }, 'json');

    }
    else
      console.log('No session!');

  }, "json");




}

/*********************************  END GERER MON BLOG *******************************************************************/

/*********************************  START COMMENT *******************************************************************/


function Comment() {

  $('#commentDiv #comment-input-div > img').on('touchstart', function(e) {
    $('#commentDiv input').focusout();
    comment.createComment($(this));
  });

  $('#commentDiv #menu-bar-top-comment #comment-menu-bar-termine').on('touchstart', function(e) {
    comment.termineClick();
  });

}

Comment.prototype.termineClick = function() {
  article_open = 0;
  project.changePage('newsDiv');
}

Comment.prototype.createComment = function(element) {
  var self = this;

  element = element.parent().find('input');

  if (element.val() == '')
    return;

  var dataToSend = new Object();
  dataToSend.user_id = $('#mainDiv').attr('user_id');
  dataToSend.article_id = element.attr('article_id');
  dataToSend.content = element.val();

  $.post(project.back_url + 'blog/createComment/', {data: dataToSend}, function(response) {

    if (response.success == '1') {
      element.val('');
      artigo.loadComments(element);
    }
    else
      project.changePage('registerDiv');

  }, 'json');


}


/*********************************  END COMMENT *******************************************************************/

/*********************************  START CATEGORY *******************************************************************/

function Category() {

}

Category.prototype.activateSwipe = function() {
  setTimeout(function() {
    category_swipe = 0;
  }, 500);
}

Category.prototype.termineClick = function() {
  var themes = [];

  $('#categoryDiv #category-slider-div > div').each(function() {
    if ($(this).attr('hide') == '1')
      return;

    if ($(this).find('img').attr('src').indexOf('check-') != -1)
      themes.push($(this).attr('category'));
  });

  if (parseInt(themes.length) == 0) {
    $('#categoryDiv #category-message > p').hide();
    $('#categoryDiv #category-message .minimum').show();
    return;
  }
  else if (parseInt(themes.length) > 3) {
    $('#categoryDiv #category-message > p').hide();
    $('#categoryDiv #category-message .maximum').show();
    return;
  }

  var s_themes = '';
  $.map(themes, function(theme) {
    s_themes += theme + ' ';
  });

  var dataToSend = new Object();
  dataToSend.id = $('#mainDiv').attr('user_id');
  dataToSend.themes = s_themes.trim();

  $.post(project.back_url + 'user/updateUser/', {data: dataToSend}, function(response) {
    if (response.success == '1') {
      project.changePage('newsDiv');
      menulateral.hideMenu();
    }
    else
      console.log("No Session!");
  }, 'json');
}

Category.prototype.addClick = function(element) {

  var themes = [];

  $('#categoryDiv #category-slider-div > div').each(function() {
    if ($(this).attr('hide') == '1')
      return;

    if ($(this).find('img').attr('src').indexOf('check-') != -1)
      themes.push($(this).attr('category'));
  });

  if (element.attr('src').indexOf('add-') != -1) {
    if (themes.length >= 3) {
      $('#categoryDiv #category-message > p').hide();
      $('#categoryDiv #category-message .maximum').show();
      return;
    }

    element.attr('src', element.attr('src').replace('add-', 'check-'));
  }
  else
    element.attr('src', element.attr('src').replace('check-', 'add-'));


}

Category.prototype.loadCategories = function() {
  var dataToSend = new Object();
  dataToSend.id = $('#mainDiv').attr('user_id');

  $.post(project.back_url + 'user/getUser/', {data: dataToSend}, function(response) {

    if (response.success == '1') {
      var themes = response.user.themes.split(' ');
      var div_theme = '';

      $('#categoryDiv #category-slider-div > div').each(function() {
        if ($(this).attr('hide') == '1')
          return;

        $(this).find('img').attr('src', $(this).find('img').attr('src').replace('check-', 'add-'));

        div_theme = $(this).attr('category');
        var element_div = $(this);

        $.map(themes, function(theme) {

          if (theme == div_theme) {
            element_div.find('img').attr('src', element_div.find('img').attr('src').replace('add-', 'check-'));
          }
        });
      });

      project.changePage('categoryDiv');



    }
    else
      console.log("No Session!");

  }, 'json');



}



/*********************************  END CATEGORY *******************************************************************/

/*********************************  START DISCOVER *******************************************************************/

function Discover() {
  var discover_move = 0;

  $('#discoverDiv #discover-categories-div > img').on('touchmove', function(e) {
    discover_move = 1;
  });

  $('#discoverDiv #discover-categories-div > img').on('touchend', function(e) {
    if (discover_move == 0)
      discover.catClick($(this));
    discover_move = 0;
  });

  $('#discoverDiv #discover-top-red .termine').on('touchstart', function(e) {
    discover.termine();
  });

}

Discover.prototype.catClick = function(element) {
  $('#discoverDiv #discover-categories-div > img').each(function() {
    $(this).css('opacity', '0.5');
  });

  $(element).css('opacity', '1');

  var themes_texts = {"mode": "Mode", "beaute": "Beauté", "DIY": "DIY & Craft", "voyages": "Voyages", "decoration": "Décoration", "fitness": "Fitness", "food": "Food & Drink", "mariage": "Mariage", "famille": "Famille"};
  var cat = element.attr('category');
  var i_theme = 0;

  $.map(themes_texts, function(theme, i) {
    if (i == cat) {
      $('#discoverDiv #discover-blog-title').text(theme);
      i_theme = theme;
      return false;
    }
  });

  var dataToSend = new Object();
  dataToSend.user_id = $('#mainDiv').attr('user_id');
  dataToSend.theme = cat;

  $.post(project.back_url + 'blog/searchBlogsFromTheme/', {data: dataToSend}, function(response) {
    //console.log(response);

    if (response.success == '1') {

      if (response.blogs.length > 0) {

        $('#discoverDiv #discover-blogs-div').html('');

        $.map(response.blogs, function(blog) {

          var check_src = 'img/discover/add-categories.png';

          if (blog.isSubscribed == '1')
            check_src = 'img/discover/check-categories.png';

          var discover_blog = '<div class="discover-blog"><img class="discover-blogphoto" src="img/discover/hardcoded/foto.png"><div>';
          discover_blog += '<p class="discover-blogname">' + blog.name + '</p><p class="discover-blogcategory">' + i_theme + '</p></div>';
          discover_blog += '<img blog_id="' + blog.id + '" class="discover-blogfollow" src="' + check_src + '"></div>';

          $('#discoverDiv #discover-blogs-div').append(discover_blog);

          $('#discoverDiv #discover-blogs-div .discover-blogfollow').unbind();

          $('#discoverDiv #discover-blogs-div .discover-blogfollow').on('touchend', function(e) {
            discover.SubscribeBlog($(this).attr('blog_id'), $(this));
          });


        });

      }
      myScroll5 = new IScroll('#discoverDiv');
    }
    else
      console.log("No Session!");

  }, 'json');


}

Discover.prototype.termine = function() {
  menulateral.load();
  project.changePage('newsDiv');
  menulateral.hideMenu();
}

Discover.prototype.SubscribeBlog = function(blog_id, element) {
  var self = this;
  var dataToSend = new Object();
  dataToSend.user_id = $('#mainDiv').attr('user_id');
  dataToSend.blog_id = blog_id;

  if (element.attr('src').indexOf('add-') != -1) {
    element.attr('src', element.attr('src').replace('add-', 'check-'));
    $.post(project.back_url + 'blog/newSubscription/', {data: dataToSend});
  }
  else {
    element.attr('src', element.attr('src').replace('check-', 'add-'));
    $.post(project.back_url + 'blog/removeSubscriptionFromUserAndBlog', {data: dataToSend});
  }

}

/*********************************  END DISCOVER *******************************************************************/

/*********************************  START CAT's *******************************************************************/

function Cat1() {

}

Cat1.prototype.loadNews = function() {
  var self = news;

  $('#cat1Div #feedsMainDiv-cat1').html('');
  $('#cat1Div').css('background-color', '#FFFFFF');

  var dataToSend = new Object();
  dataToSend.category = cat1_theme;

  $.post(project.back_url + 'blog/getFeedsCat/', {data: dataToSend}, function(response) {

    if (response.success == '0') {
      project.changePage('registerDiv');
      return;
    }

    var themes_texts = {"mode": "Mode", "beaute": "Beauté", "DIY": "DIY & Craft", "voyages": "Voyages", "decoration": "Décoration", "fitness": "Fitness", "food": "Food & Drink", "mariage": "Mariage", "famille": "Famille"};
    var text_theme = '';

    $.map(themes_texts, function(theme, i) {
      if (i == cat1_theme) {
        $('#cat1Div #menu-btn-div > p').text(theme);
        text_theme = theme;
        return false;
      }
    });

    if (response.articles.length == 0) {
      $('#cat1Div').css('background-color', '#EA3245');
      $('#cat1Div #feedsMainDiv-cat1').append('<div class="no-feeds-found"><p>Flux avec le thème "' + text_theme + '" ne sont pas trouvés!</p></div>');
      project.changePage('cat1Div');
      return;
    }

    $('#cat1Div .news-article-page span.page-total').text(response.articles.length);

    $.map(response.articles, function(article, i) {
      i = parseInt(i) + 1;
      var time = self.convertTimeFormat(article.created_at);

      var image = "";

      if (i == 1)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/selectionaccesoiresbureau_featured.png";
      else if (i == 2)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/1601319_425697720908397_251263012_n.jpg";
      else if (i == 3)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/painted-bottle-vases03-728x405.jpg";
      else if (i == 4)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/Gallery-S-Bensimon-X-La-Redoute-700x405.jpg";
      else if (i == 5)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/P1070665-760x405.jpg";

      var like_src = 'img/register/buttons/like_line.png';

      if (article.has_like == '1')
        like_src = 'img/register/buttons/like.png';

      var newArticlesDiv = '';

      if (parseInt(article.new_articles) > 0)
        newArticlesDiv = '<div class="news-articleNewDiv" style="visibility:visible" onclick="news.newArticlesClick()"><p>' + article.new_articles + ' nouveaux articles</p></div>';
      else
        newArticlesDiv = '<div class="news-articleNewDiv" style="visibility:hidden" onclick="news.newArticlesClick()"><p>' + article.new_articles + ' nouveaux articles</p></div>';

      var feed = '<div id="feed-' + i + '" feed_page="' + i + '" feed_id="' + article.id + '" blog_id="' + article.blog_id + '" class="feed-div"><img src="' + image + '" onclick="artigo.loadArticle(' + article.id + ')" /><div class="news-article-stats">';
      feed += '<div class="stat"><img onclick="news.heartClick($(this), ' + article.id + ', ' + article.blog_id + ')" src="' + like_src + '" /><p class="news-feeds-like">' + article.likes + '</p></div><div class="stat"><img onclick="artigo.loadComments($(this))" article_id="' + article.id + '" blog_id="' + article.blog_id + '" src="img/register/buttons/comment.png" />';
      feed += '<p class="news-feeds-comments">' + article.comments + '</p></div></div><div class="news-feed-content" onclick="artigo.loadArticle(' + article.id + ')">' + newArticlesDiv;
      feed += '<img class="news-blogger-photo" src="img/register/hardcoded/image5.png" /><p class="news-article-date">' + time + '</p>';
      feed += '<p class="news-article-title">' + article.title + '</p><p class="news-article-blogname">Par <span>' + article.blogname + '</span></p>';
      feed += '<p class="news-article-text">' + article.content + '</p></div></div>';

      $('#cat1Div #feedsMainDiv-cat1').append(feed);
    });

    project.changePage('cat1Div');

  }, 'json');
}

Cat1.prototype.menuClick = function() {
  swipeleft = 0;

  if (menu_lateral_open == 0) {
    menu_lateral_open = 1;

    menulateral.swipe();

    $('#cat1Div').css('overflow-y', 'hidden');

    $('#menuLateralDiv').css('left', '-100%');
    $('#menuLateral-Content').css('left', '-100%');

    $('#menuLateralDiv').show();
    $('#menuLateral-Content').show();

    $('#cat1Div').animate({
      'left': '+=85%'
    }, 300);

    $('#menu-bar-top').animate({
      'left': '+=85%'
    }, 300);

    $('#menuLateral-Content').animate({
      'left': '+=85%'
    }, 300);
  }

  var height = $(document).height();

  $('#menuLateral-Content').css({
    'height': height + 'px',
    'overflow-y': 'scroll'
  });

  var myScroll2 = new IScroll('#menuLateral-Content');
}

function Cat2() {

}

Cat2.prototype.loadNews = function() {
  var self = news;

  $('#cat2Div #feedsMainDiv-cat2').html('');
  $('#cat2Div').css('background-color', '#FFFFFF');

  var dataToSend = new Object();
  dataToSend.category = cat2_theme;

  $.post(project.back_url + 'blog/getFeedsCat/', {data: dataToSend}, function(response) {

    if (response.success == '0') {
      project.changePage('registerDiv');
      return;
    }

    var themes_texts = {"mode": "Mode", "beaute": "Beauté", "DIY": "DIY & Craft", "voyages": "Voyages", "decoration": "Décoration", "fitness": "Fitness", "food": "Food & Drink", "mariage": "Mariage", "famille": "Famille"};
    var text_theme = '';

    $.map(themes_texts, function(theme, i) {
      if (i == cat2_theme) {
        $('#cat2Div #menu-btn-div > p').text(theme);
        text_theme = theme;
        return false;
      }
    });

    if (response.articles.length == 0) {
      $('#cat2Div').css('background-color', '#EA3245');
      $('#cat2Div #feedsMainDiv-cat2').append('<div class="no-feeds-found"><p>Flux avec le thème "' + text_theme + '" ne sont pas trouvés!</p></div>');
      project.changePage('cat2Div');
      return;
    }

    $('#cat1Div .news-article-page span.page-total').text(response.articles.length);

    $.map(response.articles, function(article, i) {
      i = parseInt(i) + 1;
      var time = self.convertTimeFormat(article.created_at);

      var image = "";

      if (i == 1)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/selectionaccesoiresbureau_featured.png";
      else if (i == 2)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/1601319_425697720908397_251263012_n.jpg";
      else if (i == 3)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/painted-bottle-vases03-728x405.jpg";
      else if (i == 4)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/Gallery-S-Bensimon-X-La-Redoute-700x405.jpg";
      else if (i == 5)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/P1070665-760x405.jpg";

      var like_src = 'img/register/buttons/like_line.png';

      if (article.has_like == '1')
        like_src = 'img/register/buttons/like.png';

      var newArticlesDiv = '';

      if (parseInt(article.new_articles) > 0)
        newArticlesDiv = '<div class="news-articleNewDiv" style="visibility:visible" onclick="news.newArticlesClick()"><p>' + article.new_articles + ' nouveaux articles</p></div>';
      else
        newArticlesDiv = '<div class="news-articleNewDiv" style="visibility:hidden" onclick="news.newArticlesClick()"><p>' + article.new_articles + ' nouveaux articles</p></div>';

      var feed = '<div id="feed-' + i + '" feed_page="' + i + '" feed_id="' + article.id + '" blog_id="' + article.blog_id + '" class="feed-div"><img src="' + image + '" onclick="artigo.loadArticle(' + article.id + ')" /><div class="news-article-stats">';
      feed += '<div class="stat"><img onclick="news.heartClick($(this), ' + article.id + ', ' + article.blog_id + ')" src="' + like_src + '" /><p class="news-feeds-like">' + article.likes + '</p></div><div class="stat"><img onclick="artigo.loadComments($(this))" article_id="' + article.id + '" blog_id="' + article.blog_id + '" src="img/register/buttons/comment.png" />';
      feed += '<p class="news-feeds-comments">' + article.comments + '</p></div></div><div class="news-feed-content" onclick="artigo.loadArticle(' + article.id + ')">' + newArticlesDiv;
      feed += '<img class="news-blogger-photo" src="img/register/hardcoded/image5.png" /><p class="news-article-date">' + time + '</p>';
      feed += '<p class="news-article-title">' + article.title + '</p><p class="news-article-blogname">Par <span>' + article.blogname + '</span></p>';
      feed += '<p class="news-article-text">' + article.content + '</p></div></div>';

      $('#cat2Div #feedsMainDiv-cat2').append(feed);

    });

    project.changePage('cat2Div');

  }, 'json');
}

Cat2.prototype.menuClick = function() {
  swipeleft = 0;

  if (menu_lateral_open == 0) {
    menu_lateral_open = 1;

    menulateral.swipe();

    $('#cat2Div').css('overflow-y', 'hidden');

    $('#menuLateralDiv').css('left', '-100%');
    $('#menuLateral-Content').css('left', '-100%');

    $('#menuLateralDiv').show();
    $('#menuLateral-Content').show();

    $('#cat2Div').animate({
      'left': '+=85%'
    }, 300);

    $('#menu-bar-top').animate({
      'left': '+=85%'
    }, 300);

    $('#menuLateral-Content').animate({
      'left': '+=85%'
    }, 300);
  }

  var height = $(document).height();

  $('#menuLateral-Content').css({
    'height': height + 'px',
    'overflow-y': 'scroll'
  });

  var myScroll2 = new IScroll('#menuLateral-Content');
}

function Cat3() {

}

Cat3.prototype.loadNews = function() {
  var self = news;

  $('#cat3Div #feedsMainDiv-cat3').html('');
  $('#cat3Div').css('background-color', '#FFFFFF');

  var dataToSend = new Object();
  dataToSend.category = cat3_theme;

  $.post(project.back_url + 'blog/getFeedsCat/', {data: dataToSend}, function(response) {

    if (response.success == '0') {
      project.changePage('registerDiv');
      return;
    }

    var themes_texts = {"mode": "Mode", "beaute": "Beauté", "DIY": "DIY & Craft", "voyages": "Voyages", "decoration": "Décoration", "fitness": "Fitness", "food": "Food & Drink", "mariage": "Mariage", "famille": "Famille"};
    var text_theme = '';

    $.map(themes_texts, function(theme, i) {
      if (i == cat3_theme) {
        $('#cat3Div #menu-btn-div > p').text(theme);
        text_theme = theme;
        return false;
      }
    });

    if (response.articles.length == 0) {
      $('#cat3Div').css('background-color', '#EA3245');
      $('#cat3Div #feedsMainDiv-cat3').append('<div class="no-feeds-found"><p>Flux avec le thème "' + text_theme + '" ne sont pas trouvés!</p></div>');
      project.changePage('cat3Div');
      return;
    }

    $('#cat3Div .news-article-page span.page-total').text(response.articles.length);

    $.map(response.articles, function(article, i) {
      i = parseInt(i) + 1;
      var time = self.convertTimeFormat(article.created_at);

      var image = "";

      if (i == 1)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/selectionaccesoiresbureau_featured.png";
      else if (i == 2)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/1601319_425697720908397_251263012_n.jpg";
      else if (i == 3)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/painted-bottle-vases03-728x405.jpg";
      else if (i == 4)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/Gallery-S-Bensimon-X-La-Redoute-700x405.jpg";
      else if (i == 5)
        image = "http://boston-digital.fr/copines/wp-content/uploads/2014/06/P1070665-760x405.jpg";

      var like_src = 'img/register/buttons/like_line.png';

      if (article.has_like == '1')
        like_src = 'img/register/buttons/like.png';

      var newArticlesDiv = '';

      if (parseInt(article.new_articles) > 0)
        newArticlesDiv = '<div class="news-articleNewDiv" style="visibility:visible" onclick="news.newArticlesClick()"><p>' + article.new_articles + ' nouveaux articles</p></div>';
      else
        newArticlesDiv = '<div class="news-articleNewDiv" style="visibility:hidden" onclick="news.newArticlesClick()"><p>' + article.new_articles + ' nouveaux articles</p></div>';

      var feed = '<div id="feed-' + i + '" feed_page="' + i + '" feed_id="' + article.id + '" blog_id="' + article.blog_id + '" class="feed-div"><img src="' + image + '" onclick="artigo.loadArticle(' + article.id + ')" /><div class="news-article-stats">';
      feed += '<div class="stat"><img onclick="news.heartClick($(this), ' + article.id + ', ' + article.blog_id + ')" src="' + like_src + '" /><p class="news-feeds-like">' + article.likes + '</p></div><div class="stat"><img onclick="artigo.loadComments($(this))" article_id="' + article.id + '" blog_id="' + article.blog_id + '" src="img/register/buttons/comment.png" />';
      feed += '<p class="news-feeds-comments">' + article.comments + '</p></div></div><div class="news-feed-content" onclick="artigo.loadArticle(' + article.id + ')">' + newArticlesDiv;
      feed += '<img class="news-blogger-photo" src="img/register/hardcoded/image5.png" /><p class="news-article-date">' + time + '</p>';
      feed += '<p class="news-article-title">' + article.title + '</p><p class="news-article-blogname">Par <span>' + article.blogname + '</span></p>';
      feed += '<p class="news-article-text">' + article.content + '</p></div></div>';

      $('#cat3Div #feedsMainDiv-cat3').append(feed);

    });


    var themes_texts = {"mode": "Mode", "beaute": "Beauté", "DIY": "DIY & Craft", "voyages": "Voyages", "decoration": "Décoration", "fitness": "Fitness", "food": "Food & Drink", "mariage": "Mariage", "famille": "Famille"};

    $.map(themes_texts, function(theme, i) {
      if (i == cat3_theme) {
        $('#cat3Div #menu-btn-div > p').text(theme);
        return false;
      }
    });

    project.changePage('cat3Div');


  }, 'json');
}

Cat3.prototype.menuClick = function() {
  swipeleft = 0;

  if (menu_lateral_open == 0) {
    menu_lateral_open = 1;

    menulateral.swipe();

    $('#cat3Div').css('overflow-y', 'hidden');

    $('#menuLateralDiv').css('left', '-100%');
    $('#menuLateral-Content').css('left', '-100%');

    $('#menuLateralDiv').show();
    $('#menuLateral-Content').show();

    $('#cat3Div').animate({
      'left': '+=85%'
    }, 300);

    $('#menu-bar-top').animate({
      'left': '+=85%'
    }, 300);

    $('#menuLateral-Content').animate({
      'left': '+=85%'
    }, 300);
  }

  var height = $(document).height();

  $('#menuLateral-Content').css({
    'height': height + 'px',
    'overflow-y': 'scroll'
  });

  var myScroll2 = new IScroll('#menuLateral-Content');
}

/*********************************  END CAT's *******************************************************************/