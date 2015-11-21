(function() {

    function sumPoints(points) {
        var sum = 0;

        $.each(points, function(i,e) {
            sum += e.value;
        });

        return sum;
    }

    var update = function() {
        $.get('/scoreboard_game.json', function(data) {
            var bluPts = sumPoints(data.players["blue"].points);
            var redPts = sumPoints(data.players["red"].points);
            $('#blue-score').text(bluPts);
            $('#red-score').text(redPts);
        });
    };

    setInterval(update, 100);
}());

