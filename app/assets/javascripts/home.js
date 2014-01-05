$(document).ready(function() {
	
  $.getJSON("/next_event",function(result) {
	    if (result.date) {
				var date = new Date(result.date).toString().slice(0,21)
				$("#date").text(date)
			}
  });

  $.getJSON("/attendings",function(users) {
	  if (typeof users !== 'undefined' && users.length > 0) {
			var user_list_template = '<% _.each(list, function(user){ %> <div class="span2 text-center">'+
	                                                          '<a href="<%= user.url %>">'+
	                                                            '<img src="<%= user.avatar %>" class="img-circle" />'+
	                                                            '<p><%= user.username %></p>'+
	                                                          '</a>'+
	                                                        '</div> <% } )%>' 

	    $("#attending-list").html(_.template(user_list_template, {list:users}))
		}
  });

  if($.cookie('github_signedin')) {
    $('.signup')
      .addClass('btn-danger')
      .html('Cancel Attendance');
  }
	
});
