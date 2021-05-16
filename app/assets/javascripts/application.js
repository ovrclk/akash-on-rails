// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery/dist/jquery.slim.min
//= require imagesloaded/imagesloaded.pkgd
//= require masonry-layout/dist/masonry.pkgd
//= require infinite-scroll/dist/infinite-scroll.pkgd
//= require_tree .

$(document).ready(function() {
  // init Masonry
  var $grid = $('.grid').masonry({
    // options...
  });
  // layout Masonry after each image loads
  $grid.imagesLoaded().progress( function() {
    $grid.masonry('layout');
  });

  let msnry = $grid.data('masonry');

  $grid.infiniteScroll({
    // options
    path: '.page-link[rel=next]',
    append: '.col',
    history: false,
    status: '.page-load-status',
    outlayer: msnry
  });

  $('.pinPagination').hide();
})
