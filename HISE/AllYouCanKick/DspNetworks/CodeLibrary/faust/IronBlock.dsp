import("stdfaust.lib");

declare name "Dual Metal Block Kicks";
declare version "1.0";
// 0 = bright metal, 1 = dark metal

// Basic parameters
freq = hslider("freq", 2200, 800, 2500, 1) : si.smoo;
punch = hslider("punch", 0.7, 0, 1, 0.01) : si.smoo;
dry_wet = hslider("dry_wet", 0.5, 0, 1, 0.01) : si.smoo;
gain = hslider("gain", 1.0, 0, 4, 0.01) : si.smoo;
stereo_spread = hslider("stereo_spread", 0.3, 0, 1, 0.01) : si.smoo;

// Type-specific parameters
bright_decay = hslider("bright_decay[type:bright]", 0.85, 0.75, 0.92, 0.001) : si.smoo;
dark_decay = hslider("dark_decay[type:dark]", 0.88, 0.80, 0.95, 0.001) : si.smoo;
brightness = hslider("brightness[type:bright]", 0.7, 0, 1, 0.01) : si.smoo;
darkness = hslider("darkness[type:dark]", 0.7, 0, 1, 0.01) : si.smoo;

// Metal type selector (0 = bright metal, 1 = dark metal)
metal_type = checkbox("metal_type [tooltip:0=bright metal, 1=dark metal]");

// Main stereo processor with metal type selection
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
    
    // Select between bright and dark metal types
    type_selector(f) = _ <: bright_metal(f), dark_metal(f) : select2(metal_type);
    
    // BRIGHT METAL IMPLEMENTATION (Bell-like)
    bright_metal(f) = exciter(f, 0.5, 2.0) : bright_resonator(f) : bright_enhance(f);
    
    bright_resonator(f) = _ <: par(i, 6, bright_res(i, f)) :> _
    with {
        bright_res(i, f) = _ : (+(_' * bright_decay) ~ (delay_line(i, f) : damping(f) : metal_filter(i, f))) : *(gain(i))
        with {
            delay_line(i, f) = de.delay(4096, max(1, min(4096, ma.SR/(f * bright_ratio(i)))));
            damping(f) = fi.lowpass(1, min(ma.SR/2.1, f * 6)) : *(0.99);
            
            metal_filter(i, f) = fi.tf2(b0, b1, b2, a1, a2)
            with {
                omega = min(ma.PI*0.99, 2*ma.PI*f*bright_ratio(i)/ma.SR);
                q = 12;  // Higher Q for brighter sound
                alpha = sin(omega)/(2*q);
                cosw = cos(omega);
                b0 = (1-alpha)/(1+alpha);
                b1 = -2*cosw/(1+alpha);
                b2 = 1;
                a1 = b1;
                a2 = b0;
            };

            // Bright metal ratios (more bell-like overtones)
            bright_ratio(0) = 1.00;    // Fundamental
            bright_ratio(1) = 1.41;    // Higher partial ratios
            bright_ratio(2) = 1.73;
            bright_ratio(3) = 2.00;
            bright_ratio(4) = 2.41;
            bright_ratio(5) = 2.73;

            gain(0) = 0.7 * (1 + brightness * 0.3);
            gain(1) = 0.5 * (1 + brightness * 0.4);
            gain(2) = 0.4 * (1 + brightness * 0.5);
            gain(3) = 0.3 * (1 + brightness * 0.6);
            gain(4) = 0.2 * (1 + brightness * 0.7);
            gain(5) = 0.1 * (1 + brightness * 0.8);
        };
    };
    
    bright_enhance(f) = _ : fi.resonhp(min(ma.SR/2.1, f*5.0), 0.95, 0.4*punch);
    
    // DARK METAL IMPLEMENTATION (Plate-like)
    dark_metal(f) = exciter(f, 0.3, 1.5) : dark_resonator(f) : dark_enhance(f);
    
    dark_resonator(f) = _ <: par(i, 8, dark_res(i, f)) :> _
    with {
        dark_res(i, f) = _ : (+(_' * dark_decay) ~ (delay_line(i, f) : damping(f) : metal_filter(i, f))) : *(gain(i))
        with {
            delay_line(i, f) = de.delay(4096, max(1, min(4096, ma.SR/(f * dark_ratio(i)))));
            damping(f) = fi.lowpass(1, min(ma.SR/2.1, f * 4)) : *(0.995);
            
            metal_filter(i, f) = fi.tf2(b0, b1, b2, a1, a2)
            with {
                omega = min(ma.PI*0.99, 2*ma.PI*f*dark_ratio(i)/ma.SR);
                q = 8;  // Lower Q for darker sound
                alpha = sin(omega)/(2*q);
                cosw = cos(omega);
                b0 = (1-alpha)/(1+alpha);
                b1 = -2*cosw/(1+alpha);
                b2 = 1;
                a1 = b1;
                a2 = b0;
            };

            // Dark metal ratios (more plate-like overtones)
            dark_ratio(0) = 1.00;    // Fundamental
            dark_ratio(1) = 1.28;    // Lower partial ratios
            dark_ratio(2) = 1.47;
            dark_ratio(3) = 1.71;
            dark_ratio(4) = 1.93;
            dark_ratio(5) = 2.13;
            dark_ratio(6) = 2.27;
            dark_ratio(7) = 2.39;

            gain(0) = 0.8 * (1 - darkness * 0.3);
            gain(1) = 0.6 * (1 - darkness * 0.2);
            gain(2) = 0.5 * (1 - darkness * 0.2);
            gain(3) = 0.4 * (1 - darkness * 0.1);
            gain(4) = 0.3 * (1 - darkness * 0.1);
            gain(5) = 0.2 * (1 - darkness * 0.1);
            gain(6) = 0.15 * (1 - darkness * 0.1);
            gain(7) = 0.1 * (1 - darkness * 0.1);
        };
    };
    
    dark_enhance(f) = _ : fi.resonhp(min(ma.SR/2.1, f*3.0), 0.92, 0.3*punch);
    
    // Shared exciter with adjustable parameters
    exciter(f, low_mult, high_mult) = _ : fi.bandpass(2, f*low_mult, f*high_mult) 
            : *(1 + punch)
            : *(2.0)
            : shape;
    
    shape = _ : *(2) : min(0.9) : max(-0.9);
};