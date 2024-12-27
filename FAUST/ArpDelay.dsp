import("stdfaust.lib");

declare name "Arp Delay - Multitap pitch control";
declare version "0.2a";

process = _ <: (dry_path, wet_path) :> _ with {
    // Global UI group for timing controls
    timing_group(x) = hgroup("[0]Timing", x);
    bpm = timing_group(hslider("[0]BPM[style:knob]", 120, 40, 200, 1));
    subdivision = timing_group(hslider("[1]Note Division[style:knob]", 4, 1, 16, 1));
    
    // Global UI group for mix controls
    mix_group(x) = hgroup("[1]Mix", x);
    feedback = mix_group(hslider("[0]Feedback[style:knob]", 0.7, 0, 0.95, 0.01));
    wet_gain = mix_group(hslider("[1]Wet/Dry[style:knob]", 0.5, 0, 1, 0.01));
    
    // Calculate timing based on BPM
    beat_duration = 60.0 / bpm;
    maxtime = beat_duration * 16;
    delay_time = beat_duration / subdivision;
    
    // Completely dry path - unprocessed original signal
    dry_path = _ * (1 - wet_gain);
    
    // Wet path - ONLY delayed and pitched echoes
    wet_path = _ * wet_gain : multi_tap;
    
    // Multi-tap delay implementation with pitch shifting
    multi_tap = _ <: par(i, 15, single_tap(i+1)) :> _  // Note: starting from i+1
    with {
        // UI group for each tap's parameters
        tap_group(i, x) = vgroup(
            "[2]Taps", 
            hgroup("[%i]Tap %i", x)
        );
        
        single_tap(index) = _ : 
            // Create echo with minimum 1-unit delay to ensure no direct signal
            de.delay(ma.SR * maxtime, max(1, int(ma.SR * delay_time * index))) :
            // Pitch shift the echo
            ef.transpose(window_size, hop_size, shift_ratio(index)) :
            // Apply gain and feedback
            *(gain_control(index)) * feedback
        with {
            window_size = 2048; // need to improve this and make it dynamic
            hop_size = 512;	// also this
            
            shift_ratio(tap) = 
                tap_group(
                    tap,
                    vslider(
                        "[0]Pitch (Semitones)[style:knob]", 
                        0, -12, 12, 1
                    ) : ba.semi2ratio
                );
                
            gain_control(tap) = 
                tap_group(
                    tap,
                    vslider(
                        "[1]Level[style:knob]", 
                        1.0, 0, 1, 0.01
                    )
                );
        };
    };
};