import("stdfaust.lib");

declare name "Dual Wood Block Kicks";
declare version "1.0";
// Wood type: Hollow or Solid

// Basic parameters
freq = hslider("freq", 1200, 600, 2500, 1) : si.smoo;
punch = hslider("punch", 0.7, 0, 1, 0.01) : si.smoo;
dry_wet = hslider("dry_wet", 0.5, 0, 1, 0.01) : si.smoo;
gain = hslider("gain", 1.0, 0, 4, 0.01) : si.smoo;

// Type-specific parameters
wood_decay = hslider("wood_decay[type:hollow]", 0.92, 0.85, 0.98, 0.001) : si.smoo;
tightness = hslider("tightness[type:solid]", 0.97, 0.9, 0.99, 0.001) : si.smoo;
stereo_spread = hslider("stereo_spread", 1.0, 0, 1, 0.01) : si.smoo;

// Wood type selector (0 = hollow, 1 = solid)
wood_type = checkbox("wood_type [tooltip:0=hollow wood, 1=solid wood]");

// Main stereo processor with wood type selection
process = _ , _ : stereo_processor
with {
    stereo_processor(l, r) = (dry_l + wet_l, dry_r + wet_r) : (*(gain), *(gain)) : (*(4.0), *(4.0))
    with {
        // Dry paths with level control
        dry_l = l * (1-dry_wet);
        dry_r = r * (1-dry_wet);
        
        // Wet paths with cross-feed and type selection
        wet_l = (l * (1.0) + r * stereo_spread) : type_selector(freq * 0.99) : *(dry_wet);
        wet_r = (r * (1.0) + l * stereo_spread) : type_selector(freq * 1.01) : *(dry_wet);
    };
    
    // Select between hollow and solid wood types
    type_selector(f) = _ <: hollow_wood(f), solid_wood(f) : select2(wood_type);
    
    // HOLLOW WOOD IMPLEMENTATION
    hollow_wood(f) = exciter(f) : hollow_resonator(f) : hollow_peak_enhancer(f);
    
    exciter(f) = _ : fi.bandpass(2, f*0.8, f*1.2) 
            : *(1 + punch)
            : *(2.0)
            : shape;
    
    shape = _ : *(2) : min(0.9) : max(-0.9);
    
    hollow_resonator(f) = _ : (+(_' * wood_decay) ~ (delay_line(f) : damping(f) : wooden_filter(f)));
    
    delay_line(f) = de.delay(4096, max(1, min(4096, (ma.SR/48000) * (48000/f))));
    
    damping(f) = fi.lowpass(1, f * 4) : *(0.99);
    
    wooden_filter(f) = fi.tf2(b0(f), b1(f), b2, a1(f), a2(f))
    with {
        omega(f) = 2*ma.PI*f*1.7/ma.SR;
        q = 0.5;
        alpha(f) = sin(omega(f))/(2*q);
        cosw(f) = cos(omega(f));
        b0(f) = (1-alpha(f))/(1+alpha(f));
        b1(f) = -2*cosw(f)/(1+alpha(f));
        b2 = 1;
        a1(f) = b1(f);
        a2(f) = b0(f);
    };
    
    hollow_peak_enhancer(f) = _ : fi.resonhp(f*2.5, 0.95, 0.3*punch);
    
    // SOLID WOOD IMPLEMENTATION
    solid_wood(f) = prefilter(f) : block_resonator(f) <: (_, solid_peak_enhancer(f)) :> _;
    
    prefilter(f) = fi.bandpass(2, f*0.7, f*1.4) : *(1 + punch);
    
    block_resonator(f) = _ <: (resonator1(f), resonator2(f), resonator3(f)) :> _;
    
    resonator1(f) = fi.resonbp(f, q, 1.0);           // Main tone
    resonator2(f) = fi.resonbp(f*1.33, q*0.8, 0.6);  // Upper body 
    resonator3(f) = fi.resonbp(f*0.7, q*1.2, 0.5);   // Lower body
    
    solid_peak_enhancer(f) = _ : fi.resonhp(f*1.1, 0.992, 0.3*punch) : *(0.8);
    
    // Q factor with tightness control
    q = 35 * (1-tightness);
};