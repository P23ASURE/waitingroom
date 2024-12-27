import("stdfaust.lib");

stereo_widener = _ , _ , width : widener
with {
    width = vslider("width", 1, 0, 2, 0.01);
    widener(l, r, w) = 
        l + side_effect(l, r, w),
        r - side_effect(l, r, w)
    with {
        side_effect(l, r, w) = (
            (l - r) * (w - 1) +                  // Stereo difference
            (l@(ma.SR/100) - r) * max(0, w - 1)  // Hass in mono
        ) * 0.5;
    };
};

process = stereo_widener;