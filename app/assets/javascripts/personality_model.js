$(document).ready(function(){
    $("a#show-author-text").click(function(e){
        e.preventDefault();
        $(this).hide();
        $("p#author-text").show();
        $("a#hide-author-text").css("display", "block");
    });
    
    $("a#hide-author-text").click(function(e){
        e.preventDefault();
        $(this).hide();
        $("p#author-text").hide();
        $("a#show-author-text").css("display", "block");
    });
});