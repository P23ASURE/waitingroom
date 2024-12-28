import("stdfaust.lib");

declare options "[midi:on]";

process = pluckOsc * envelope : *(mainVolume) 
    <: stereoDelay : stereoFilter : stereoCompress with {
    
    // Main Controls Group
    mainVolume = vgroup("1_MAIN", hslider("[0]Volume[style:knob]", 1.0, 0, 1.5, 0.01));
    gate = vgroup("1_MAIN", button("[1]Gate"));
    freq = vgroup("1_MAIN", hslider("[2]Frequency[style:knob]", 55, 20, 500, 1));
    
    // Oscillator Mix Group
    noiseMix = vgroup("2_OSC", hslider("[0]Noise[style:knob]", 0.7, 0, 1, 0.01));
    sawMix = vgroup("2_OSC", hslider("[1]Saw[style:knob]", 0.3, 0, 1, 0.01));
    pluckOsc = no.noise * noiseMix + os.sawtooth(freq) * sawMix;
    
    // Envelope Group
    attackTime = vgroup("3_ENV", hslider("[0]Attack[style:knob]", 0.001, 0.001, 0.1, 0.001));
    decayTime = vgroup("3_ENV", hslider("[1]Decay[style:knob]", 0.04, 0.01, 0.5, 0.01));
    sustainLength = vgroup("3_ENV", hslider("[2]Sustain[style:knob]", 0.15, 0.05, 1.0, 0.01));
    envelope = gate : en.ar(attackTime, decayTime) * (gate : en.ar(attackTime, sustainLength));
    
    // Delay Group
    delayLength = int(max(1, ma.SR/freq));
    feedback = vgroup("4_DELAY", hslider("[0]Amount[style:knob]", 0.9995, 0.95, 0.9999, 0.0001));
    stereoWidth = vgroup("4_DELAY", hslider("[1]Width[style:knob]", 1, 0, 3, 0.1));
    feedbackMult = vgroup("4_DELAY", hslider("[2]Boost[style:knob]", 1.2, 1.0, 1.5, 0.01));
    
    stereoDelay = (
        (+ : @(delayLength)) ~ (*(feedback * gate * feedbackMult)),
        (+ : @(delayLength + stereoWidth)) ~ (*(feedback * 0.99 * gate * feedbackMult))
    );
    
    // Filter Group
    cutoff = vgroup("5_FILTER", hslider("[0]Cutoff[style:knob]", 6000, 1000, 10000, 100));
    resonance = vgroup("5_FILTER", hslider("[1]Res[style:knob]", 3000, 500, 8000, 100));
    qFactor = vgroup("5_FILTER", hslider("[2]Q[style:knob]", 8, 1, 12, 0.1));
    filterMix = vgroup("5_FILTER", hslider("[3]Mix[style:knob]", 0.7, 0, 1, 0.01));
    
    stereoFilter = 
        (fi.lowpass(3, cutoff) : fi.resonlp(resonance, qFactor, filterMix)),
        (fi.lowpass(3, cutoff * 1.03) : fi.resonlp(resonance * 1.07, qFactor * 1.025, filterMix));
    
    // Compressor Group
    ratio = vgroup("6_COMP", hslider("[0]Ratio[style:knob]", 6, 2, 20, 0.1));
    threshold = vgroup("6_COMP", hslider("[1]Thresh[style:knob]", -18, -40, -6, 1));
    attack = vgroup("6_COMP", hslider("[2]Attack[style:knob]", 0.1, 0.001, 0.5, 0.001));
    release = vgroup("6_COMP", hslider("[3]Release[style:knob]", 0.005, 0.001, 0.1, 0.001));
    
    stereoCompress = co.compressor_stereo(ratio, threshold, attack, release);
};