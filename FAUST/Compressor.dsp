import("stdfaust.lib");
// NOTE:
// Add/Remove Attack is for PumpComp project, don't expose to the final user parameters.
/* Controls */
comp_group(x) = hgroup("1-compression", x);
env_group(x)  = vgroup("2-envelop", x);
gain_group(x) = vgroup("3-gain", x);
link_group(x) = vgroup("4-channel linking", x);
meter_group(x) = vgroup("5-metering", x);

// Controls
ratio     = comp_group(nentry("ratio", 2, 1, 20, 0.1));
threshold = comp_group(nentry("threshold", -20, -96, 10, 0.1));
knee      = comp_group(nentry("knee", 3, 0, 20, 0.1));
attack    = env_group(hslider("Attack [unit:ms]", 2, 0, 1000, 0.1));
release   = env_group(hslider("Release [unit:ms]", 500, 0, 10000, 1));
addAttack = env_group(hslider("Add/Remove Attack [unit:ms]", 0, -1000, 1000, 0.1));
addRelease = env_group(hslider("Add/Remove Release [unit:ms]", 0, -1000, 1000, 0.1));
makeup_gain = gain_group(hslider("makeup gain", 0, -96, 96, 0.1));
channel_link = link_group(hslider("channel link", 100, 0, 100, 1) : /(100));

envelope_detector(x) = abs(x) : follow(total_attack_time, total_release_time)
with {
    total_attack_time = max(0.1, (attack + addAttack))/1000.0;
    total_release_time = max(0.1, (release + addRelease))/1000.0;
    follow(att, rel) = si.smooth(ba.tau2pole(att)) : si.smooth(ba.tau2pole(rel));
};

compress(x) = 
    ba.linear2db(x) : calc_gain
with {
    calc_gain(in_db) = gain
    with {
        over = in_db - threshold;
        knee_width = knee;
        half_knee = knee_width/2;
        
        knee_gain = 
            (over <= -half_knee) * 0 +                   
            (over > half_knee) * over +                  
            ((over > -half_knee) & (over <= half_knee)) * 
                ((over + half_knee)^2 / (2*knee_width)); 
                           
        ratio_factor = (1/max(ratio, 1.000001));
        gain = -knee_gain * (1 - ratio_factor);
    };
};

gain_computer(x) = x : envelope_detector : compress : ba.db2linear;

// Gain reduction calculation (in dB)
gain_reduction(x) = x : envelope_detector : compress;

// Master process
process(l,r) = (gl*l, gr*r) : attach_meters
with {
    // Calculate gain reduction for each channel
    g_left = gain_computer(l) : *(ba.db2linear(makeup_gain));
    g_right = gain_computer(r) : *(ba.db2linear(makeup_gain));
    
    g_linked = min(g_left, g_right);
    
    gl = g_left*(1-channel_link) + g_linked*channel_link;
    gr = g_right*(1-channel_link) + g_linked*channel_link;
    
    // Attach meters - kept simple with only one negation
    attach_meters(x, y) = attach(x, meter1), attach(y, meter2)
    with {
        meter1 = gain_reduction(l) : 
            meter_group(vbargraph("Left GR[unit:dB]", -60, 0));
        meter2 = gain_reduction(r) : 
            meter_group(vbargraph("Right GR[unit:dB]", -60, 0));
    };
};