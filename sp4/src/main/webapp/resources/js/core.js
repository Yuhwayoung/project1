
$(function(){
	$(window).scroll(function() {
		if ($(this).scrollTop() > 100) {
			$('.navbar').addClass('navbar-scrolled');
			$('.top-bar').addClass('topbar-scrolled');
		} else {
			$('.navbar').removeClass('navbar-scrolled');
			$('.top-bar').removeClass('topbar-scrolled');
		}
	});

	if ($(window).scrollTop() > 100) {
		$('.navbar').addClass('navbar-scrolled');
		$('.top-bar').addClass('topbar-scrolled');
	}
});

// 메뉴 활성화
$(function(){
    var url = window.location.pathname;
    var urlRegExp = new RegExp(url.replace(/\/$/, '') + "$");
    
	$('nav>ul>li>a').each(function() {
		if (urlRegExp.test(this.href.replace(/\/$/, ''))) {
			$(this).parent("li").addClass('active');
			return false;
		}
	});
	if($('nav>ul>li').hasClass("active")) return false;
	
	$('nav>ul>li a').each(function() {
		if (urlRegExp.test(this.href.replace(/\/$/, ''))) {
			if($(this).closest(".dropdown").parent().parent("nav")) {
				$(this).closest(".dropdown").addClass('active');
			} else {
				$(this).closest(".dropdown").closest(".dropdown").addClass('active');
			}
			return false;
		}
	});
	if($('nav>ul>li').hasClass("active")) return false;
	
 	var parent = url.replace(/\/$/, '').substr(0, url.replace(/\/$/, '').lastIndexOf("/"));
 	if(! parent) parent = "/";
    var urlParentRegExp = new RegExp(parent);
	$('nav>ul>li a').each(function() {
		if($(this).attr("href")=="#") return true;
		
		var phref = this.href.replace(/\/$/, '').substr(0, this.href.replace(/\/$/, '').lastIndexOf("/"));
		if (urlParentRegExp.test(phref)) {
			if(! $(this).closest(".dropdown")) {
				$(this).parent("li").addClass('active');
			} else if($(this).closest(".dropdown").parent().parent("nav")) {
				$(this).closest(".dropdown").addClass('active');
			} else {
				$(this).closest(".dropdown").closest(".dropdown").addClass('active');
			}
			return false;
		}
	});
});
