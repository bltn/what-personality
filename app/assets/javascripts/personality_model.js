$(document).ready(function(){
    $("a#show-chat-messages").click(function(e){
        e.preventDefault();
        $(this).hide();
        $("p#chat-messages").show();
        $("a#hide-chat-messages").css("display", "block");
    });
    
    $("a#hide-chat-messages").click(function(e){
        e.preventDefault();
        $(this).hide();
        $("p#chat-messages").hide();
        $("a#show-chat-messages").css("display", "block");
    });
});