(function() {
    var normalBgColor = 'rgb(0, 0, 0)';
    var altBgColor = 'rgb(255, 255, 255)';
    var normalBlueColor = $('#blue-score').css('color');
    var normalRedColor = $('#red-score').css('color');
    var flashAtom = 75;

    function sumPoints(points) {
        var sum = 0;

        $.each(points, function(i,e) {
            sum += e.value;
        });

        return sum;
    }

    function setBgColor(color) {
        $('body').css('background-color', color);
    }

    function setBlueColor(color) {
        $('#blue-score').css('color', color);
    }

    function setRedColor(color) {
        $('#red-score').css('color', color);
    }

    function setColors(bg, b, r) {
        setBgColor(bg);
        setBlueColor(b);
        setRedColor(r);
    }

    function setNormalColors() {
        setColors(normalBgColor, normalBlueColor, normalRedColor)
    }

    function toggleColors(bg, b, r) {
        if ($('body').css('background-color') === normalBgColor) {
            setColors(bg, b, r)
        }
        else {
            setNormalColors();
        }
    }

    function flashBlue() {
        toggleColors(normalBlueColor, altBgColor, altBgColor);
    }

    function flashRed() {
        toggleColors(normalRedColor, altBgColor, altBgColor);
    }

    function flashWhite() {
        toggleColors(altBgColor, normalBgColor, normalBgColor);
    }

    function animateChange(n, changeFn) {
        changeFn();
        var iid = setInterval(changeFn, flashAtom);
        setTimeout(function() {
            clearInterval(iid);
            setNormalColors();
        }, flashAtom * ((n * 2) - 1));
    }

    function animateBlueScoreChange() {
        animateChange(2, flashBlue);
    }

    function animateRedScoreChange() {
        animateChange(2, flashRed);
    }

    function animateNewGameChange() {
        animateChange(3, flashWhite);
    }

    var update = function() {
        $.get('/scoreboard_game.json', function(data) {
            var bluPts = sumPoints(data.players["blue"].points);
            var redPts = sumPoints(data.players["red"].points);
            var oldBluPts = $('#blue-score').text();
            var oldRedPts = $('#red-score').text();

            if (oldBluPts !== '' && oldRedPts !== '') {
                if ((oldBluPts != bluPts || oldRedPts != redPts) && bluPts === 0 && redPts === 0) {
                    animateNewGameChange();
                }
                else if (oldBluPts != bluPts) {
                    animateBlueScoreChange();
                }
                else if (oldRedPts != redPts) {
                    animateRedScoreChange();
                }
            }

            $('#blue-score').text(bluPts);
            $('#red-score').text(redPts);
        });
    };

    setInterval(update, 100);
}());

