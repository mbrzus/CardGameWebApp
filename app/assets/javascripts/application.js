// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

// fills in the join_room form with the given room_id and submits the form
function join_room(room_id) {
    document.getElementById('room_id_input').value = room_id;
    document.getElementById('join_room_button').click();
}


// this function takes as an argument a card html object form the create room screen
// If this card is currently selected, we should unselect it and change its border color to show the user
// If it is currently unselected, we should do the opposite
function toggle_selection(card_html_object) {
    // first, get whether the card is selected
    var current_selected_value = card_html_object.getAttribute("data-selected");

    // the card is currently selected to be in the room
    if (current_selected_value == "true") {
        // set the selected value
        card_html_object.setAttribute("data-selected", "false");
        // set the border color to transparent
        card_html_object.style.borderColor = "rgb(0,0,0,0)";
    }
    // the card is currently not selected
    else {
        // set its selected value to true
        card_html_object.setAttribute("data-selected", "true");
        // set the border color to yellow
        card_html_object.style.borderColor = "yellow";
    }
}