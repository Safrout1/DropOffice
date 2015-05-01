var lines = "";
var count = 0;

function recordAll() {
	lines = "";
	$('#cells').children().each(function(){lines = $(this).find('span').text()+"|#|"+lines;});
}

function submit() {
	recordAll();
	// var request = new XMLHttpRequest()
	alert(lines.toString());
}

function addNew() {
	if ($('#new').val()) {
		$('#cells').append('<li id="q'+count+'"><button onclick="deletethis(q'+count+');"> x</button><span>'+$('#new').val()+'</span></li>');
		$('#new').val("");
		count++;
	}
}

function deletethis(x) {
	$(x).remove();
}

function init() {
	$('cells').empty();
	var original = $('#original').text().split('|#|');
	original.pop();
	while(original.length>0){
		$('#cells').append('<li id="q'+count+'"><button onclick="deletethis(q'+count+');"> x</button><span>'+original.pop()+'</span></li>');
		count++;
	}
}