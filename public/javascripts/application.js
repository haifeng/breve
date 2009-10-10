// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function applyDefaultStyles() {
   $j('button, input[type="submit"]').addClass('ui-corner-all ui-state-default')
      .hover(function(){ $j(this).addClass('ui-state-hover') },
             function(){ $j(this).removeClass('ui-state-hover') })
      .css({ 'text-transform': 'capitalize', 'font-size': '1.1em' });
   $j('.prev_page, .next_page')
      .addClass('link-button');
   $j('.link-button')
      .mouseover(function(){ $j(this).addClass('hover') })
      .mouseout(function(){ $j(this).removeClass('hover') })
   $j('textarea').autoResize();
   $j('.tab-container').tabs();
}

$(document).ready(
   function() {
      applyDefaultStyles();
      $j('a[rel*=facebox]').facebox();
   }
)
