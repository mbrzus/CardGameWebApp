describe("Create Room", function() {
    var deselected_cards = ["A-D", "Q-C", "5-S"];

    describe("when form is submitted", function() {
        beforeEach(function() {
            // create a mock page to display everything
            document.body.innerHTML += '<form id="create_room_form">' +
                '<div id="cards_to_use"></div>' +
                '</form>';
            document.body.innerHTML += '<div class="playing-cards-box"></div>';
            collection = [];
            var values = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"];
            var suits = ["S", "H", "D", "C"];
            for (var i = 0; i < values.length; i++) {
                for (var j = 0; j < suits.length; j++) {
                    var id = values[i] + "-" + suits[j];
                    var place = true;
                    for (var t = 0; t < deselected_cards.length; t++) {
                        if (id == deselected_cards[t]) {
                            place = false;
                        }
                    }
                    if (place == false) {
                        collection.push({ id: id, data: { selected: "false" }, getAttribute: function() {return "false"} });
                        // document.body.innerHTML += '<div id="' +id+'" data-selected="false" onclick="toggle_selection(this)"></div>';
                    } else {
                        collection.push({ id: id, data: { selected: "true" }, getAttribute: function() {return "true"} });
                        //document.body.innerHTML += '<div id="' +id+'" data-selected="true" onclick="toggle_selection(this)"></div>';
                    }
                }
            }
        });

        it("should get all the currently selected cards and return a list in string form", function() {
            document.getElementsByClassName = jasmine.createSpy('HTML Element').and.returnValue([{children: collection}]);
            var card_list = submit_create_room_form();
            // expect a string to be returned
            // expect(typeof card_list).toBe(String);
            // it should be greater than 0
            expect(card_list.length).toBeGreaterThan(0);
            // there should be comma separated values
            expect(card_list.split(",").length).toBeGreaterThan(0);
        });

        it("should contain only selected cards", function() {
            document.getElementsByClassName = jasmine.createSpy('HTML Element').and.returnValue([{children: collection}]);
            var card_list = submit_create_room_form();
            // get the card values
            var card_values = card_list.split(",")
            // check the length
            expect(card_values.length).toBe(52 - deselected_cards.length);
            // make sure none of the deselected card values are in there
            var not_in_there = true;
            for (var i = 0; i < deselected_cards.length; i++) {
                for (var j = 0; j < card_values.length; j++) {
                    if (card_values[j] == deselected_cards[i]) {
                        not_in_there = false;
                    }
                }
                expect(not_in_there).toBe(true);
            }
        });
    });
});
