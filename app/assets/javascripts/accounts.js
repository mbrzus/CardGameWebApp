/* for the signup and sign in pages, I have merged the textbox and their label
    However, focussing on a textbox turns its border blue.
    Here, I turn the label blue as well whent he focus is active
    Assumes label id is always id of text box plus the word "label"
 */
function activate_textbox_label() {
    let label_id = this.id + "_label";
    document.getElementById(label_id).style.borderColor = "#80bdff";
}
function deactivate_textbox_label() {
    let label_id = this.id + "_label";
    document.getElementById(label_id).style.borderColor = "#ced4da";
}

function add_signup_event_listeners() {
    // add the event listeners for these text box label combos
    document.getElementById('signup_username').addEventListener('focus', activate_textbox_label);
    document.getElementById('signup_email').addEventListener('focus', activate_textbox_label);
    document.getElementById('signup_password').addEventListener('focus', activate_textbox_label);
    // add event listeners to deactivate on blur
    document.getElementById('signup_username').addEventListener('blur', deactivate_textbox_label);
    document.getElementById('signup_email').addEventListener('blur', deactivate_textbox_label);
    document.getElementById('signup_password').addEventListener('blur', deactivate_textbox_label);
}

function add_login_event_listeners() {
    // add the event listeners for these text box label combos
    document.getElementById('login_username').addEventListener('focus', activate_textbox_label);
    document.getElementById('login_password').addEventListener('focus', activate_textbox_label);
    // add event listeners to deactivate on blur
    document.getElementById('login_username').addEventListener('blur', deactivate_textbox_label);
    document.getElementById('login_password').addEventListener('blur', deactivate_textbox_label);
}