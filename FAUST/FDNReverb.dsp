import("stdfaust.lib");
// User-controllable parameters
decayMs = hslider("Decay[unit:ms][style:knob]", 1000, 100, 10000, 1);
preDelayMs = hslider("Pre-Delay[unit:ms][style:knob]", 20, 0, 200, 1);
modDepth = hslider("Modulation Depth[unit:%][style:knob]", 0.5, 0, 2, 0.01) : *(0.01);
modRate = hslider("Modulation Rate[unit:Hz][style:knob]", 0.5, 0.1, 2, 0.1);
freeze = checkbox("Freeze[style:knob]") : si.smoo;
freezeInputMix = hslider("Freeze Input Mix[style:knob]", 0.5, 0, 1, 0.01) : si.smoo;
width = hslider("Width[style:knob]", 1, 0, 1, 0.01) : si.smoo; // debugging purpose

// Early Reflections with dynamic timing and gains based on decay
earlyReflections = par(i, 4, de.delay(ma.SR, delayTime(i)) * gain(i)) :> *(0.25) with {
    // Base delay times in milliseconds
    baseDelayRatios = (0.013, 0.017, 0.019, 0.023); // Represented as ratios of decay time
    minDelay = 10; // Minimum delay time in ms
    maxDelayRatio = 0.1; // Maximum delay time as ratio of decay time
    
    // Calculate delay time based on decay time and base ratios
    delayTime(i) = min(
        ba.take(i+1, baseDelayRatios) * decayMs,   // Proportional to decay
        maxDelayRatio * decayMs                     // Capped at max ratio
    ) : max(minDelay)                              // Ensure minimum delay
      * ma.SR / 1000.0;                           // Convert to samples
    
    // Dynamic gain calculation based on delay time and decay
    gain(i) = pow(0.7, (i+1)) * (1.0 - (delayTime(i)/(ma.SR/2)) * 0.3);
};

FDN = si.bus(2) : (preDelay, preDelay) <: (earlyReflections, earlyReflections, MIMO_Network ~ MATRIX) :> 
    stereoBalance : applyFilters with {
    // Filter bank crossover frequencies
    numBands = 4; // Number of frequency bands
    crossoverFreqs = (200, 800, 3200); // Crossover frequencies for 4 bands
    
    // Base decay ratios for each band - indexed using selectn
    baseDecayRatios = (1.2, 1.0, 0.8, 0.6);
    
    // Get decay ratio for a specific band
    getDecayRatio(band) = ba.selectn(4, band, baseDecayRatios);
    
    // Adapt decay ratio based on decay time
    adaptDecayRatio(ratio) = max(0.3, min(1.2, ratio - (decayMs - 1000) * 0.0002));
    
    // Pre-delay
    maxPreDelay = 200;
    preDelay = de.sdelay(ma.SR * maxPreDelay / 1000, 512, preDelayMs * ma.SR / 1000);
    
    // Calculate decay factor based on milliseconds and frequency band
    calcDecayFactor(delayLengthSamples, ratio) = 
        select2(freeze > 0.5,
            pow(0.001, delayLengthSamples / (decayMs * ratio * ma.SR / 1000.0)),
            1.0);
    
    // Matrix
    MATRIX = ro.hadamard(16) : par(i, 16, *(0.25));
    
    // Network
    MIMO_Network(fb1, fb2, fb3, fb4, fb5, fb6, fb7, fb8, fb9, fb10, fb11, fb12, fb13, fb14, fb15, fb16, in1, in2) =
        par(i, 16, DEL(i))
    with {
        baseDelaysMs = (61.1, 53.3, 80.3, 58.8, 55.0, 49.4, 75.4, 51.9, 66.7, 48.3, 63.5, 86.1, 70.5, 56.8, 50.7, 47.2);
        
        DEL(i) = de.fdelay(maxDelay, modulatedDelay(i), processInput(fb(i), input(i))) : multiband_decay
        with {
            maxDelay = 200 * ma.SR / 1000;
            delay = baseDelaysMs : ba.selectn(16, i) * ma.SR / 1000;
            modulatedDelay(i) = delay + os.osc(modRate + 0.01*i) * delay * modDepth;
            fb(i) = ba.selectn(16, i, fb1, fb2, fb3, fb4, fb5, fb6, fb7, fb8, fb9, fb10, fb11, fb12, fb13, fb14, fb15, fb16);
            
            // Balanced input distribution - first 8 lines get in1, next 8 get in2
            input(i) = select2(i < 8, 
                      select2(i >= 8, 0, in2 * 0.25), 
                      in1 * 0.25);
            
            // Input processing
            freezeGain = freeze * freezeInputMix;
            normalGain = 1.0 - freeze;
            processInput(fbSignal, inSignal) = fbSignal + (inSignal * (normalGain + freezeGain));
            
            // Multi-band decay using filterbank
            multiband_decay = _ <: fi.filterbank(3, crossoverFreqs) : 
                par(i, numBands, * (calcDecayFactor(delay, adaptDecayRatio(getDecayRatio(i))))) :> _;
        };
    };
    
    // Stereo balance control
    stereoBalance(l, r) = l * (1 + comp), r * (1 - comp)
    with {
        comp = (1 - width) * 0.5;
    };
    
    // Final filtering with separate stereo filters
    applyFilters = fi.lowpass(2, 18000), fi.lowpass(2, 18000) : fi.highpass(2, 20), fi.highpass(2, 20);
};

process = FDN;