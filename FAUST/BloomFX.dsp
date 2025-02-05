declare name "Inflator-like test2";

import("stdfaust.lib");

// Interface
input_slider = hslider("Input (dB)", 0, -6, 12, 0.01);
effect_slider = hslider("Effect (%)", 0, 0, 100, 0.1);
curve_slider = hslider("Curve", 0, -50, 50, 0.1);
clip_slider = checkbox("Clip 0 dB");
band_split_slider = checkbox("Band Split");
effect_in_slider = checkbox("Effect In");
output_slider = hslider("Output (dB)", 0, -12, 0, 0.01);
loudness_control = checkbox("Loudness Control");
loudness_amount = hslider("Loudness Amount", 0, -100, 100, 0.1);

// Utility functions
clamp(x, minv, maxv) = min(maxv, max(minv, x));
sign(x) = (x > 0) - (x < 0);

// Convert UI values to processing parameters
pre = input_slider : ba.db2linear;
post = output_slider : ba.db2linear;
wet = effect_slider * 0.01 * 0.99999955296;
dry = 1 - (effect_slider * 0.01);

// K-weighted filter and envelope follower
k_weight = fi.highpass(2, 100) : fi.peak_eq(1.0, 2000, 4.0) : fi.lowpass(2, 8000);
envelope = abs : si.smooth(0.999);
curve_mod(x) = k_weight(x) : envelope : *(loudness_amount * 0.01);

// Dynamic curve value
// dynamic_curve(x) = curve_slider + select2(loudness_control, 0, curve_mod(x));
dynamic_curve(x) = curve_slider + select2(loudness_control, curve_mod(x), 0);

// Curve coefficients with loudness modulation
A(x) = (dynamic_curve(x) * 0.01 + 1.5);
B(x) = (dynamic_curve(x) * -0.02);
C(x) = (dynamic_curve(x) * 0.01 - 0.5);
D(x) = (0.0625 - dynamic_curve(x) * 0.0025 + (dynamic_curve(x) * dynamic_curve(x)) * 0.000025);

// Linkwitz-Riley 4th order filters 
lr4_lowpass(fc) = fi.lowpass(2,fc) : fi.lowpass(2,fc);
lr4_highpass(fc) = fi.highpass(2,fc) : fi.highpass(2,fc);

// Band splitting using Linkwitz-Riley crossovers && gain compensation
band_split = _ <: (low, (mid * gain) * gain_div, high)
with {
    low_cutoff = 240;
    high_cutoff = 2400;
    
    // Calculate coefficients 
    c_low = tan(ma.PI * (low_cutoff/ma.SR - 0.25)) * 0.5 + 0.5;
    c_high = tan(ma.PI * (high_cutoff/ma.SR - 0.25)) * 0.5 + 0.5;
    
    // Gain calculation 
    gain = c_high * (1 - c_low) / (c_high - c_low);
    gain_div = 1 / gain;
    
    low = lr4_lowpass(low_cutoff);
    high = lr4_highpass(high_cutoff);
    mid = _ <: (lr4_highpass(low_cutoff) : lr4_lowpass(high_cutoff));
};

// Waveshaping function with dynamic coefficients
waveshaper(x) = select2(abs(x) < 1,
                       select2(abs(x) < 2,
                              x,  // > 2
                              (2 * abs(x) - abs(x) * abs(x)) * sign(x)), // 1 < x < 2
                       (A(x) * abs(x) + B(x) * (abs(x) * abs(x)) + 
                        C(x) * abs(x) * (abs(x) * abs(x)) - 
                        D(x) * ((abs(x) * abs(x)) - 
                            2 * (abs(x) * abs(x)) * abs(x) + 
                            (abs(x) * abs(x) * abs(x) * abs(x)))) * sign(x)) // x < 1
                * wet + x * dry;

// Main processing 
process = par(i, 2, channel_process)
with {
    channel_process(x) = x : input_stage : effect_stage : output_stage;
    
    input_stage(x) = x * pre <: 
                     select2(clip_slider,
                            clamp(_, -2, 2),
                            clamp(_, -1, 1));
    
    effect_stage(x) = select2(effect_in_slider,
                             x,
                             select2(band_split_slider,
                                    waveshaper(x),
                                    band_split(x) : (waveshaper, waveshaper, waveshaper) :> _));
    
    output_stage(x) = select2(abs(x) < ma.EPSILON,
                         x * post,
                         0);
};