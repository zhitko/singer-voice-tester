pragma Singleton
import QtQuick 2.14
import "../../3party/chroma.js" as GlobalChroma

Item {
    function hex2Rgb(hex) {
        if (!hex) return null;
        var t = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
        hex = hex.replace(t, function(e, t, r, o) {
            return t + t + r + r + o + o
        });

        var r = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);

        return r ? {
            r: parseInt(r[1], 16),
            g: parseInt(r[2], 16),
            b: parseInt(r[3], 16)
        } : null
    }

    function overlayOn(colorRgb, textColorRgb, r) {
        if (r >= 1) {
            return colorRgb
        } else {
            return {
                r: textColorRgb.r * r + colorRgb.r * (1 - r),
                g: textColorRgb.g * r + colorRgb.g * (1 - r),
                b: textColorRgb.b * r + colorRgb.b * (1 - r),
                r: r + 1 * (1 - r)
            }
        }
    }

    function getLFromRgbValue(rgbVal) {
        var t = rgbVal / 255;
        return .03928 > t ? t / 12.92 : Math.pow((t + .055) / 1.055, 2.4)
    }

    function getLFromRgbColor(rgb) {
        var t = {
            r: getLFromRgbValue(rgb.r),
            g: getLFromRgbValue(rgb.g),
            b: getLFromRgbValue(rgb.b)
        }
        return .2126 * t.r + .7152 * t.g + .0722 * t.b
    }

    function opaqueContrast(colorRgb, textColorRgb, r) {
        var o = getLFromRgbColor(textColorRgb) + .05
        var i = getLFromRgbColor(colorRgb) + .05
        var n = o / i
        if (i <= o) n = 1/n
        return n
    }

    function blendForegroundContrast(colorRgb, textColorRgb, r) {
        if (1 > r) {
            var o = overlayOn(colorRgb, textColorRgb, r);
            return opaqueContrast(o, colorRgb)
        }
        return opaqueContrast(colorRgb, textColorRgb)
    }

    function minAcceptableAlpha(colorHex, textColor, ratio) {
        console.log("minAcceptableAlpha",colorHex, textColor, ratio)
        var colorRgb = hex2Rgb(colorHex)
        console.log("minAcceptableAlpha colorRgb", JSON.stringify(colorRgb))
        var textColorRgb = hex2Rgb(textColor)
        console.log("minAcceptableAlpha textColorRgb", JSON.stringify(textColorRgb))

        var n = 0
        var a = blendForegroundContrast(colorRgb, textColorRgb, n)
        console.log("minAcceptableAlpha a", JSON.stringify(a))
        if (a >= ratio) return null;

        var c = 1
        var l = blendForegroundContrast(colorRgb, textColorRgb, c);
        console.log("minAcceptableAlpha l", JSON.stringify(l))
        if (ratio > l) return null;

        for (var s = 0, m = 10, d = .01; m >= s && c - n > d; s++) {
            var h = (n + c) / 2
            var p = blendForegroundContrast(colorRgb, textColorRgb, h)
            console.log("minAcceptableAlpha p", JSON.stringify(p))
            if (ratio > p) n = h
            else c = h
        }

        console.log("minAcceptableAlpha ")
        return s > m ? null : c
    }

    function getLFromHex(e) {
        var t = hex2Rgb(e);
        return getLFromRgbColor(t)
    }

    function isTextLegibleOverBackground(e, t) {
        var r = arguments.length <= 2 || void 0 === arguments[2] ? 14 : arguments[2]
        var o = arguments.length <= 3 || void 0 === arguments[3] ? 300 : arguments[3]
        var i = getLFromHex(e)
        var n = getLFromHex(t)
        var c = !1
        if (i !== !1 && n !== !1) {
            var a = 14 == r && o >= 700 || r >= 18
              , l = (Math.max(i, n) + .05) / (Math.min(i, n) + .05);
            c = l >= 3 && a ? !0 : l >= 3 && 4.5 > l && !a ? !1 : l >= 4.5 && !a ? !0 : !1
        }
        return c
    }

    function getRgbaFromHexAndAlpha(e, t) {
        var r = hex2Rgb(e);
        t = t ? t.toFixed(2) : 1
        return "rgba(" + r.r + ", " + r.g + ", " + r.b + ", " + t + ")"
    }

    function getAccessibilityValuesFromHex(e) {
        var t = this
        var r = {
            WHITE: "#ffffff",
            BLACK: "#000000"
        }
        var o = {}
        var i = [{
            large: !1,
            textColor: r.WHITE,
            ratio: 4.5,
            titlePriority: 2
        }, {
            large: !0,
            textColor: r.WHITE,
            ratio: 3,
            titlePriority: 4
        }, {
            large: !1,
            textColor: r.BLACK,
            ratio: 4.5,
            titlePriority: 1
        }, {
            large: !0,
            textColor: r.BLACK,
            ratio: 3,
            titlePriority: 3
        }]

        var n = null
        var c = null
        var a = null
        var l = null
        var s = null
        var m = null

        console.log("i",i)
        i.forEach(function(r) {
            console.log("r",r)
            var i = minAcceptableAlpha(e, r.textColor, r.ratio)
            console.log("i",i)
            var d = i ? Math.max(i, .87) : null;

            if (!i) {
                if (!r.large && r.titlePriority && isTextLegibleOverBackground(r.textColor, e) && (!c || r.titlePriority > m)) {
                    c = r.textColor
                    m = r.titlePriority
                }
                if (r.titlePriority && isTextLegibleOverBackground(r.textColor, e) && (!n || r.titlePriority > s)) {
                    n = r.textColor
                    s = r.titlePriority
                    a = d
                    l = getRgbaFromHexAndAlpha(r.textColor, d)
                }

                if (!o.defaults) o.defaults = []
                o.defaults.push({
                    recAlpha: d,
                    minAlpha: i,
                    criteria: r
                })
            }
        })

        o.preferredTitleColor = n
        o.preferredNormalColor = c
        o.preferredTitleRecAlpha = a
        o.preferredTitleRgba = l
        return o
    }

    function formatHex(color) {
        return color ? "#" !== color[0] ? "#" + color : color : null
    }

    function getColorRangeFromHex(color) {
        console.log(JSON.stringify(chroma))
        return {
            darkHex: chroma(color).darken().hex(),
            lightHex: chroma(color).brighten().hex()
        }
    }
}
