/*
	Alpha by HTML5 UP
	html5up.net | @ajlkn
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
*/

(function($) {

	var	$window = $(window),
		$body = $('body'),
		$header = $('#header'),
		$banner = $('#banner');

	// Breakpoints.
		breakpoints({
			wide:      ( '1281px',  '1680px' ),
			normal:    ( '981px',   '1280px' ),
			narrow:    ( '737px',   '980px'  ),
			narrower:  ( '737px',   '840px'  ),
			mobile:    ( '481px',   '736px'  ),
			mobilep:   ( null,      '480px'  )
		});

	// Play initial animations on page load.
		$window.on('load', function() {
			window.setTimeout(function() {
				$body.removeClass('is-preload');
			}, 100);
		});

	// Dropdowns.
		$('#nav > ul').dropotron({
			alignment: 'right',
			detach: false,
			hoverDelay: 100
		});

		$('#nav > ul > li > ul').each(function() {
			var $menu = $(this),
				$opener = $menu.parent().children('a').first();

			$opener
				.attr('aria-haspopup', 'true')
				.attr('aria-expanded', 'false')
				.on('focus', function() {
					$menu.trigger('doExpand');
				})
				.on('keydown', function(event) {
					if (event.key === 'Escape') {
						$menu.trigger('doCollapse');
						$opener.trigger('focus');
					}
				});

			$menu
				.attr('aria-label', $.trim($opener.text()))
				.on('doExpand.accessibility', function() {
					$opener.attr('aria-expanded', 'true');
				})
				.on('doCollapse.accessibility', function() {
					$opener.attr('aria-expanded', 'false');
				});
		});

		$('#nav > ul > li > a').on('focus', function() {
			var currentMenu = $(this).siblings('ul').get(0);
			$('#nav > ul > li > ul').each(function() {
				if (this !== currentMenu) {
					$(this).trigger('doCollapse');
				}
			});
		});

		$('#nav').on('focusout', function() {
			window.setTimeout(function() {
				if (!$.contains(document.getElementById('nav'), document.activeElement)) {
					$('#nav > ul').trigger('doCollapseAll');
				}
			}, 0);
		});

	// NavPanel.

		// Button.
			$(
				'<div id="navButton">' +
					'<a href="#navPanel" class="toggle" aria-label="Open navigation" aria-controls="navPanel"><span class="sr-only">Open navigation</span></a>' +
				'</div>'
			)
				.appendTo($body);

		// Panel.
			$(
				'<div id="navPanel">' +
					'<nav>' +
						$('#nav').navList() +
					'</nav>' +
				'</div>'
			)
				.appendTo($body)
				.panel({
					delay: 500,
					hideOnClick: true,
					hideOnEscape: true,
					hideOnSwipe: true,
					resetScroll: true,
					resetForms: true,
					side: 'left',
					target: $body,
					visibleClass: 'navPanel-visible'
				});

	// Header.
		if (!browser.mobile
		&&	$header.hasClass('alt')
		&&	$banner.length > 0) {

			$window.on('load', function() {

				$banner.scrollex({
					bottom:		$header.outerHeight(),
					terminate:	function() { $header.removeClass('alt'); },
					enter:		function() { $header.addClass('alt reveal'); },
					leave:		function() { $header.removeClass('alt'); }
				});

			});

		}

})(jQuery);
